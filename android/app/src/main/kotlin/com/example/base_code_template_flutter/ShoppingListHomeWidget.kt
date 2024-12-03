package com.example.base_code_template_flutter

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import com.example.base_code_template_flutter.common.INTENT_ADD_ITEM
import com.example.base_code_template_flutter.common.INTENT_REFRESH_LIST_ITEM
import com.example.base_code_template_flutter.common.KEY_ID
import com.example.base_code_template_flutter.common.KEY_TITLE
import com.example.base_code_template_flutter.common.KEY_TYPE
import com.example.base_code_template_flutter.common.NO_TITTLE
import com.example.base_code_template_flutter.common.getUriOnCheckedData
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetBackgroundService
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import io.flutter.FlutterInjector

class ShoppingListHomeWidget : HomeWidgetProvider() {
    companion object {
        internal const val ACTION_CLICK_CHECKBOX_ITEM = "ACTION_CLICK_CHECKBOX_ITEM"
        internal const val ACTION_BACKGROUND = "es.antonborri.home_widget.action.BACKGROUND"

        private fun getLaunchAppIntent(context: Context, uri: String): PendingIntent {
            return HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                Uri.parse(uri)
            )
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.shopping_list_home_widget).apply {
                val title = widgetData.getString(KEY_TITLE, null)
                setTextViewText(R.id.t_title, title ?: NO_TITTLE)
                val adapter = Intent(context, ShoppingListWidgetService::class.java).apply {
                    data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                }
                val incrementIntent = getLaunchAppIntent(context, "/")
                val intent = Intent(context, ShoppingListHomeWidget::class.java).apply {
                    action = ACTION_CLICK_CHECKBOX_ITEM
                }
                val pendingIntentTemplate = PendingIntent.getBroadcast(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_MUTABLE
                )
                setPendingIntentTemplate(R.id.lv_shopping_list, pendingIntentTemplate)
                setOnClickPendingIntent(R.id.btn_add, getIntentAddItem(context))
                setOnClickPendingIntent(R.id.t_title, incrementIntent)
                setOnClickPendingIntent(R.id.btn_refresh, getIntentRefreshData(context))
                setRemoteAdapter(R.id.lv_shopping_list, adapter)
            }
            val widgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(
                    context,
                    ShoppingListHomeWidget::class.java
                )
            )
            appWidgetManager.notifyAppWidgetViewDataChanged(widgetIds, R.id.lv_shopping_list)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent?) {
        super.onReceive(context, intent)
        val action = intent?.action
        if (action == ACTION_CLICK_CHECKBOX_ITEM) {
            val idItem = intent.getIntExtra(KEY_ID, 0)
            val typeItem = intent.getStringExtra(KEY_TYPE)
            upDateData(context, idItem, typeItem)
            return
        }
    }

    private fun upDateData(context: Context, id: Int, title: String?) {
        val flutterLoader = FlutterInjector.instance().flutterLoader()
        flutterLoader.startInitialization(context)
        flutterLoader.ensureInitializationComplete(context, null)
        val intent = Intent().apply {
            data = Uri.parse(id.getUriOnCheckedData(title))
            action = ACTION_BACKGROUND
        }
        HomeWidgetBackgroundService.enqueueWork(context, intent)
    }

    private fun getIntentRefreshData(context: Context): PendingIntent {
        return HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse(INTENT_REFRESH_LIST_ITEM))
    }

    private fun getIntentAddItem(context: Context): PendingIntent {
        return getLaunchAppIntent(context, INTENT_ADD_ITEM)
    }
}
