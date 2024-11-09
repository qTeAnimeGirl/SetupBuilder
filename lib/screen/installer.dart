import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:setup/config/installer_config.dart';
import 'package:setup/config/theme_config.dart';
import 'package:setup/controllers/installer_controller.dart';
import 'package:setup/widgets/custom_button.dart';
import 'package:setup/widgets/folder_picker.dart';
import 'package:setup/widgets/logo.dart';
import 'package:setup/widgets/progress_bar.dart';
import 'package:window_manager/window_manager.dart';

class InstallerScreen extends StatefulWidget {
  const InstallerScreen({super.key});

  @override
  State<InstallerScreen> createState() => _InstallerScreenState();
}

class _InstallerScreenState extends State<InstallerScreen> with WindowListener {

  late InstallerController installerController;

  void update()
  {
    setState(() {});
  }

  @override
  void initState() {
    windowManager.addListener(this);
    installerController = InstallerController(updatePage: update);
    super.initState();
  }


  @override
  Future<void> onWindowMaximize() async {
    super.onWindowMaximize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeConfig().backgroundColor,
        body: Stack(
          children: [
            DragToMoveArea(
              child: Container(),
            ),

            Column(
              children: [
                WindowTitleBarBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MinimizeWindowButton(),
                      AbsorbPointer(
                        absorbing: installerController.isStarted
                            ? installerController.isFinished
                            ? false
                            : true
                            : false,
                        child: CloseWindowButton(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DragToMoveArea(
                          child: Logo(title: InstallerConfig().title, subtitle: InstallerConfig().subTitle),
                        ),

                        const SizedBox(height: 20),

                        installerController.isStarted ?
                        ProgressBar(installerController: installerController) :
                        FolderPicker(installerController: installerController, update: update),

                        const SizedBox(height: 20),

                        CustomButton(
                            height: 50,
                            width: 100,
                            borderRadius: 20,
                            active: installerController.isStarted ?
                            installerController.isFinished ? true : false :
                            true,
                            onTap: () => {
                              setState(() {
                                installerController.unpack();
                              })
                            },
                            title: installerController.isStarted ? InstallerConfig().closeButton : InstallerConfig().installButton,
                            clicable: installerController.isStarted ?
                            installerController.isFinished ? true : false :
                            true
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        )
    );
  }
}
