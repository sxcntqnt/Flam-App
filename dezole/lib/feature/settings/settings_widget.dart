import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Settings',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.person,
              title: 'Profile',
              subtitle: 'Manage your profile information',
            ),
            _SettingsTile(
              icon: Icons.security,
              title: 'Security',
              subtitle: 'Password and authentication',
            ),
            _SettingsTile(
              icon: Icons.payment,
              title: 'Payment Methods',
              subtitle: 'Manage payment options',
            ),
            const SizedBox(height: 24),
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage notification settings',
            ),
            _SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English',
            ),
            _SettingsTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              subtitle: 'Coming soon',
            ),
            const SizedBox(height: 24),
            Text('Support', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.help,
              title: 'Help Center',
              subtitle: 'Get help with your account',
            ),
            _SettingsTile(
              icon: Icons.info,
              title: 'About',
              subtitle: 'Version 1.0.0',
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: CustomTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomTheme.lightGray),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CustomTheme.secondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: CustomTheme.appColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: CustomTheme.gray, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: CustomTheme.gray),
        onTap: () {},
      ),
    );
  }
}
