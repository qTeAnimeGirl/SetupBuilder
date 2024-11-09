class InstallerConfig
{
  String defaultPath = "C:\\Program Files\\GrandTheftAutoVI\\";

  String title = "Grand Theft Auto VI";
  String subTitle = "INSTALLER";

  String changeButton = "CHANGE";
  String installButton = "INSTALL";
  String closeButton = "CLOSE";
  String folderName = "GrandTheftAutoVI";

  List<String> commands = [
    r'mkdir "C:\Program Files\ExampleFolder"',
  ];
}