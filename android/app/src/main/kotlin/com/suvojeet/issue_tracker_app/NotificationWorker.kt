package com.suvojeet.issue_tracker_app

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters

class NotificationWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        val message = inputData.getString("message") ?: return Result.failure()
        NotificationHelper.showNotification(applicationContext, "Issue Tracker Reminder", message)
        NotificationHelper.saveNotificationToHistory(applicationContext, message)

        return Result.success()
    }
}
