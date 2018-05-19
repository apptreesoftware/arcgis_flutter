package com.apptreesoftware.arcgisflutter

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.support.v7.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import com.esri.arcgisruntime.mapping.ArcGISMap
import com.esri.arcgisruntime.mapping.Basemap
import com.esri.arcgisruntime.mapping.view.MapView
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Marker
import com.google.android.gms.maps.model.MarkerOptions

class MapActivity : AppCompatActivity() {
    var markerIdLookup = HashMap<String, Marker>()
    val PermissionRequest = 1
    lateinit var mapView: MapView
    var arcGISMap: ArcGISMap? = null

    //  override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
//    val view = inflater.inflate(R.layout.fragment_page_map, container, false)!!
//    mapContainer = view.find(R.id.map_container)
//    return super.onCreateView(name, context, attrs)
//  }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        title = ArcgisFlutterPlugin.mapTitle
        mapView = findViewById(R.id.mapView)
        arcGISMap = ArcGISMap(Basemap.Type.TOPOGRAPHIC, 34.045, -117.0, 16)
        ArcgisFlutterPlugin.mapActivity = this
        mapView.map = arcGISMap
    }

    override fun onResume() {
        super.onResume()
        mapView.resume()
    }


    override fun onPause() {
        super.onPause()
        mapView.pause()
    }


    @SuppressLint("MissingPermission")
    fun onMapReady(map: ArcGISMap) {
        arcGISMap = map

        if (ArcgisFlutterPlugin.showUserLocation) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
                    != PackageManager.PERMISSION_GRANTED) {
                val array = arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION)
                ActivityCompat.requestPermissions(this, array, PermissionRequest)
            } else {
//        map.isMyLocationEnabled = true
//        map.uiSettings.isMyLocationButtonEnabled = false
//        map.uiSettings.isIndoorLevelPickerEnabled = true
            }
        }

//    map.setOnMapClickListener { latLng ->
//        ArcgisFlutterPlugin.mapTapped(latLng)
//    }
//    map.setOnMarkerClickListener { marker ->
//      ArcgisFlutterPlugin.annotationTapped(marker.tag as String)
//      false
//    }
//    map.setOnCameraMoveListener {
//      val pos = map.cameraPosition
//      ArcgisFlutterPlugin.cameraPositionChanged(pos)
//    }
//    map.setOnMyLocationChangeListener {
//      val loc = map.myLocation ?: return@setOnMyLocationChangeListener
//      ArcgisFlutterPlugin.locationDidUpdate(loc)
//    }
//    map.setOnInfoWindowClickListener{ marker ->
//        ArcgisFlutterPlugin.infoWindowTapped(marker.tag as String)
//    }
//    map.moveCamera(CameraUpdateFactory.newCameraPosition(
//        ArcgisFlutterPlugin.initialCameraPosition))
//      ArcgisFlutterPlugin.onMapReady()
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

    val zoomLevel: Float
        get() {
//    return googleMap?.cameraPosition?.zoom ?: 0.0.toFloat()
//      return arcGISMap?.
            return 0.0f
        }

//  val target : LatLng
//      get() = arcGISMap?.cameraPosition?.target ?: LatLng(0.0, 0.0)

    fun setCamera(target: LatLng, zoom: Float) {
//    googleMap?.animateCamera(
//        CameraUpdateFactory.newLatLngZoom(target, zoom))
    }

    fun setAnnotations(annotations: List<MapAnnotation>) {
//    val map = this.googleMap ?: return
//    map.clear()
//    markerIdLookup.clear()
//    for (annotation in annotations) {
//      val marker = createMarkerForAnnotation(annotation, map)
//      markerIdLookup[annotation.identifier] = marker
//    }
    }

    fun addMarker(annotation: MapAnnotation) {
//    val map = this.googleMap ?: return
//    val existingMarker = markerIdLookup[annotation.identifier]
//    if (existingMarker != null) return
//    val marker = createMarkerForAnnotation(annotation, map)
//    markerIdLookup.put(annotation.identifier, marker)
    }

    fun removeMarker(annotation: MapAnnotation) {
//    this.googleMap ?: return
//    val existingMarker = markerIdLookup[annotation.identifier] ?: return
//    markerIdLookup.remove(annotation.identifier)
//    existingMarker.remove()
    }

    val visibleMarkers: List<String>
        get() {
//    val map = this.googleMap ?: return  emptyList()
//    val region = map.projection.visibleRegion
//    val visibleIds = ArrayList<String>()
//    for (marker in markerIdLookup.values) {
//      if (region.latLngBounds.contains(marker.position)) {
//        visibleIds.add(marker.tag as String)
//      }
//    }
//    return visibleIds
            return ArrayList<String>()
        }

    fun zoomToAnnotations(padding: Int) {
//    val map = this.googleMap ?: return
//    val bounds = LatLngBounds.Builder()
//    var count = 0
//    for (marker in markerIdLookup.values) {
//      bounds.include(marker.position)
//      count++
//    }
//
//    if(map.isMyLocationEnabled && map.myLocation != null) {
//      if (count == 0) {
//        map.animateCamera(CameraUpdateFactory.newLatLngZoom(
//            LatLng(map.myLocation.latitude,
//                                                     map.myLocation.longitude), 12.toFloat()))
//        return
//      }
//      bounds.include(LatLng(map.myLocation.latitude,
//                            map.myLocation.longitude))
//    }
//    try {
//      map.animateCamera(
//          CameraUpdateFactory.newLatLngBounds(bounds.build(), padding))
//    } catch (e : Exception) {}
    }

    fun zoomTo(annoationIds: List<String>, padding: Float) {
//    val map = this.googleMap ?: return
//    if (annoationIds.size == 1) {
//      val marker = markerIdLookup[annoationIds.first()] ?: return
//      map.animateCamera(
//          CameraUpdateFactory.newLatLngZoom(marker.position,
//                                            18.toFloat()))
//      return
//    }
//    val bounds = LatLngBounds.Builder()
//    for (id in annoationIds) {
//      val marker = markerIdLookup[id] ?: continue
//      bounds.include(marker.position)
//    }
//    try {
//      map.animateCamera(
//          CameraUpdateFactory.newLatLngBounds(bounds.build(),
//                                              padding.toInt()))
//    } catch (e : Exception) {}
    }

    fun createMarkerForAnnotation(annotation: MapAnnotation, map: GoogleMap): Marker {
        val marker: Marker
        if (annotation is ClusterAnnotation) {
            marker = map
                    .addMarker(MarkerOptions()
                            .position(annotation.coordinate)
                            .title(annotation.title)
                            .icon(
                                    BitmapDescriptorFactory.defaultMarker(
                                            annotation.colorHue)))
            marker.tag = annotation.identifier
        } else {
            marker = map
                    .addMarker(MarkerOptions()
                            .position(annotation.coordinate)
                            .title(annotation.title)
                            .icon(
                                    BitmapDescriptorFactory.defaultMarker(
                                            annotation.colorHue)))
            marker.tag = annotation.identifier
        }
        return marker
    }

    @SuppressLint("MissingPermission")
    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<out String>,
                                            grantResults: IntArray) {
        when (requestCode) {
            PermissionRequest -> {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//          this.googleMap?.isMyLocationEnabled = true
//          this.googleMap?.uiSettings?.isMyLocationButtonEnabled = true
                }
            }
            else -> super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }
}