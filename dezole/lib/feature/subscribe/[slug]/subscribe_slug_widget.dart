import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';
import 'package:dezole/common/widget/custom_button.dart';

class SubscribeSlugWidget extends StatelessWidget {
  final String slug;

  const SubscribeSlugWidget({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Subscription',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: CustomTheme.appColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomTheme.appColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Subscription Active',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slug.toUpperCase(),
                    style: TextStyle(
                      color: CustomTheme.appColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CustomTheme.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CustomTheme.lightGray),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Plan', value: slug.toUpperCase()),
                  _DetailRow(label: 'Price', value: 'KSh 999/month'),
                  _DetailRow(label: 'Start Date', value: 'April 1, 2026'),
                  _DetailRow(label: 'Next Billing', value: 'May 1, 2026'),
                  _DetailRow(label: 'Status', value: 'Active'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomRoundedButtom(
              title: 'Manage Subscription',
              onPressed: () {},
              color: CustomTheme.lightGray,
              textColor: CustomTheme.darkColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: CustomTheme.gray)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
