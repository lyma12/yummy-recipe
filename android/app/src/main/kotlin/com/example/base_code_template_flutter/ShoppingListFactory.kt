package com.example.base_code_template_flutter

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import com.example.base_code_template_flutter.common.KEY_LIST_TITLE
import com.example.base_code_template_flutter.common.converterShoppingItem
import com.example.base_code_template_flutter.model.ShoppingItemModel
import es.antonborri.home_widget.HomeWidgetPlugin

class ShoppingListFactory(private val context: Context, private val intent: Intent?) :
    RemoteViewsService.RemoteViewsFactory {

    private val listDataTodo: MutableList<ShoppingItemModel> = mutableListOf()

    override fun onCreate() {
        val widgetData = HomeWidgetPlugin.getData(context)
        val listItem = widgetData.getString(KEY_LIST_TITLE, null)
        listDataTodo.clear()
        listDataTodo.addAll(listItem?.converterShoppingItem() ?: emptyList())
    }

    override fun onDataSetChanged() {
        val widgetData = HomeWidgetPlugin.getData(context)
        val listItem = widgetData.getString(KEY_LIST_TITLE, null)
        listDataTodo.clear()
        listDataTodo.addAll(listItem?.converterShoppingItem() ?: emptyList())
    }

    override fun onDestroy() {
        listDataTodo.clear()
    }

    override fun getCount(): Int = listDataTodo.size
    override fun getViewAt(position: Int): RemoteViews {
        val item = listDataTodo[position]
        val remoteViews = when (item) {
            is ShoppingItemModel.Title -> getTitleViewAt(item)
            is ShoppingItemModel.Item -> getItemShoppingViewAt(item)
        }
        initItemDataListener(remoteViews, item)
        return remoteViews
    }

    private fun initItemDataListener(remoteViews: RemoteViews, item: ShoppingItemModel) {
        if (item is ShoppingItemModel.Item
        ) {
            remoteViews.setOnClickFillInIntent(
                R.id.tvTitleTodo,
                getIntentOnClickItemShopping(item.id, item.title)
            )
            remoteViews.setOnClickFillInIntent(
                R.id.imgCheckTodo,
                getIntentOnClickItemShopping(item.id, item.title)
            )
        }

    }

    private fun getTitleViewAt(item: ShoppingItemModel.Title): RemoteViews {
        val remoteViews = RemoteViews(context.packageName, R.layout.title_shopping_item).apply {
            setTextViewText(R.id.t_title_shopping_item, item.title)
        }
        return remoteViews
    }

    private fun getItemShoppingViewAt(item: ShoppingItemModel.Item): RemoteViews {
        val remoteViews = RemoteViews(context.packageName, R.layout.shopping_item).apply {
            val titleItem = "${item.name} (cost ${item.cost})"
            setTextViewText(R.id.tvTitleTodo, titleItem)
            if (item.isChecked) {
                setImageViewResource(R.id.imgCheckTodo, R.drawable.ic_checkbox_checked)
            } else {
                setImageViewResource(R.id.imgCheckTodo, R.drawable.ic_checkbox)
            }
        }
        return remoteViews
    }

    private fun getIntentOnClickItemShopping(item: Int, title: String): Intent {
        val itemIntent = Intent().apply {
            putExtra("item_id", item)
            putExtra("item_type", title)
            data = Uri.parse("item_id")
            data = Uri.parse("item_type")
        }
        return itemIntent
    }

    override fun getLoadingView(): RemoteViews {
        return RemoteViews(context.packageName, R.layout.title_shopping_item)
    }

    override fun getViewTypeCount(): Int = 2

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true
}

