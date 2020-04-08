import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './enums.dart';

/// Printer Bluetooth Manager
class PrinterBluetoothManager {
  String _host;
  int _port;
  Duration _timeout;

  // BluetoothConnection connection;

  /// Select a network printer
  ///
  /// [timeout] is used to specify the maximum allowed time to wait
  /// for a connection to be established.
  void selectPrinter(
    String host, {
    int port = 9100,
    Duration timeout = const Duration(seconds: 5),
  }) {
    _host = host;
    _port = port;
  }

  Future<PosPrintResult> printTicket(Ticket ticket,{int chunkSizeBytes = 50, int queueSleepTimeMs = 1}) async {
    if (_host == null || _port == null) {
      return Future<PosPrintResult>.value(PosPrintResult.printerNotSelected);
    } else if (ticket == null || ticket.bytes.isEmpty) {
      return Future<PosPrintResult>.value(PosPrintResult.ticketEmpty);
    }
    //print code
    // print(Uint8List.fromList(ticket.bytes));

    final List<List<int>> chunks = [];

    final len = ticket.bytes.length;

    //check if total length is lower than chunkSize
    if(ticket.bytes.length <= chunkSizeBytes){
      chunks.add( ticket.bytes );
    }else{
      for (var i = 0; i < len; i += chunkSizeBytes) {
        final end = (i + chunkSizeBytes < len) ? i + chunkSizeBytes : len;
        chunks.add(ticket.bytes.sublist(i, end));
      }
    }

    // print("splited into chunks completed");
    _timeout = Duration(milliseconds: (chunks.length * queueSleepTimeMs) + 1000);  //5000 is more delay to avoid error
    try {
      final BluetoothConnection connection = await BluetoothConnection.toAddress(_host);
      print('Connected to the device');
      if (connection.isConnected) {
        print("connection is connected");
        for (List<int> data in chunks) {
          connection.output.add(Uint8List.fromList(data));
          await connection.output.allSent;
          sleep(Duration(milliseconds: queueSleepTimeMs));
        }
        
        // print('size ${ticket.bytes.length}');
        Future.delayed(_timeout).then((value) => connection.close());
      }

      return Future<PosPrintResult>.value(PosPrintResult.success);
    } catch (e) {
      print('Error: $e');
      return Future<PosPrintResult>.value(PosPrintResult.timeout);
    }
  }
}