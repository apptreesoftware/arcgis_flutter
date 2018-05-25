package com.apptreesoftware.arcgisflutter

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.widget.Button
import com.esri.arcgisruntime.geometry.GeometryEngine
import com.esri.arcgisruntime.geometry.Point
import com.esri.arcgisruntime.geometry.SpatialReferences
import com.esri.arcgisruntime.mapping.ArcGISMap
import com.esri.arcgisruntime.mapping.Basemap
    import com.esri.arcgisruntime.mapping.Viewpoint
import com.esri.arcgisruntime.mapping.view.GraphicsOverlay
import com.esri.arcgisruntime.mapping.view.MapView


class MapActivity : AppCompatActivity(), LayersDialogFragment.LayersDialogListener {

    var markerIdLookup = HashMap<String, ArcGISMarker>()
    lateinit var mapView: MapView
    var arcGISMap: ArcGISMap? = null
    private val overlay = GraphicsOverlay()
    var markers = ArrayList<ArcGISMarker>()
    var layers = ArrayList<MapLayer>()


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        mapView = findViewById(R.id.mapView)
        mapView.graphicsOverlays.add(overlay)
        arcGISMap = ArcGISMap(Basemap.Type.TOPOGRAPHIC, 34.045, -117.0, 16)
        ArcgisFlutterPlugin.mapActivity = this
        mapView.map = arcGISMap

        ArcgisFlutterPlugin.onMapReady()

        var layerButton = findViewById<Button>(R.id.mapLayers)
        layerButton.setOnClickListener { showLayersDialog() }
    }

    override fun onResume() {
        super.onResume()
        mapView.resume()
    }


    override fun onPause() {
        super.onPause()
        mapView.pause()
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        ArcgisFlutterPlugin.toolbarActions.forEach {
            val item = menu.add(0, it.identifier, 0, it.title)
            item.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM)
        }
        return super.onCreateOptionsMenu(menu)
    }


    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        ArcgisFlutterPlugin.handleToolbarAction(item.itemId)
        return true
    }

    override fun onDestroy() {
        super.onDestroy()
        mapView.dispose()
        ArcgisFlutterPlugin.mapActivity = null
    }

    val target: Point
        get() {
            val viewPoint = mapView.getCurrentViewpoint(Viewpoint.Type.CENTER_AND_SCALE)
            val center = viewPoint.targetGeometry.extent.center
            return GeometryEngine.project(center, SpatialReferences.getWgs84()) as Point
        }
    val zoom: Float
        get() {
            val viewpoint = mapView.mapScale;
            return viewpoint.toFloat()
        }


    fun setCamera(target: LatLng, zoom: Float) {
        mapView.setViewpoint(Viewpoint(target.latitude, target.longitude, zoom.toDouble()))
    }


    fun setAnnotations(annotations: List<MapAnnotation>) {
        markers.clear()
        for (annotation in annotations) {
            addMarker(annotation)
        }
    }

    fun addMarker(annotation: MapAnnotation) {
        val marker = ArcGISMarker(annotation.coordinate, annotation.identifier, this, overlay)
        markerIdLookup[annotation.identifier] = marker
        markers.add(marker)
        marker.isVisible = true
        marker.updateMarker()
    }

    fun setLayers(layers: List<MapLayer>) {
        this.layers = ArrayList(layers)
    }

    fun showLayersDialog() {
        val layersDialog = LayersDialogFragment(layers)
        layersDialog.listener = this
        layersDialog.show(supportFragmentManager, "LayersDialogFragment")
    }


    override fun onLayersDialogPositiveClick(dialog: LayersDialogFragment) {
        mapView.map.operationalLayers.clear()
        layers.filter { it.visible }
                .map { it.featureLayer }
                .forEach {
                    mapView.map.operationalLayers.add(it)
                }
    }
}