package com.suvojeet.issue_tracker_app

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val FILE_CHANNEL = "com.suvojeet.issue_tracker_app/file_opener"
    private val NOTIFICATION_CHANNEL = "com.suvojeet.issue_tracker_app/notifications"
    private val PERMISSION_REQUEST_CODE = 100

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FILE_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openFile") {
                val filePath = call.argument<String>("filePath")
                if (filePath != null) {
                    saveAndOpenFile(filePath, this, result)
                } else {
                    result.error("INVALID_ARGUMENT", "File path cannot be null", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "saveNotificationToHistory" -> {
                    val title = call.argument<String>("title")
                    val body = call.argument<String>("body")
                    val timestamp = call.argument<String>("timestamp")
                    val data = call.argument<String>("data") // JSON string
                    if (title != null && body != null && timestamp != null && data != null) {
                        saveNotificationToHistory(title, body, timestamp, data)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Missing notification data", null)
                    }
                }
                "getUnreadNotificationCount" -> {
                    // This method is no longer directly supported from native side
                    // as notification management is now handled in Flutter.
                    // Return 0 or handle as per new logic.
                    result.success(0)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun saveAndOpenFile(filePath: String, context: Context, result: MethodChannel.Result) {
        val originalFile = File(filePath)
        if (!originalFile.exists()) {
            result.error("FILE_NOT_FOUND", "Original file not found at $filePath", null)
            return
        }

        try {
            // Get the public Documents directory
            val documentsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS)
            if (!documentsDir.exists()) {
                documentsDir.mkdirs()
            }

            // Create a new file in the Documents directory
            val newFile = File(documentsDir, originalFile.name)

            // Copy the file from cache to Documents
            FileInputStream(originalFile).use { input ->
                FileOutputStream(newFile).use { output ->
                    input.copyTo(output)
                }
            }

            // Now open the new file from the Documents directory
            val uri: Uri = FileProvider.getUriForFile(
                context,
                context.applicationContext.packageName + ".provider",
                newFile
            )

            val mime = MimeTypeMap.getSingleton()
            val extension = MimeTypeMap.getFileExtensionFromUrl(uri.toString())
            val type = mime.getMimeTypeFromExtension(extension)

            val intent = Intent(Intent.ACTION_VIEW)
            intent.setDataAndType(uri, type)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            context.startActivity(intent)
            result.success(null)
        } catch (e: Exception) {
            result.error("FILE_SAVE_OR_OPEN_ERROR", "Could not save or open file: ${e.message}", e.toString())
        }
    }

    private fun saveNotificationToHistory(title: String, body: String, timestamp: String, data: String) {
        val sharedPreferences = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val history = sharedPreferences.getStringSet("flutter.notificationHistory", mutableSetOf())?.toMutableSet() ?: mutableSetOf()

        val notificationEntry = "{\"title\": \"$title\", \"body\": \"$body\", \"timestamp\": \"$timestamp\", \"data\": $data}"
        history.add(notificationEntry)

        sharedPreferences.edit().putStringSet("flutter.notificationHistory", history).apply()
    }
}