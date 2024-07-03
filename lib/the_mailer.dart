library the_mailer;

import 'the_mailer_platform_interface.dart';

class MailSender {
  Future<String?> getPlatformVersion() {
    return TheMailerPlatform.instance.getPlatformVersion();
  }

  Future<void> send({
    required List<String> recipient,
    required String subject,
    required String body,
    String? attachment,
    List<String>? cc,
    List<String>? bcc,
  }) {
    return TheMailerPlatform.instance.sendMail(recipient, subject, body, attachment, cc, bcc);
  }
}
