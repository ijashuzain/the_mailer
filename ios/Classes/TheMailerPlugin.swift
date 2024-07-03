import Flutter
import UIKit
import MessageUI

public class TheMailerPlugin: NSObject, FlutterPlugin, MFMailComposeViewControllerDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "mail_sender", binaryMessenger: registrar.messenger())
        let instance = MailSenderPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "sendMail":

            guard let arguments = call.arguments as? [String: Any],
                  let emailAddress = arguments["emailAddress"] as? [String] ,
                  let subject = arguments["subject"] as? String,
                  let cc = arguments["cc"] as? [String],
                  let bcc = arguments["bcc"] as? [String],
                  let body = arguments["body"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                return
            }
            var attachmentPath: String? = nil
            if let possibleAttachmentPath = arguments["attachment"] as? String {
                attachmentPath = possibleAttachmentPath
            }


            sendMail(emailAddress: emailAddress, subject: subject,body: body, attachmentPath: attachmentPath, cc:cc, bcc:bcc, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func sendMail(
        emailAddress: [String],
        subject: String,
        body: String,
        attachmentPath: String?,
        cc: [String]?,
        bcc: [String]?,
        result: @escaping FlutterResult
    ) {
        guard MFMailComposeViewController.canSendMail() else {
            result(FlutterError(code: "CANNOT_SEND_MAIL",
                                message: "Mail is not configured on this device",
                                details: nil))
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.setToRecipients(emailAddress)
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)

        if let cc = cc, !cc.isEmpty{
            mailComposer.setCcRecipients(cc)
        }

        if let bcc = bcc, !bcc.isEmpty{
            mailComposer.setBccRecipients(bcc)
        }

        if let filePath = attachmentPath {
            let attachmentURL = URL(fileURLWithPath: filePath)
            if let data = NSData(contentsOfFile: filePath) {
                mailComposer.addAttachmentData(
                    data as Data,
                    mimeType: "application/pdf",
                    fileName: attachmentURL.lastPathComponent
                )
            }
        }

        mailComposer.mailComposeDelegate = self
        UIApplication.shared.keyWindow?.rootViewController?.present(
            mailComposer,
            animated: true,
            completion: nil
        )
    }

    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?) {
            controller.dismiss(animated: true, completion: nil)
    }
}
