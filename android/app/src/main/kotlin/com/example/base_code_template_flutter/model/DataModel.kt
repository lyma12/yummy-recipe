package com.example.base_code_template_flutter.model

class DataModel {
    data class Item(
        val name: String,
        val id: Int,
        val measures: Measures,
        val pantryItem: Boolean,
        val aisle: String,
        val cost: Double,
        val ingredientId: Int,
        val isChecked: Boolean
    )

    data class Measures(
        val original: Measurement,
        val metric: Measurement,
        val us: Measurement
    )

    data class Measurement(
        val amount: Double,
        val unitLong: String?,
        val unitShort: String?,
        val unit: String
    )
}