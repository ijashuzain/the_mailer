library the_mailer;

import 'dart:developer';

import 'package:flutter/services.dart';

class TheMailer {
  static const MethodChannel _channel = MethodChannel('the_mailer');

  static Future<bool> send({
    required List<String> to,
    List<String> cc = const [],
    List<String> bcc = const [],
    required String subject,
    required String body,
    List<String> attachmentPaths = const [],
  }) async {
    try {
      final bool result = await _channel.invokeMethod('sendMail', {
        'to': to,
        'cc': cc,
        'bcc': bcc,
        'subject': subject,
        'body': body,
        'attachments': attachmentPaths,
      });
      return result;
    } on PlatformException catch (e) {
      log("Failed to send email: '${e.message}'.");
      return false;
    }
  }
}