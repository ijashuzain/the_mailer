package com.vexellab.the_mailer

import android.content.Intent
import android.content.Context
import android.net.Uri
import androidx.core.content.ContextCompat.startActivity
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

class TheMailerPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "the_mailer")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "sendMail") {
            val to = call.argument<List<String>>("to")
            val cc = call.argument<List<String>>("cc")
            val bcc = call.argument<List<String>>("bcc")
            val subject = call.argument<String>("subject")
            val body = call.argument<String>("body")
            val attachmentPaths = call.argument<List<String>>("attachmentPaths")

            val intent = Intent(Intent.ACTION_SEND_MULTIPLE).apply {
                type = "message/rfc822"
                putExtra(Intent.EXTRA_EMAIL, to?.toTypedArray())
                putExtra(Intent.EXTRA_CC, cc?.toTypedArray())
                putExtra(Intent.EXTRA_BCC, bcc?.toTypedArray())
                putExtra(Intent.EXTRA_SUBJECT, subject)
                putExtra(Intent.EXTRA_TEXT, body)

                if (!attachmentPaths.isNullOrEmpty()) {
                    val uris = attachmentPaths.map { path ->
                        FileProvider.getUriForFile(
                            context,
                            "${context.packageName}.fileprovider",
                            File(path)
                        )
                    }
                    putParcelableArrayListExtra(Intent.EXTRA_STREAM, ArrayList(uris))
                }
            }

            try {
                startActivity(context, Intent.createChooser(intent, "Send mail..."), null)
                result.success(true)
            } catch (e: Exception) {
                result.error("SEND_MAIL_ERROR", "Failed to send email", e.toString())
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}