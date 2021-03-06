part of bsi;

abstract class Service {
  /// Default constructor for [Service].
  ///
  /// Registers onMessage stream controller's sink for listening to messages
  /// related to [context].
  Service() {
    BSI.instance.hook(reference, sink: _onReceiveSink);
    _onReceive.listen(handleServiceMessage);
  }

  /// Provides a handle for BakeCode services.
  ///
  /// Path makes every [Service]s to be identifiable.
  ServiceReference get reference;

  /// The reference to the [state]s of the service.
  ServiceReference get states => reference['state'];

  /// Exposes all incoming messages on this service.
  ///
  /// Listen to messages that is addressed to this service.
  Stream<String> get _onReceive => _onReceiveController.stream;

  /// Handles the service message.
  @mustCallSuper
  @protected
  void handleServiceMessage(String message) {}

  static const _defaultSendOptions =
      const SendOptions(important: true, retain: false);

  /// Sends the message to the destinations specified in the message.
  ///
  /// Sends by adding the message to the [BSI.instance]'s outbox.
  @nonVirtual
  void send(
    String message, {
    @required Iterable<ServiceReference> destinations,
    SendOptions options = _defaultSendOptions,
  }) =>
      BSI.instance.outbox.add(_OutgoingMessage(
        message,
        source: reference,
        destinations: destinations,
        options: options,
      ));

  /// Sink of [_onReceiveController].
  StreamSink<String> get _onReceiveSink => _onReceiveController.sink;

  /// Stream controller for on message events.
  final _onReceiveController = StreamController<String>();

  /// Update [State]s of the service.
  @protected
  @nonVirtual
  void set(Map<State, dynamic> diff) => diff
    // Filters out unchanged states.
    ..removeWhere((state, newValue) => '$state' == '$newValue')
    // Updates every state that has change.
    ..forEach((state, newValue) {
      state.value = '$newValue';
      send(
        '$newValue',
        destinations: [states[state.identifier]],
      ); // TODO: conditionally modify send Options.
    });

  @protected
  @mustCallSuper
  void initState() {}
}
