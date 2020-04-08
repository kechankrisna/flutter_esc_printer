import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import './enums.dart';
import 'dart:async';

/// Printer Network Manager
class PrinterNetworkManager {
  String _host;
  int _port;
  Duration _timeout;

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

  Future<PosPrintResult> printTicket(Ticket ticket,
      {int chunkSizeBytes = 50, int queueSleepTimeMs = 1}) async {
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
    if (ticket.bytes.length <= chunkSizeBytes) {
      chunks.add(ticket.bytes);
    } else {
      for (var i = 0; i < len; i += chunkSizeBytes) {
        final end = (i + chunkSizeBytes < len) ? i + chunkSizeBytes : len;
        chunks.add(ticket.bytes.sublist(i, end));
      }
    }
    // print("splited into chunks completed");
    _timeout = Duration(
        milliseconds: (chunks.length * queueSleepTimeMs) +
            5000); //5000 is more delay to avoid error
    try {
      final Socket socket = await Socket.connect(
        _host,
        _port,
        timeout: _timeout,
      );

      for (List<int> data in chunks) {
        socket.add(data);
        sleep(Duration(milliseconds: queueSleepTimeMs));
      }
      socket.destroy();

      // print('size ${ticket.bytes.length}');
      return Future<PosPrintResult>.value(PosPrintResult.success);
    } catch (e) {
      print('Error: $e');
      return Future<PosPrintResult>.value(PosPrintResult.timeout);
    }
  }
}
