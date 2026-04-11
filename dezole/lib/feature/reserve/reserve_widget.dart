import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';
import 'package:dezole/common/widget/custom_button.dart';
import 'package:dezole/common/widget/custom_text_field.dart';

class ReserveWidget extends StatelessWidget {
  const ReserveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Reserve a Ride',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomTheme.appColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CustomTheme.appColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomTheme.appColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.book_online, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Schedule Your Ride',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Book in advance for peace of mind',
                          style: TextStyle(
                            color: CustomTheme.gray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pickup Location',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ReusableTextField(
              hintText: 'Enter pickup address',
              prefix: const Icon(
                Icons.location_on,
                color: CustomTheme.appColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Destination',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ReusableTextField(
              hintText: 'Enter destination address',
              prefix: const Icon(Icons.location_on, color: Colors.red),
            ),
            const SizedBox(height: 24),
            Text(
              'Date & Time',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CustomTheme.lightGray),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: CustomTheme.appColor,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                color: CustomTheme.gray,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              'Apr 15, 2026',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CustomTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CustomTheme.lightGray),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: CustomTheme.appColor,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                color: CustomTheme.gray,
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              '08:00 AM',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CustomTheme.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estimated Fare'),
                      Text(
                        'KSh 250',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.appColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price may vary based on traffic',
                    style: TextStyle(color: CustomTheme.gray, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomRoundedButtom(
              title: 'Confirm Reservation',
              onPressed: () {},
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }
}
