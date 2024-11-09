import 'package:flutter/cupertino.dart';
import 'package:setup/controllers/installer_controller.dart';

import '../config/theme_config.dart';

class ProgressBar extends StatelessWidget {
  final InstallerController installerController;
  const ProgressBar({super.key, required this.installerController});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.centerLeft,
      height: 50,
      width: 450,
      decoration: BoxDecoration(
          color: ThemeConfig().progressBackground,
          borderRadius: BorderRadius.circular(30)
      ),

      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.centerLeft,
            height: 50,
            width: (450 * (installerController.progress / 100)),
            decoration: BoxDecoration(
                color: ThemeConfig().progressForeground,
                borderRadius: BorderRadius.circular(0)
            ),
          ),

          Container(
            alignment: Alignment.center,
            height: 50,
            width: 450,
            child: Text(
                ("${installerController.progress.toStringAsFixed(2)}%"),
                style: TextStyle(
                    height: 0.9,
                    color: ThemeConfig().progressText,
                    fontSize: 20,
                    fontFamily: "Inter"
                )
            ),
          )
        ],
      ),
    );
  }
}
