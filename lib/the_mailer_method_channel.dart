import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'the_mailer_platform_interface.dart';

/// An implementation of [MailSenderPlatform] that uses method channels.
class MethodChannelTheMailer extends TheMailerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mail_sender');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
    await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> sendMail(List<String> emailAddress, String subject, String body,
      String? attachment, List<String>? cc, List<String>? bcc) async {
    await methodChannel.invokeMethod<bool>('mail_sender', <String, dynamic>{
      "emailAddress": emailAddress,
      "subject": subject,
      "body": body,
      if (cc != null) "cc": cc,
      if (bcc != null) "bcc": bcc,
      if (attachment != null) "attachment": attachment,
    });
  }
}
