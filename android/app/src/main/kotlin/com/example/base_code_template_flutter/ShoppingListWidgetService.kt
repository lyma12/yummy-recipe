package com.example.base_code_template_flutter

import android.content.Intent
import android.widget.RemoteViewsService

class ShoppingListWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent?): RemoteViewsService.RemoteViewsFactory {
        return ShoppingListFactory(applicationContext, intent)
    }
}

