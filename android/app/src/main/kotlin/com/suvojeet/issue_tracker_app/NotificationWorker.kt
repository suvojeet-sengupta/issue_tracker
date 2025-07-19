package com.suvojeet.issue_tracker_app

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters
import android.content.SharedPreferences

class NotificationWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        val prefs: SharedPreferences = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val notificationsEnabled = prefs.getBoolean("flutter.notificationsEnabled", true)

        if (!notificationsEnabled) {
            return Result.success() // Notifications are disabled, so just return success
        }

        val message = inputData.getString("message") ?: return Result.failure()
        NotificationHelper.showNotification(applicationContext, "Issue Tracker Reminder", message)
        NotificationHelper.saveNotificationToHistory(applicationContext, message)

        return Result.success()
    }
}
