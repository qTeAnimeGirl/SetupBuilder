import 'package:flutter/cupertino.dart';
import 'package:setup/config/theme_config.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final bool active;
  final bool clicable;
  final double borderRadius;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.height, required this.width, required this.active, required this.onTap, required this.title, required this.clicable, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if(clicable)
          {
            onTap()
          }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          alignment: Alignment.center,
          duration: const Duration(microseconds: 200),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: active ? ThemeConfig().buttonActive : ThemeConfig().buttonDeactivated,
            borderRadius: BorderRadius.circular(borderRadius)
          ),
          child: Text(
              title,
              style: TextStyle(
                  height: 0.8,
                  color: ThemeConfig().buttonText,
                  fontSize: 16,
                  fontFamily: "Inter"
              )
          ),
        ),
      ),
    );
  }
}
