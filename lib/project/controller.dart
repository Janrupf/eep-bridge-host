import 'dart:async';
import 'dart:io';

import 'package:eep_bridge_host/logging/logger.dart';
import 'package:eep_bridge_host/network/event/server_events.dart';
import 'package:eep_bridge_host/project/meta.dart';
import 'package:eep_bridge_host/project/project.dart';
import 'package:eep_bridge_host/protogen/project/project.pb.dart';
import 'package:eep_bridge_host/util/io.dart';
import 'package:eep_bridge_host/util/ui_messenger.dart';
import 'package:path_provider/path_provider.dart' as PathProvider;

class IdentifiedProjectMeta {
  final Directory directory;
  final ProjectMeta meta;

  IdentifiedProjectMeta(this.directory, this.meta);
}

/// Application global project controller.
class ProjectController {
  final Map<String, IdentifiedProjectMeta> _availableProjects;
  final Map<String, Project> _openedProjects;
  StreamSubscription<ServerEvent>? _subscription;

  ProjectController(Stream<ServerEvent> eventStream)
      : _availableProjects = {},
        _openedProjects = {} {
    _loadMeta()
        .then((value) => eventStream.listen(_onServerEvent))
        .then((value) => _subscription = value);
  }

  /// Loads the project metas from the project directory.
  Future _loadMeta() async {
    final projectsDirectory = await _getProjectsDirectory();

    if (!await projectsDirectory.exists()) {
      await projectsDirectory.create(recursive: true);
    }

    List<Future> loadFutures = [];
    await for (final entry in projectsDirectory.list()) {
      final absolutePath = entry.absolute.path;

      // Iterate and load all projects in the projects directory
      if (await FileSystemEntity.isDirectory(absolutePath)) {
        final loadFuture = _loadSingleMeta(Directory(absolutePath)).then(
            (meta) {
          _availableProjects[meta.meta.name] = meta;
        },
            onError: (error, trace) => Logger.error(
                "Failed to load project from $absolutePath", error, trace));

        loadFutures.add(loadFuture);
      }
    }

    return Future.wait(loadFutures);
  }

  /// Loads a single project meta entry from a [directory].
  Future<IdentifiedProjectMeta> _loadSingleMeta(Directory directory) async {
    final meta = MetaDirectory(directory);

    final projectMeta =
        await meta.load("project", (data) => ProjectMeta.fromBuffer(data));

    return IdentifiedProjectMeta(directory, projectMeta);
  }

  void _onServerEvent(ServerEvent event) {
    if (event is ClientConnectedEvent) {
      final handshake = event.handshake;

      _getOrOpenProject(handshake.projectIdentifier).then((project) {
        project.clientConnected(event.client);
      }, onError: (error) {
        event.client.handshakeFailed(error?.toString() ?? "Unknown error");
      });
    } else if (event is ClientDisconnectedEvent) {
      _openedProjects.forEach((_, project) {
        if (project.controlledBy(event.client)) {
          project.clientDisconnected();
          saveProject(project);
        }
      });
    }
  }

  /// Retrieves or opens a project.
  Future<Project> _getOrOpenProject(String name) {
    if (_openedProjects.containsKey(name)) {
      return Future.value(_openedProjects[name]);
    } else if (_availableProjects.containsKey(name)) {
      final identified = _availableProjects[name]!;
      return _openProject(identified).then((project) {
        UIMessenger.send(ShowProjectRequest(project));
        return _openedProjects[name] = project;
      });
    }

    return _create(name);
  }

  /// Opens a project and loads it from the file system.
  Future<Project> _openProject(IdentifiedProjectMeta identifiedMeta) {
    // final meta = MetaDirectory(directory);

    return Future.value(Project(meta: identifiedMeta));
  }

  /// Creates a project by dispatching a creation request to the UI.
  Future<Project> _create(String name) {
    final completer = Completer<Project>();
    UIMessenger.dispatch(CreateProjectRequest(name), (String? response) {
      if (response != null) {
        completer.complete(_createNow(response));
      } else {
        completer.completeError(
            ProjectCreationCancelledException("Creation cancelled by user"));
      }
    });

    return completer.future;
  }

  /// Creates and saves a project initially.
  Future<Project> _createNow(String name) async {
    Directory projectsDirectory = await _getProjectsDirectory();
    Directory newProjectDirectory = await projectsDirectory.availableChild();

    await newProjectDirectory.create(recursive: true);
    final metaDirectory = MetaDirectory(newProjectDirectory);

    final projectMeta = ProjectMeta(name: name);
    await metaDirectory.save("project", projectMeta);

    final identifiedMeta =
        IdentifiedProjectMeta(newProjectDirectory, projectMeta);

    _availableProjects[name] = identifiedMeta;
    return Project(meta: identifiedMeta);
  }

  /// Saves a project
  Future<void> saveProject(Project project) async {
    final identifiedMeta = project.prepareForSave();
    final metaDirectory = MetaDirectory(identifiedMeta.directory);
    await metaDirectory.save("project", identifiedMeta.meta);
  }

  Future<void> saveAll() async {
    await Future.wait(_openedProjects.values.map(saveProject));
  }

  /// Retrieves the directory to save projects into
  Future<Directory> _getProjectsDirectory() {
    if (Platform.isLinux) {
      String configBase = Platform.environment["XDG_CONFIG_DIR"] ??
          // Assume HOME is set, it is required on every POSIX system (and Linux)
          "${Platform.environment["HOME"]}/.config";

      return Future.value(Directory("$configBase/eep-bridge-host"));
    }

    return PathProvider.getApplicationDocumentsDirectory()
        .then((directory) => directory.join("projects"));
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}

class CreateProjectRequest {
  final String suggestedName;

  CreateProjectRequest(this.suggestedName);
}

class ShowProjectRequest {
  final Project project;

  ShowProjectRequest(this.project);
}

/// Exception thrown when the project creation is cancelled for some reason.
class ProjectCreationCancelledException implements Exception {
  /// The reason the project creation has been cancelled.
  final String reason;

  ProjectCreationCancelledException(this.reason);

  @override
  String toString() => reason;
}
