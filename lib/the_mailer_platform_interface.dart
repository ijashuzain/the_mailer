import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'the_mailer_method_channel.dart';

abstract class TheMailerPlatform extends PlatformInterface {
  /// Constructs a MailSenderPlatform.
  TheMailerPlatform() : super(token: _token);

  static final Object _token = Object();

  static TheMailerPlatform _instance = MethodChannelTheMailer();

  /// The default instance of [MailSenderPlatform] to use.
  ///
  /// Defaults to [MethodChannelMailSender].
  static TheMailerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MailSenderPlatform] when
  /// they register themselves.
  static set instance(TheMailerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> sendMail(List<String> emailAddress, String subject, String body,
      String? attachment, List<String>? cc, List<String>? bcc) {
    throw UnimplementedError('sendMail() has not been implemented.');
  }
}
