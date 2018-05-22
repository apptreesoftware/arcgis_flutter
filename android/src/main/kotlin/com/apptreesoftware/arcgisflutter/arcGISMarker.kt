package com.apptreesoftware.arcgisflutter

import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import com.esri.arcgisruntime.mapping.view.Graphic
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay
import com.esri.arcgisruntime.symbology.MarkerSymbol
import com.esri.arcgisruntime.symbology.PictureMarkerSymbol

class ArcGISMarker(location: LatLng, val recordID: String, val context: Context,
                   val overlay: GraphicsOverlay) {

    val graphic: Graphic = Graphic(location.latitude, location.longitude)

    companion object {
        val circleSize = 24.0.toFloat()
    }

    fun updateMarker() {
        val marker: MarkerSymbol
        marker = PictureMarkerSymbol(BitmapDrawable(context.resources,
                BitmapFactory.decodeResource(
                        context.resources,
                        R.drawable.icon_map_default_red22x36)))
        graphic.symbol = marker
    }

     var isVisible: Boolean
        get() = overlay.graphics.contains(graphic)
        set(value) {
            overlay.graphics.add(graphic)
        }
}
