package com.suvojeet.issue_tracker_app

import android.Manifest
import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.webkit.MimeTypeMap
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    private val FILE_CHANNEL = "com.suvojeet.issue_tracker_app/file_opener"
    private val NOTIFICATION_CHANNEL = "com.suvojeet.issue_tracker_app/notifications"
    private val UPDATE_CHANNEL = "com.suvojeet.issue_tracker_app/update"
    private val PERMISSION_REQUEST_CODE = 100

    private var downloadId: Long = -1
    private lateinit var downloadManager: DownloadManager

    private val onDownloadComplete = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1)
            if (DownloadManager.ACTION_DOWNLOAD_COMPLETE == intent.action && downloadId == id) {
                val query = DownloadManager.Query()
                query.setFilterById(id)
                val cursor: Cursor = downloadManager.query(query)
                if (cursor.moveToFirst()) {
                    val columnIndex = cursor.getColumnIndex(DownloadManager.COLUMN_STATUS)
                    if (DownloadManager.STATUS_SUCCESSFUL == cursor.getInt(columnIndex)) {
                        val uriString = cursor.getString(cursor.getColumnIndex(DownloadManager.COLUMN_LOCAL_URI))
                        val downloadedFileUri = Uri.parse(uriString)
                        installApk(context, downloadedFileUri)
                    } else {
                        // Handle download failure
                        println("Download failed")
                    }
                }
                cursor.close()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestNotificationPermission()
        intent?.let { handleIntent(it) }

        downloadManager = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
        registerReceiver(onDownloadComplete, IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE), Context.RECEIVER_NOT_EXPORTED)
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(onDownloadComplete)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        if (intent.getBooleanExtra(NotificationHelper.EXTRA_NOTIFICATION_CLICKED, false)) {
            navigateToHistory()
        }
    }

    private fun navigateToHistory() {
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL).invokeMethod("navigateToHistory", null)
    }

    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    this,
                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                    PERMISSION_REQUEST_CODE
                )
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted
            } else {
                // Permission denied, you might want to show a dialog or close the app
                // For now, we'll just finish the activity to make it mandatory
                finish()
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize notification channel
        NotificationHelper.createNotificationChannel(this)

        // Schedule the daily notification scheduler
        val dailySchedulerWorkRequest = OneTimeWorkRequest.Builder(DailySchedulerWorker::class.java)
            .setInitialDelay(1, TimeUnit.MINUTES) // Schedule to run shortly after app launch
            .build()
        WorkManager.getInstance(this).enqueueUniqueWork(
            "DailyNotificationScheduler",
            ExistingWorkPolicy.REPLACE,
            dailySchedulerWorkRequest
        )

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
                "getNotificationHistory" -> {
                    val sharedPreferences = applicationContext.getSharedPreferences("notification_prefs", Context.MODE_PRIVATE)
                    val history = sharedPreferences.getStringSet("notification_history", emptySet())?.toList() ?: emptyList()
                    result.success(history)
                }
                "getUnreadNotificationCount" -> {
                    result.success(NotificationHelper.getUnreadNotificationCount(applicationContext))
                }
                "markAllNotificationsAsRead" -> {
                    NotificationHelper.markAllNotificationsAsRead(applicationContext)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, UPDATE_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "downloadAndInstallApk") {
                val url = call.argument<String>("url")
                if (url != null) {
                    downloadApk(url)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "Download URL cannot be null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun downloadApk(url: String) {
        val request = DownloadManager.Request(Uri.parse(url))
            .setTitle("App Update")
            .setDescription("Downloading new version of the app")
            .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, "issue_tracker_app.apk")

        downloadId = downloadManager.enqueue(request)
    }

    private fun installApk(context: Context, apkUri: Uri) {
        val intent = Intent(Intent.ACTION_VIEW)
        intent.setDataAndType(apkUri, "application/vnd.android.package-archive")
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val contentUri = FileProvider.getUriForFile(
                context,
                context.applicationContext.packageName + ".provider",
                File(apkUri.path!!)
            )
            intent.setDataAndType(contentUri, "application/vnd.android.package-archive")
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        context.startActivity(intent)
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
}