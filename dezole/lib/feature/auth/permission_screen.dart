import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dezole/common/constant/assets.dart';
import 'package:dezole/common/widget/page_wrapper.dart';
import 'package:dezole/common/widget/common_popup_box.dart';
import 'package:dezole/feature/auth/welcomeScreen/screen/welcome_page.dart';
import 'package:dezole/core/providers/permission_provider.dart';

class PermissionPage extends ConsumerStatefulWidget {
  const PermissionPage({super.key});

  @override
  ConsumerState<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends ConsumerState<PermissionPage> {
  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    final status = await Permission.location.status;
    if (status.isGranted && mounted) {
      _navigateToWelcome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: EdgeInsets.zero,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(Assets.mapImage),
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
              BlendMode.srcATop,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PopUpDialogWidget(
              title: "Enable your location",
              description:
                  "Choose your location to start finding requests around you.",
              disableButtonName: "",
              onDisablePressed: () {},
              onEnablePressed: _requestLocation,
              enableButtonName: "Enable",
              imageUrl: Assets.locationImage,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestLocation() async {
    await ref.read(permissionProvider.notifier).requestLocation();
    if (mounted) _navigateToWelcome();
  }

  void _navigateToWelcome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }
}
