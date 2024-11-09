import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:setup/config/installer_config.dart';
import 'package:setup/config/theme_config.dart';
import 'package:setup/controllers/installer_controller.dart';
import 'package:setup/widgets/custom_button.dart';
import 'package:window_manager/window_manager.dart';

class FolderPicker extends StatefulWidget {
  final InstallerController installerController;
  final VoidCallback update;
  const FolderPicker({super.key, required this.update, required this.installerController});

  @override
  State<FolderPicker> createState() => _FolderPickerState();
}

class _FolderPickerState extends State<FolderPicker> {

  Future<void> changePath()
  async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(initialDirectory: "C:\\");

    if (selectedDirectory == null) {
      return;
    }

    if (selectedDirectory.endsWith(r'\')) {
      selectedDirectory = selectedDirectory.substring(0, selectedDirectory.length - 1);
    }

    widget.installerController.changePath(path: "$selectedDirectory\\${InstallerConfig().folderName}\\");
    widget.update();
  }

  String cut(String text)
  {
    if(text.length > 35)
      {
        return "...${text.substring(text.length - 35)}";
      }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DragToMoveArea(
          child: Container(
              alignment: Alignment.centerLeft,
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  color: ThemeConfig().textField,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  cut(widget.installerController.outputPath),
                  style: TextStyle(
                      height: 0.8,
                      color: ThemeConfig().textColor,
                      fontSize: 16,
                      fontFamily: "Inter"
                  ),
                ),
              )
          ),
        ),

        const SizedBox(width: 10),

        CustomButton(
            height: 50,
            width: 100,
            active: false,
            onTap: () => {
              changePath()
            },
            clicable: true,
            title: InstallerConfig().changeButton
        )
      ],
    );
  }
}
