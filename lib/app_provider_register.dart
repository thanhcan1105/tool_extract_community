import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../module/providers/upload_community_provider.dart';

class AppProviderRegister extends StatelessWidget {
  final Widget child;

  const AppProviderRegister({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UploadCommunityProvider()),
      ],
      child: child,
    );
  }
}
