package com.example.pokedex

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), SensorEventListener {
    private val COMPASS_CHANNEL = "com.pokedex.compass"
    private val IMAGE_CHANNEL = "com.pokedex.image"

    private lateinit var sensorManager: SensorManager
    private var accelerometer: Sensor? = null
    private var magnetometer: Sensor? = null

    private var lastAccelerometer = FloatArray(3)
    private var lastMagnetometer = FloatArray(3)
    private var hasAccelerometer = false
    private var hasMagnetometer = false

    private val rotationMatrix = FloatArray(9)
    private val orientation = FloatArray(3)

    private var currentAzimuth: Float = 0f

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize sensor manager
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        magnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)

        // Compass channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, COMPASS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAzimuth" -> {
                        result.success(currentAzimuth.toDouble())
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }

        // Image channel (placeholder - requires additional implementation for camera/gallery)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, IMAGE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openCamera" -> {
                        // Camera functionality requires additional permissions and implementation
                        result.error("NOT_IMPLEMENTED", "Camera not implemented in native code. Use image_picker package.", null)
                    }
                    "openGallery" -> {
                        // Gallery functionality requires additional permissions and implementation
                        result.error("NOT_IMPLEMENTED", "Gallery not implemented in native code. Use image_picker package.", null)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    override fun onResume() {
        super.onResume()
        accelerometer?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
        }
        magnetometer?.let {
            sensorManager.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
        }
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent) {
        when (event.sensor.type) {
            Sensor.TYPE_ACCELEROMETER -> {
                System.arraycopy(event.values, 0, lastAccelerometer, 0, event.values.size)
                hasAccelerometer = true
            }
            Sensor.TYPE_MAGNETIC_FIELD -> {
                System.arraycopy(event.values, 0, lastMagnetometer, 0, event.values.size)
                hasMagnetometer = true
            }
        }

        if (hasAccelerometer && hasMagnetometer) {
            val success = SensorManager.getRotationMatrix(
                rotationMatrix,
                null,
                lastAccelerometer,
                lastMagnetometer
            )

            if (success) {
                SensorManager.getOrientation(rotationMatrix, orientation)
                // Convert from radians to degrees
                currentAzimuth = Math.toDegrees(orientation[0].toDouble()).toFloat()
                // Normalize to 0-360
                if (currentAzimuth < 0) {
                    currentAzimuth += 360f
                }
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Not needed for this implementation
    }
}
