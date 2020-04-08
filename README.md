# flutter_esc_printer

Flutter ESC Printer originally inpire from esc_pos_utils flutter_bluetooth_serial. It can be used to print vai bluetooth mac address or network ip address.

## Getting Started

```
    _testPrint() async {
    const PaperSize paper = PaperSize.mm80;
    String address = "DC:0D:30:8A:B7:56"; // 192.168.10.10
    if(address.isIpAddress){
      //print vai ip address
      
        PrinterNetworkManager _printerNetworkManager = PrinterNetworkManager();
      _printerNetworkManager.selectPrinter(address);
      final res = await _printerNetworkManager.printTicket(await testTicket(paper));

      print(res.msg);
      
    }else if(address.isMacAddress) {
      //print vai mac address
      PrinterBluetoothManager _printerBluetoothManager = PrinterBluetoothManager();
      _printerBluetoothManager.selectPrinter(address);
      final res = await _printerBluetoothManager.printTicket(await testTicket(paper));
      
      print(res.msg);
    
    }else{
      //print("Error :e");
    }
  }
```