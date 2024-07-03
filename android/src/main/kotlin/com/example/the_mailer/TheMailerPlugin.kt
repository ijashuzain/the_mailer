package com.vexellab.the_mailer

import android.content.Context
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File


/** MailSenderPlugin */
class TheMailerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mail_sender")
        channel.setMethodCallHandler(this)
        this.flutterPluginBinding = flutterPluginBinding

    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "sendMail") {
            val subject = call.argument<String>("subject")
            val body = call.argument<String>("body")
            val emailAddress = call.argument<List<String>>("emailAddress")
            val attachment = call.argument<String>("attachment")
            val cc = call.argument<List<String>>("cc")
            val bcc = call.argument<List<String>>("bcc")

            println("subject: $subject, body: $body, emailAddress: $emailAddress")
            println(call.arguments)

            composeEmail(
                emailAddress, subject, body, attachment, cc, bcc
            )
            result.success(true)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getHostAppId(context: Context): String {
        try {
            val appId = context.packageManager.getPackageInfo(context.packageName, 0).packageName
            return "$appId.fileprovider"
        } catch (e: Exception) {
            throw Exception("Host App : App id not found")
        }
    }


    private fun composeEmail(
        addresses: List<String>?,
        subject: String?,
        body: String?,
        attachment: String?,
        cc: List<String>?,
        bcc: List<String>?
    ) {
        val appIdOfHost = getHostAppId(flutterPluginBinding.applicationContext)

        val intent = Intent(Intent.ACTION_SEND)
        intent.type = "message/rfc822"
        addresses?.let { addresses ->
            intent.putExtra(Intent.EXTRA_EMAIL, addresses.toTypedArray())
        }
        subject?.let { subject ->
            intent.putExtra(Intent.EXTRA_SUBJECT, subject)
        }
        body?.let { body ->
            intent.putExtra(Intent.EXTRA_TEXT, body)
        }
        cc?.let { cc -> intent.putExtra(Intent.EXTRA_CC, cc.toTypedArray()) }
        bcc?.let { bcc -> intent.putExtra(Intent.EXTRA_BCC, bcc.toTypedArray()) }
        if (attachment != null) {
            val file = File(attachment)
            println("File exists: ${file.exists()}")
            val contentUri = FileProvider.getUriForFile(
                flutterPluginBinding.applicationContext, appIdOfHost, file
            )
            intent.putExtra(Intent.EXTRA_STREAM, contentUri)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        flutterPluginBinding.applicationContext.startActivity(Intent.createChooser(
            intent,
            "Choose an email client",
        ).apply { addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) })
    }


}


