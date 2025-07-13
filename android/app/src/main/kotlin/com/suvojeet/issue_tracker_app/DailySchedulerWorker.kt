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

    private val messages = listOf(
        "Login and logout time pe, tagging miss pe, wifi off,system off,system hang, voice issue pe, Tagging missing pe issue tracker real time pe fill hona chahiye.",
        "Team one more important update ek sec bhi agar app ki voice na jaye ya observe ho ki headphone issue or system issue hai real time me issue tracker fill hona chahiye",
        "Kya apko system issue hua hai ?  ya CX voice break please fill issue tracker",
        "Don't be lazy to fill issue tracker it's for our safe side",
        "Kuch bhi issue aa raha hai\nFill issue Tracker on Real time\nCx ki awaj nhi aa rahi hai call par\nFill issue Tracker"
    )

    override fun doWork(): Result {
        scheduleDailyNotifications(applicationContext)
        return Result.success()
    }

    companion object {
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

            for (i in 0 until 15) {
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