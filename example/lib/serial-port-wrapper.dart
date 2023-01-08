import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialPortWrapper {
  static List<String> getAvailablePorts() {
    return SerialPort.availablePorts;
  }

  static SerialPort getSerialPort(String port) {
    return SerialPort(port);
  }

  static String filterPortByManufacturer(String manufacturer) {
    return SerialPort.availablePorts
        .where((address) => SerialPort(address).manufacturer == manufacturer)
        .first;
  }

  static Uint8List readDataFromSerialPort(SerialPort port,
      int expectedNumberOfBytes, int suitableReadDataDelayInMillisecond) {
    var buffer = Uint8List(0);
    while (buffer.length == 0) {
      buffer = port.read(expectedNumberOfBytes,
          timeout: suitableReadDataDelayInMillisecond);
      port.drain();
      port.flush();
      if (buffer.length > 0) {
        print('serialport data is: $buffer');
      }
    }

    return buffer;
  }
}
