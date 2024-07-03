import Flutter
import UIKit
import MessageUI

public class TheMailerPlugin: NSObject, FlutterPlugin, MFMailComposeViewControllerDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "the_mailer", binaryMessenger: registrar.messenger())
        let instance = TheMailerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "sendMail" {
            guard let args = call.arguments as? [String: Any],
                  let to = args["to"] as? [String],
                  let cc = args["cc"] as? [String],
                  let bcc = args["bcc"] as? [String],
                  let subject = args["subject"] as? String,
                  let body = args["body"] as? String,
                  let attachmentPaths = args["attachmentPaths"] as? [String] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                return
            }

            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(to)
                mail.setCcRecipients(cc)
                mail.setBccRecipients(bcc)
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)

                for path in attachmentPaths {
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                        let filename = (path as NSString).lastPathComponent
                        mail.addAttachmentData(data, mimeType: "application/octet-stream", fileName: filename)
                    }
                }

                if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                    rootViewController.present(mail, animated: true, completion: nil)
                    result(true)
                } else {
                    result(FlutterError(code: "NO_ROOT_VIEW_CONTROLLER", message: "Unable to present mail composer", details: nil))
                }
            } else {
                result(FlutterError(code: "MAIL_NOT_AVAILABLE", message: "Mail services are not available", details: nil))
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}