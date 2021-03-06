import 'package:flutter/material.dart';
import 'package:flutter_esc_printer/flutter_esc_printer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PrinterBluetoothManager _printerBluetoothManager = PrinterBluetoothManager();
  PrinterNetworkManager _printerNetworkManager = PrinterNetworkManager();
  @override
  void initState() {
    super.initState();
  }

  Future<List<int>> testTicket(PaperSize paper) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final Generator generator = Generator(paper, profile);

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles.defaults());
    bytes +=
        generator.text('Special 2: blåbærgrød', styles: PosStyles.defaults());

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.feed(2);

    bytes += generator.cut();
    return bytes;
  }

  _testPrint() async {
    const PaperSize paper = PaperSize.mm80;
    String address = "DC:0D:30:8A:B7:56"; // 192.168.10.10
    if (address.isIpAddress) {
      //print vai ip address
      _printerNetworkManager.selectPrinter(address);
      final res = await _printerNetworkManager.printTicket(
          bytes: await testTicket(paper));
    } else if (address.isMacAddress) {
      //print vai mac address
      _printerBluetoothManager.selectPrinter(address);
      final res = await _printerBluetoothManager.printTicket(
          bytes: await testTicket(paper));
    } else {
      //print("Error :e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: () {
                _testPrint();
              },
              child: Text("PRINT")),
        ),
      ),
    );
  }
}
