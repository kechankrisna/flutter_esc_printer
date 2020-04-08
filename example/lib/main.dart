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
  
  Future<Ticket> testTicket(PaperSize paper) async {
    final Ticket ticket = Ticket(paper);

    ticket.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: PosCodeTable.westEur));
    ticket.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: PosCodeTable.westEur));

    ticket.text('Bold text', styles: PosStyles(bold: true));
    ticket.text('Reverse text', styles: PosStyles(reverse: true));
    ticket.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
    ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
    ticket.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    ticket.feed(2);

    ticket.cut();
    return ticket;
  }

  _testPrint() async {
    const PaperSize paper = PaperSize.mm80;
    String address = "DC:0D:30:8A:B7:56"; // 192.168.10.10
    if(address.isIpAddress){
      //print vai ip address
      _printerNetworkManager.selectPrinter(address);
      final res = await _printerNetworkManager.printTicket(await testTicket(paper));
      
    }else if(address.isMacAddress) {
      //print vai mac address
      _printerBluetoothManager.selectPrinter(address);
      final res = await _printerBluetoothManager.printTicket(await testTicket(paper));
    
    }else{
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
          child: RaisedButton(onPressed: () {
            _testPrint();
          }, child: Text("PRINT")),
        ),
      ),
    );
  }
}
