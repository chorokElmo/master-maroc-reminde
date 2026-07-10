import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

/// Displays the same policy text shipped as `PRIVACY_POLICY.md` at the
/// project root, so the in-app copy and the hosted document never drift
/// apart — update one, update the other.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(context.horizontalPadding(), 16, context.horizontalPadding(), 40),
        children: [
          Text('Last updated: July 2026', style: context.textStyles.bodySmall
              ?.copyWith(color: context.colors.onSurfaceVariant)),
          const SizedBox(height: 20),
          _Section(
            title: 'The short version',
            body: 'Master Maroc Reminder is designed to work fully offline. Your favorites, '
                'documents, application progress, and preferences are stored only on your '
                'device. We do not run analytics, advertising, or tracking SDKs of any kind. '
                'Nothing you save is sent to us — because we don\'t operate a server that '
                'receives it.',
          ),
          _Section(
            title: 'Program listings',
            body: 'To show you Master\'s program announcements, the app fetches public pages '
                'from orientation-chabab.com and almaster-maroc.com directly from your device. '
                'This means those sites can see your device\'s IP address when a refresh happens, '
                'the same as visiting them in a browser would. We don\'t control those sites\' own '
                'data practices — check their policies if you have concerns there.',
          ),
          _Section(
            title: 'Documents you upload',
            body: 'Files you attach (diploma, transcript, CV, ID, photos, certificates) are copied '
                'into this app\'s private storage on your device only. They are never uploaded to '
                'any server by this app. Deleting the app deletes them. If you use your device\'s '
                'own backup system (e.g. Google Drive device backup, iCloud), your device\'s '
                'OS-level backup may include them — that\'s standard device backup behavior, not '
                'something this app initiates separately.',
          ),
          _Section(
            title: 'Favorites, tracker status, and preferences',
            body: 'Stored locally in an on-device database (Hive). The "Backup my data" feature in '
                'Settings lets you export this to a JSON file that you explicitly choose where to '
                'send (your own cloud storage, email to yourself, etc.) — we don\'t receive a copy.',
          ),
          _Section(
            title: 'If you sign in',
            body: 'Sign-in is optional and, in this build, may not be available at all depending on '
                'configuration. When enabled, authentication is handled by Firebase Authentication '
                '(a Google service): your email address, and display name if you provide one, are '
                'sent to and stored by Firebase under Google\'s privacy terms. We do not receive or '
                'store your password — Firebase handles that directly. If push notifications are '
                'enabled, a device token is generated and registered with Firebase Cloud Messaging '
                'so we can deliver deadline alerts even when the app is closed.',
          ),
          _Section(
            title: 'Notifications',
            body: 'Deadline reminders you schedule are handled entirely on-device by your '
                'operating system\'s local notification system. Scheduling a reminder does not '
                'transmit anything anywhere.',
          ),
          _Section(
            title: 'Children',
            body: 'This app is intended for prospective graduate students and is not directed at '
                'children under 13.',
          ),
          _Section(
            title: 'Changes to this policy',
            body: 'If what the app collects or how it\'s handled changes, this page and the '
                'in-app copy will be updated together, along with the "Last updated" date above.',
          ),
          _Section(
            title: 'Contact',
            body: 'Questions about this policy can be directed to the app\'s publisher through '
                'the contact details listed on its Play Store / App Store listing.',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textStyles.titleMedium),
          const SizedBox(height: 8),
          Text(
            body,
            style: context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
