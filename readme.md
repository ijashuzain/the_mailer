# The Mailer
A Flutter plugin for sending emails using the device’s default email app. This package supports multiple recipients, CC, BCC, and file attachments on both Android and iOS platforms.

### Features
- Send emails using the default email app on Android and iOS
- Support for multiple recipients in To, CC, and BCC fields
- Ability to add file attachments
- Easy integration with existing Flutter projects

### Getting Started
To use this plugin, add the_mailer as a dependency in your pubspec.yaml file:
```dart
dependencies:
 the_mailer: ^0.0.1
 ```

## Usage
Import the package in your Dart code:
```dart 
import 'package:the_mailer/the_mailer.dart';
```

To send an email:
```dart
bool success = await TheMailer.send(
to: ['recipient@example.com'],
cc: ['cc@example.com'],
bcc: ['bcc@example.com'],
subject: 'Test Email',
body: 'This is a test email sent from Flutter.',
attachmentPaths: ['/path/to/attachment.pdf'],
);

if (success) {
print('Email sent successfully');
} else {
print('Failed to send email');
}
```

## Additional Information
### Android Setup
- The plugin uses Intent.ACTION_SEND_MULTIPLE to handle multiple attachments.
- File provider authority is set up automatically.

### iOS Setup
- Uses MFMailComposeViewController to compose emails.
- Attachment MIME types are automatically detected.

## Limitations
This plugin opens the default email app on the device. It does not send emails directly from your app.
Attachment support may vary depending on the email app used on the device.
Contributing
Contributions are welcome! If you find a bug or want a feature, please open an issue.

## License
This project is licensed under the MIT License - see the LICENSE file for details.