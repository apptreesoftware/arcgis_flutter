package com.apptreesoftware.arcgisflutter

import android.app.AlertDialog
import android.app.Dialog
import android.os.Bundle
import android.support.v4.app.DialogFragment

/**
 * Created by chancesnow on 10/6/17.
 */
class LayersDialogFragment(var layers : List<MapLayer>) : DialogFragment() {
    private var mListener : LayersDialogListener? = null

    interface LayersDialogListener {
        fun onLayersDialogPositiveClick(dialog : LayersDialogFragment)
    }

    constructor() : this(ArrayList())

    var listener : LayersDialogListener? = null
        set(value) { mListener = value }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        val items = layers.map { it.name }.toTypedArray()
        val checkedItems = layers.map { it.visible }.toBooleanArray()
        val builder = AlertDialog.Builder(activity)

        builder.setTitle("Layers")
                .setMultiChoiceItems(
                        items, checkedItems, { _, which, isChecked ->
                    layers[which].visible = isChecked
                }
                )
                .setCancelable(false)
                .setPositiveButton("Ok", { _, _ ->
                    mListener?.onLayersDialogPositiveClick(dialog = this)
                })

        val dialog = builder.create()
        dialog.setCanceledOnTouchOutside(false)
        return dialog
    }
}
