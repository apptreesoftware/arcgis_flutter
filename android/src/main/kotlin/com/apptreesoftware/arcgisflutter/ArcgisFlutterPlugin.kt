package com.apptreesoftware.arcgisflutter

import android.app.Activity
import android.content.Intent
import com.esri.arcgisruntime.ArcGISRuntimeEnvironment
import com.esri.arcgisruntime.geometry.Point
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class ArcgisFlutterPlugin(val activity: Activity) : MethodCallHandler {
  companion object {
    lateinit var channel: MethodChannel
    var toolbarActions: List<ToolbarAction> = emptyList()
    var showUserLocation: Boolean = false
    var mapActivity: MapActivity? = null

    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      channel = MethodChannel(registrar.messenger(), "com.apptreesoftware.arcgis_flutter_plugin")
      val plugin = ArcgisFlutterPlugin(activity = registrar.activity())
      channel.setMethodCallHandler(plugin)
    }

    fun handleToolbarAction(id: Int) {
      channel.invokeMethod("onToolbarAction", id)
    }

    fun onMapReady() {
      channel.invokeMethod("onMapReady", null)
    }

    fun getToolbarActions(actionsList: List<Map<String, Any>>?): List<ToolbarAction> {
      if (actionsList == null) return emptyList()
      val actions = ArrayList<ToolbarAction>()
      actionsList.mapTo(actions) { ToolbarAction(it) }
      return actions
    }
  }


  override fun onMethodCall(call: MethodCall, result: Result): Unit {
    when {
      call.method == "setApiKey" -> {
        val licenseStr = call.arguments as String
        if (licenseStr.isEmpty()) {
          result.success(true)
        }
        ArcGISRuntimeEnvironment.setLicense(licenseStr)
        result.success(true)
      }
      call.method == "show" -> {
        val mapOptions = call.argument<Map<String, Any>>("mapOptions")
        toolbarActions = getToolbarActions(call.argument<List<Map<String, Any>>>("actions"))
        showUserLocation = mapOptions["showUserLocation"] as Boolean

        val intent = Intent(activity, MapActivity::class.java)
        activity.startActivity(intent)
        result.success(true)
        return
      }
      call.method == "dismiss" -> {
        mapActivity?.finish()
        result.success(true)
        return
      }
      call.method == "setLayers" -> {
        setLayers(call.arguments as Map<String, Any>)
        result.success(true)
      }
      call.method == "getZoomLevel" -> {
        val zoom = mapActivity?.zoom ?: 0.0.toFloat()
        result.success(zoom)
      }
      call.method == "getCenter" -> {
        val center = mapActivity?.target ?: Point(0.0, 0.0)
        result.success(mapOf("latitude" to center.y,
                "longitude" to center.x))
      }
      call.method == "setCamera" -> {
        handleSetCamera(call.arguments as Map<String, Any>)
        result.success(true)
      }

      call.method == "setAnnotations" -> {
        handleSetAnnotations(call.arguments as List<Map<String, Any>>)
        result.success(true)
      }
      call.method == "addAnnotation" -> {
        handleAddAnnotation(call.arguments as Map<String, Any>)
      }
      else -> result.notImplemented()
    }
  }

  fun handleSetCamera(map: Map<String, Any>) {
    val lat = map["latitude"] as Double
    val lng = map["longitude"] as Double
    val zoom = map["zoom"] as Double
    mapActivity?.setCamera(LatLng(lat, lng), zoom.toFloat())
  }
  fun setLayers(map: Map<String, Any>) {
    var layers = map["mapLayers"] as List<Map<String, Any>>
    var typedLayers = layers.map { MapLayer.fromMap(it) }
    typedLayers = typedLayers.filterNotNull()
    mapActivity?.setLayers(typedLayers)
  }

  fun handleSetAnnotations(annotations: List<Map<String, Any>>) {
    val mapAnnoations = ArrayList<MapAnnotation>()
    for (a in annotations) {
      val mapAnnotation = MapAnnotation.fromMap(a)
      if (mapAnnotation != null) {
        mapAnnoations.add(mapAnnotation)
      }
    }
    mapActivity?.setAnnotations(mapAnnoations)
  }

  fun handleAddAnnotation(map: Map<String, Any>) {
    MapAnnotation.fromMap(map)?.let {
      mapActivity?.addMarker(it)
    }
  }

}