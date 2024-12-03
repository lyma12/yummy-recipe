package com.example.base_code_template_flutter.common

import com.example.base_code_template_flutter.model.DataModel.Item
import com.example.base_code_template_flutter.model.ShoppingItemModel
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

fun String.converterShoppingItem(): List<ShoppingItemModel> {
    val gson = Gson()
    if (isBlank()) return emptyList()
    return try {
        val type = object : TypeToken<Map<String, List<Item>>>() {}.type
        val categories: Map<String, List<Item>> = gson.fromJson(this, type)

        val resultList = mutableListOf<ShoppingItemModel>()

        for ((categoryName, items) in categories) {
            resultList.add(ShoppingItemModel.Title(categoryName))
            resultList.addAll(items.map {
                ShoppingItemModel.Item(
                    categoryName,
                    it.name,
                    it.id,
                    it.cost,
                    it.isChecked
                )
            })
        }
        resultList
    } catch (e: Exception) {
        emptyList()
    }
}

fun Int.getUriOnCheckedData(title: String?): String {
    return "$INTENT_CHECK_ITEM?id=$this&type=$title"
}
