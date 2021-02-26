import 'package:eep_bridge_host/network/bridge_client.dart';
import 'package:eep_bridge_host/protogen/project/project.pb.dart';
import 'package:eep_bridge_host/util/change_notifier.dart';

class Project {
  final ProjectMeta meta;
  final GenericChangeNotifier<BridgeClient?> client;

  Project({required this.meta}) : client = GenericChangeNotifier(value: null);
}
