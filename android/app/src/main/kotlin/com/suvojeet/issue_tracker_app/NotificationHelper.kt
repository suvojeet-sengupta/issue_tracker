package com.suvojeet.issue_tracker_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

object NotificationHelper {

    private const val CHANNEL_ID = "issue_tracker_channel"
    private const val CHANNEL_NAME = "Issue Tracker Notifications"
    private const val NOTIFICATION_ID = 1
    private const val PREFS_NAME = "notification_prefs"
    private const val HISTORY_KEY = "notification_history"
    const val EXTRA_NOTIFICATION_CLICKED = "notification_clicked"

    fun createNotificationChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Channel for Issue Tracker reminders"
            }
            val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun showNotification(context: Context, title: String, message: String) {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra(EXTRA_NOTIFICATION_CLICKED, true)
        }
        val pendingIntent: PendingIntent = PendingIntent.getActivity(
            context, 0, intent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info) // You might want to use your app's icon here
            .setContentTitle(title)
            .setContentText(message)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)

        with(NotificationManagerCompat.from(context)) {
            notify(NOTIFICATION_ID, builder.build())
        }
    }

    fun saveNotificationToHistory(context: Context, message: String) {
        val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        val history = sharedPreferences.getStringSet(HISTORY_KEY, mutableSetOf())?.toMutableSet() ?: mutableSetOf()

        val timestamp = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(Date())
        val notificationJson = JSONObject().apply {
            put("timestamp", timestamp)
            put("message", message)
            put("isRead", false)
        }
        history.add(notificationJson.toString())

        editor.putStringSet(HISTORY_KEY, history)
        editor.apply()
    }

    fun getUnreadNotificationCount(context: Context): Int {
        val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val history = sharedPreferences.getStringSet(HISTORY_KEY, emptySet()) ?: emptySet()
        var unreadCount = 0
        for (entry in history) {
            try {
                val jsonObject = JSONObject(entry)
                if (!jsonObject.getBoolean("isRead")) {
                    unreadCount++
                }
            } catch (e: Exception) {
                // Handle parsing error, e.g., log it
                e.printStackTrace()
            }
        }
        return unreadCount
    }

    fun markAllNotificationsAsRead(context: Context) {
        val sharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        val history = sharedPreferences.getStringSet(HISTORY_KEY, mutableSetOf())?.toMutableSet() ?: mutableSetOf()

        val updatedHistory = mutableSetOf<String>()
        for (entry in history) {
            try {
                val jsonObject = JSONObject(entry)
                jsonObject.put("isRead", true)
                updatedHistory.add(jsonObject.toString())
            } catch (e: Exception) {
                // Handle parsing error, e.g., log it
                e.printStackTrace()
                updatedHistory.add(entry) // Add original entry if parsing fails
            }
        }

        editor.putStringSet(HISTORY_KEY, updatedHistory)
        editor.apply()
    }
}
