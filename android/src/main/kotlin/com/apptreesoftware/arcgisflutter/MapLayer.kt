package com.apptreesoftware.arcgisflutter

import com.esri.arcgisruntime.data.ServiceFeatureTable
import com.esri.arcgisruntime.layers.FeatureLayer
import org.json.JSONObject

/**
 * Created by chancesnow on 10/5/17.
 */

class MapLayer(json: JSONObject) {
    var name : String? = null
    var url: String? = null
    var visible : Boolean = true
    var featureLayer : FeatureLayer? = null

    init {
        name = json.stringValue("name")
        url = json.stringValue("url")
        visible = json.boolValue("visible_by_default")
        featureLayer = FeatureLayer(ServiceFeatureTable(url))
    }
    companion object {
        fun fromMap(map: Map<String, Any>): MapLayer? {
            return MapLayer(JSONObject(map))
        }
    }

    override fun toString(): String = name ?: ""
}

fun JSONObject.stringValue(key : String) : String {
    if ( this.isNull(key) ) {
        return ""
    }
    return this.optString(key, "")
}

fun JSONObject?.boolValue(key : String) : Boolean {
    return this?.optBoolean(key, false) ?: false
}