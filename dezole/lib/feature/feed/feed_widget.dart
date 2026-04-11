import 'package:flutter/material.dart';
import 'package:dezole/common/theme.dart';
import 'package:dezole/common/widget/page_wrapper.dart';

class FeedWidget extends StatelessWidget {
  const FeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      appbarTitle: 'Feed',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.directions_bus,
                          color: CustomTheme.appColor,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Matatu Express',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '2 hours ago',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'New route launched! Now serving Westlands to CBD every 15 minutes.',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Westlands → CBD',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _FeedCard(
              avatar: Icons.person,
              name: 'Jane Wanjiku',
              handle: '@janew',
              time: '4 hours ago',
              content:
                  'Just had the smoothest ride experience! Highly recommend the matatu app.',
              likes: 24,
              comments: 5,
            ),
            _FeedCard(
              avatar: Icons.directions_car,
              name: 'Matatu Pro',
              handle: '@matatupro',
              time: '6 hours ago',
              content:
                  'Reminder: Traffic advisory for Thika Road today. Plan your trips accordingly.',
              likes: 56,
              comments: 12,
            ),
            _FeedCard(
              avatar: Icons.local_offer,
              name: 'Dezole',
              handle: '@dezoleapp',
              time: '1 day ago',
              content:
                  'Subscribe to our premium plan and get 20% off on all rides this month!',
              likes: 89,
              comments: 23,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  final IconData avatar;
  final String name;
  final String handle;
  final String time;
  final String content;
  final int likes;
  final int comments;

  const _FeedCard({
    required this.avatar,
    required this.name,
    required this.handle,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CustomTheme.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: CustomTheme.secondaryColor,
                child: Icon(avatar, color: CustomTheme.appColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          handle,
                          style: TextStyle(
                            color: CustomTheme.gray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      time,
                      style: TextStyle(color: CustomTheme.gray, fontSize: 11),
                    ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            children: [
              _ActionButton(
                icon: Icons.favorite_border,
                label: '$likes',
                onTap: () {},
              ),
              const SizedBox(width: 24),
              _ActionButton(
                icon: Icons.chat_bubble_outline,
                label: '$comments',
                onTap: () {},
              ),
              const SizedBox(width: 24),
              _ActionButton(icon: Icons.share, label: 'Share', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: CustomTheme.gray),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: CustomTheme.gray, fontSize: 13)),
        ],
      ),
    );
  }
}
