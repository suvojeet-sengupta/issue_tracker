package com.suvojeet.issue_tracker_app

import android.content.Context
import androidx.work.Worker
import androidx.work.WorkerParameters
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import androidx.work.Data
import java.util.Calendar
import java.util.concurrent.TimeUnit
import kotlin.random.Random

class DailySchedulerWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        Companion.scheduleDailyNotifications(applicationContext)
        return Result.success()
    }

    companion object {
        private val messages = listOf(
            "Customer ki awaaz clear nahi thi? Please fill the Issue Tracker.",
            "Agar 1 sec bhi voice break ya mute hua ho, real-time pe log karein.",
            "Mic ya headphone properly work nahi kar raha? Tracker update zaruri hai.",
            "Call par CX ki voice drop hui? Please report in the tracker.",
            "Voice transmission issue detect hua – kindly log now.",
            "System hang, lag ya auto restart ho gaya? Real-time pe fill karein.",
            "Slow performance observe kiya? Tracker mein mention karein.",
            "System error face hua during call? Please update the tracker.",
            "System crash ya freeze hua? Don’t forget to log it.",
            "Login/logout issue report karna mandatory hai.",
            "Wi-Fi disconnect ya internet slow hua? Real-time update karein.",
            "CX ki voice cut ho rahi thi due to network? Tracker mein mention karein.",
            "Call disconnect network issue ke wajah se? Log it properly.",
            "Internet down tha? Please fill the Issue Tracker now.",
            "Network fluctuations observed? Real-time reporting required.",
            "Koi bhi technical ya voice issue ho – Issue Tracker pe turant likhna hai.",
            "Don’t delay – tracker is for your protection during audits.",
            "Real-time reporting helps maintain process quality.",
            "Please don’t ignore even minor issues – log them now.",
            "Issue Tracker is your responsibility – keep it updated at all times.",
            "System ya voice ka koi bhi glitch ho – real-time pe report karein."
        )

        fun scheduleDailyNotifications(context: Context) {
            val workManager = WorkManager.getInstance(context)
            // Cancel any previously scheduled daily notifications to avoid duplicates
            workManager.cancelUniqueWork("DailyNotificationScheduler")

            val scheduledTimes = mutableListOf<Long>() // Store scheduled times in milliseconds

            val calendar = Calendar.getInstance()
            calendar.timeInMillis = System.currentTimeMillis()

            // Set start time to 6 AM today
            calendar.set(Calendar.HOUR_OF_DAY, 6)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)
            calendar.set(Calendar.MILLISECOND, 0)

            val startTimeMillis = calendar.timeInMillis

            // Set end time to 1 AM next day
            calendar.add(Calendar.DAY_OF_YEAR, 1)
            calendar.set(Calendar.HOUR_OF_DAY, 1)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)
            calendar.set(Calendar.MILLISECOND, 0)

            val endTimeMillis = calendar.timeInMillis

            val minGapMillis = 30 * 60 * 1000L // 30 minutes in milliseconds

            for (i in 0 until messages.size) {
                var randomTime: Long
                var isValidTime: Boolean
                do {
                    // Generate a random time within the 6 AM to 1 AM window
                    randomTime = Random.nextLong(startTimeMillis, endTimeMillis)

                    isValidTime = true
                    for (existingTime in scheduledTimes) {
                        if (Math.abs(randomTime - existingTime) < minGapMillis) {
                            isValidTime = false
                            break
                        }
                    }
                } while (!isValidTime)

                scheduledTimes.add(randomTime)
            }

            scheduledTimes.sort() // Sort the times to ensure chronological order

            for ((index, scheduledTime) in scheduledTimes.withIndex()) {
                val message = messages[Random.nextInt(messages.size)]
                val delay = scheduledTime - System.currentTimeMillis()

                if (delay > 0) {
                    val notificationWorkRequest = OneTimeWorkRequest.Builder(NotificationWorker::class.java)
                        .setInitialDelay(delay, TimeUnit.MILLISECONDS)
                        .setInputData(Data.Builder().putString("message", message).build())
                        .build()
                    workManager.enqueue(notificationWorkRequest)
                }
            }
        }
    }
}