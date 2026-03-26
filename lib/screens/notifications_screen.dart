import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = AppData.notifications.sublist(0, 3);
    final yesterday = AppData.notifications.sublist(3);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Notifications',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      'Mark all read',
                      style: GoogleFonts.dmSans(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today label
                    _SectionLabel('Today'),
                    ...today.map((n) => _NotifItem(notif: n)),

                    // Yesterday label
                    _SectionLabel('Yesterday'),
                    ...yesterday.map((n) => _NotifItem(notif: n)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.06,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final NotifModel notif;
  const _NotifItem({required this.notif});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border:
            Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notif.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(notif.icon, size: 20, color: notif.iconColor),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(notif.body,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(notif.time,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),

          // Unread dot
          if (notif.hasUnread) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
