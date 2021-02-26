import 'dart:async';

typedef void ResponseHandler<R>(R response);

/// Message event dispatched by the [UIMessenger] whenever a request is made.
class UIMessageEvent<P, R> {
  /// The payload of the message. Used for identifying handlers.
  final P payload;

  /// The id if the event, only interesting for the messenger or for debugging.
  final int id;

  UIMessageEvent(this.payload, this.id);

  /// Replies to this event.
  ///
  /// This may only be called once!
  void reply([R? response]) {
    if(id == -1) {
      throw StateError("This event does not expect a reply");
    }

    UIMessenger._dispatchResponse(id, response);
  }
}

/// Helper class for sending messages from the logic to the UI.
class UIMessenger {
  static StreamController<UIMessageEvent<dynamic, dynamic>>
      _eventStreamController = StreamController.broadcast(onCancel: _stop);

  static Stream<UIMessageEvent<dynamic, dynamic>> get eventStream =>
      _eventStreamController.stream;

  static int _nextId = 0;
  static Map<int, ResponseHandler<dynamic>> _handlers = {};

  /// Dispatches the [payload] through the message channel and installs
  /// a [handler] as the response acceptor.
  static void dispatch<P, R>(P payload, ResponseHandler<R> handler) {
    final id = _nextId++;
    _handlers[id] = (value) => handler(value);

    final event = UIMessageEvent<P, R>(payload, id);
    _eventStreamController.add(event);
  }

  /// Sends the [payload] through the message channel and does not expect
  /// a response.
  static void send<P>(P payload) {
    final event = UIMessageEvent<P, void>(payload, -1);
    _eventStreamController.add(event);
  }

  /// Closes the messenger when the stream is cancelled.
  static void _stop() {
    _eventStreamController.close();
  }

  /// Dispatches a [response] to an event identified by its [id].
  static void _dispatchResponse<R>(int id, [R? response]) {
    if (!_handlers.containsKey(id)) {
      throw ArgumentError("Tried to respond to event $id with $response, "
          "but the event has been responded to already");
    }

    _handlers.remove(id)!(response);
  }
}
