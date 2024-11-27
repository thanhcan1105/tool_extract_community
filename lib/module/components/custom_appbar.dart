

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? centerTitle;
  final Widget? leading;
  final double? elevationTabBar;
  final PreferredSizeWidget? bottomTabBar;
  final List<Widget>? actionsTabBar;
  final bool isShowLeading;
  final Function()? onBack;

  const CustomAppBar({
    Key? key,
    this.title,
    this.centerTitle,
    this.leading,
    this.elevationTabBar,
    this.bottomTabBar,
    this.actionsTabBar,
    this.isShowLeading = false,
    this.onBack,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: isShowLeading
          ? leading ??
          GestureDetector(
            onTap: onBack ??
                    () {
                  Navigator.of(context).pop();
                },
            child: Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage(kBackgroundBLL1),
                //   fit: BoxFit.fill,
                // ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          )
          : const SizedBox(),
      elevation: elevationTabBar ?? 0,
      title: Text(
        title!,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: centerTitle ?? true,
      bottom: bottomTabBar,
      actions: actionsTabBar,
    );
  }
}
