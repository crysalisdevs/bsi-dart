// TODO: add license here...

library bsi;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'src/misc.dart';

part 'src/bsi.dart';
part 'src/mqtt.dart';
part 'src/bsi_configuration.dart';
part 'src/reference.dart';
part 'src/service.dart';
part 'src/services.dart';
part 'src/state.dart';
part 'src/outgoing_message.dart';
part 'src/hardware.dart';

// TODO: pub upgrade runtime
// TODO: change BSI readme to use latest BSI.initialize()
// TODO: have sample BSI config loading and auth data loading
// TODO: remove deprecated ServiceMessage and notify functions
// TODO: use yaml_encode after makig packg
// TODO: previously made json messages can be ignored as json is valid yaml
// TODO: update readme's onReceive.print.
