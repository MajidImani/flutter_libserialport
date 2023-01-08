import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_libserialport_example/extensions.dart';
import 'package:flutter_libserialport_example/serial-port-wrapper.dart';

import 'card-list-title.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  var port;

  @override
  void initState() {
    super.initState();
    initPorts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Serial Port example'),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              for (final address in SerialPortWrapper.getAvailablePorts())
                Builder(builder: (context) {
                  final port = SerialPortWrapper.getSerialPort(address);
                  return ExpansionTile(
                    title: Text(address),
                    children: [
                      CardListTile('Description', port.description),
                      CardListTile('Transport', port.transport.toTransport()),
                      CardListTile('USB Bus', port.busNumber?.toPadded()),
                      CardListTile('USB Device', port.deviceNumber?.toPadded()),
                      CardListTile('Vendor ID', port.vendorId?.toHex()),
                      CardListTile('Product ID', port.productId?.toHex()),
                      CardListTile('Manufacturer', port.manufacturer),
                      CardListTile('Product Name', port.productName),
                      CardListTile('Serial Number', port.serialNumber),
                      CardListTile('MAC Address', port.macAddress),
                    ],
                  );
                }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: sendCommand,
          tooltip: "Send Commands",
        ),
      ),
    );
  }

  Future initPorts() async {
    try {
      var port = SerialPortWrapper.getSerialPort(
          SerialPortWrapper.filterPortByManufacturer("Tector"));

      setState(() => this.port = port);

      print('manufacturer: ${port.manufacturer}');
      if (!port.openReadWrite()) {
        //print(SerialPort.lastError);
        exit(-1);
      }

      //SerialPortReader reader = SerialPortReader(this.port);
      // reader.stream.listen((data) {
      //   print('Received: $data');
      // });
    } on SerialPortError catch (err, _) {
      print(SerialPort.lastError);
    }
  }

  Future sendCommand() async {
    //TODO
    //For privacy reaons source codes are removed
  }
}
