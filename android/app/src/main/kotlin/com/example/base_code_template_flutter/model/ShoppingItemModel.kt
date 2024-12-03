package com.example.base_code_template_flutter.model

sealed class ShoppingItemModel {

    data class Title(
        var title: String
    ) : ShoppingItemModel()

    data class Item(
        var title: String,
        var name: String,
        var id: Int,
        var cost: Double,
        var isChecked: Boolean,
    ) : ShoppingItemModel()
}

