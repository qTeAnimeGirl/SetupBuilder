import 'package:flutter/cupertino.dart';

import '../config/theme_config.dart';

class Logo extends StatelessWidget {
  final String title;
  final String subtitle;
  const Logo({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            title,
            style: TextStyle(
                height: 0.9,
                color: ThemeConfig().accent,
                fontSize: 32,
                fontFamily: "Inter"
            )
        ),

        Text(
            subtitle,
            style: TextStyle(
                height: 0.9,
                color: ThemeConfig().subAccent,
                fontSize: 16,
                fontFamily: "Inter"
            )
        )
      ],
    );
  }
}
