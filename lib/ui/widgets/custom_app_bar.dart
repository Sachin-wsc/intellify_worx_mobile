import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({super.key, required this.title, this.showBackButton = true, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, // Don't show the default back button
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppTheme.background,
            shape: BoxShape.circle,
          ),
          child: Builder(
            builder: (innerContext) {
              return IconButton(
                icon: Image.asset('assets/images/Menu.png', height: 20, width: 20),
                onPressed: () {
                  Scaffold.of(innerContext).openDrawer();
                },
              );
            }
          ),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.textPrimary)),
      centerTitle: true,
      bottom: bottom,
      actions: [
        if (showBackButton)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.background,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset('assets/images/Logo-sqare.png', height: 24, width:100 ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
