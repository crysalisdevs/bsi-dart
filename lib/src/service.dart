part of bsi;

@immutable
abstract class Service {
  /// Default constructor for [Service].
  ///
  /// Registers onMessage stream controller's sink for listening to messages
  /// related to [context].
  Service() {
    BSI.instance.hook(this, sink: _onReceiveSink);
  }

  /// Provides a handle for BakeCode services.
  ///
  /// Path makes every [Service]s to be identifiable.
  ServiceReference get reference;

  /// The reference to the [state]s of the service.
  ServiceReference get states => reference['state'];

  /// Exposes all incoming messages for this service.
  ///
  /// Listen to messages that is addressed to this service.
  Stream<ServiceMessage> get onReceive => _onReceiveController.stream;

  /// Sends the message to the destinations specified in the message.
  ///
  /// Sends by adding the message to the [BSI.instance]'s outbox.
  @nonVirtual
  void send(ServiceMessage message) => BSI.instance.outbox.add(message);

  /// Sink of [_onReceiveController].
  StreamSink<ServiceMessage> get _onReceiveSink => _onReceiveController.sink;

  /// Stream controller for on message events.
  final _onReceiveController = StreamController<ServiceMessage>();

  /// Update [State]s of the service.
  @protected
  @nonVirtual
  void set(Map<State, dynamic> diff) => diff
    // Filters out unchanged states.
    ..removeWhere((state, newValue) => '$state' == '$newValue')
    // Updates every state that has change.
    ..forEach((state, newValue) {
      state.value = '$newValue';
      send(_StateUpdateMessage(states[state.identifier], '$newValue'));
    });
}
