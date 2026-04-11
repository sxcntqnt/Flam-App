import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';
import 'package:dezole/common/widget/custom_button.dart';

class SelectPlanWidget extends StatelessWidget {
  const SelectPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Select Plan',
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomTheme.appColor,
                    CustomTheme.appColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Go Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock exclusive features and savings',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _PlanCard(
              name: 'Basic',
              price: 'Free',
              features: ['Standard rides', 'Basic support', 'Wallet access'],
              isRecommended: false,
            ),
            _PlanCard(
              name: 'Premium',
              price: 'KSh 999/mo',
              features: [
                'Priority matching',
                '24/7 support',
                '10% ride discounts',
                'Premium features',
              ],
              isRecommended: true,
            ),
            _PlanCard(
              name: 'Pro',
              price: 'KSh 1,999/mo',
              features: [
                'Everything in Premium',
                'Unlimited rides',
                'Exclusive events access',
                'Dedicated account manager',
              ],
              isRecommended: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool isRecommended;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.features,
    required this.isRecommended,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CustomTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecommended ? CustomTheme.appColor : CustomTheme.lightGray,
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              if (isRecommended)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: CustomTheme.appColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Recommended',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            price,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: CustomTheme.appColor,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: CustomTheme.appColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(feature),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          CustomRoundedButtom(
            title: isRecommended ? 'Get Started' : 'Choose Plan',
            onPressed: () {},
            color: isRecommended ? CustomTheme.appColor : CustomTheme.lightGray,
            textColor: isRecommended ? Colors.white : CustomTheme.darkColor,
          ),
        ],
      ),
    );
  }
}
