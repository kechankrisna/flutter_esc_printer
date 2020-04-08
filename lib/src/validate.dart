//validate ip address
void isIpAddress() {
  RegExp reg = RegExp(
      "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\$");
  String value = "192.168.10.10";
  print(value.contains(reg));
}

void main(List<String> args) {
  String value = "DC:0D:30:8A:B7:56";
  print(value.isMacAddress);
}

extension flutter_esc_printer on String {
  bool get isIpAddress {
    RegExp reg = RegExp(
        "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\$");
    //String value = "192.168.10.10";
    return this.contains(reg);
  }

  bool get isMacAddress {
    RegExp reg =
        RegExp("^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])\$");
    //String value = "01:23:45:67:89:ab";
    return this.contains(reg);
  }
}
