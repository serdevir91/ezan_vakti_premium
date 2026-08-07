import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:ezan_vakti_premium/l10n/app_localizations.dart';
import '../../../core/services/qibla_service.dart';
import '../../../core/theme/app_colors.dart';

class QiblaScreen extends StatefulWidget {
  final bool isActive;

  const QiblaScreen({
    super.key,
    this.isActive = true,
  });

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double _userLat = 41.0082; // Default fallback (Istanbul)
  double _userLng = 28.9784;
  late double _kaabaBearing;
  double _heading = 0.0;
  bool _isAligned = false;
  bool _isDisposed = false;
  bool _hasLocationPermission = false;
  bool _vibrationSettingEnabled = true;
  bool _sensorDetected = false;
  bool _manualMode = false;

  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _kaabaBearing = QiblaService.calculateQiblaBearing(_userLat, _userLng);
    _loadVibrationPref();
    if (widget.isActive) {
      _requestLocationAndInitCompass();
    }
  }

  @override
  void didUpdateWidget(covariant QiblaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _requestLocationAndInitCompass();
      } else {
        _stopCompassStream();
      }
    }
  }

  Future<void> _loadVibrationPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted && !_isDisposed) {
      setState(() {
        _vibrationSettingEnabled = prefs.getBool('pref_vibration_enabled') ?? true;
      });
    }
  }

  Future<void> _requestLocationAndInitCompass() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _hasLocationPermission = true;
        Position pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
        );
        if (!_isDisposed && mounted) {
          setState(() {
            _userLat = pos.latitude;
            _userLng = pos.longitude;
            _kaabaBearing = QiblaService.calculateQiblaBearing(_userLat, _userLng);
          });
        }
      }
    } catch (_) {}

    if (widget.isActive) {
      _startCompassStream();
    }
  }

  int _lastCompassTime = 0;
  double _lastHeadingValue = -1.0;

  void _startCompassStream() {
    _stopCompassStream();
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (_isDisposed || !mounted || !widget.isActive) return;

      if (event.heading != null && !_manualMode) {
        double currentHeading = event.heading!;
        if (currentHeading < 0) currentHeading += 360;

        final now = DateTime.now().millisecondsSinceEpoch;
        // Throttle updates: minimum 100ms or 0.8 degree change to prevent lag
        if ((currentHeading - _lastHeadingValue).abs() >= 0.8 || (now - _lastCompassTime) > 120) {
          _lastHeadingValue = currentHeading;
          _lastCompassTime = now;
          _updateAlignment(currentHeading, true);
        }
      }
    });

    // If no sensor event arrives after 2 seconds, indicate manual mode available
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_sensorDetected) {
        setState(() {
          _sensorDetected = false;
        });
      }
    });
  }

  void _updateAlignment(double currentHeading, bool sensorActive) {
    double diff = (currentHeading - _kaabaBearing).abs();
    bool aligned = diff <= 4 || (360 - diff) <= 4;

    if (aligned && !_isAligned && mounted && !_isDisposed && widget.isActive && _vibrationSettingEnabled) {
      Vibration.hasVibrator().then((hasVib) {
        if (hasVib == true && mounted && !_isDisposed && widget.isActive && _vibrationSettingEnabled) {
          Vibration.vibrate(duration: 150);
        }
      });
    }

    if (mounted && !_isDisposed) {
      setState(() {
        _heading = currentHeading;
        _isAligned = aligned;
        _sensorDetected = sensorActive;
      });
    }
  }

  void _stopCompassStream() {
    _compassSubscription?.cancel();
    _compassSubscription = null;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stopCompassStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double distanceKm = QiblaService.calculateDistanceToKaaba(_userLat, _userLng);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qibla),
        actions: [
          IconButton(
            icon: Icon(_manualMode ? Icons.back_hand : Icons.screen_rotation),
            tooltip: _manualMode ? l10n.sensorMode : l10n.manualMode,
            onPressed: () {
              setState(() {
                _manualMode = !_manualMode;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Aligned Badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isAligned ? AppColors.emeraldAccent : AppColors.goldPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isAligned ? Colors.white : AppColors.goldPrimary,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isAligned ? Icons.check_circle : Icons.navigation,
                      color: _isAligned ? Colors.white : AppColors.goldPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isAligned ? l10n.qiblaAligned : l10n.alignDevice,
                      style: TextStyle(
                        color: _isAligned ? Colors.white : AppColors.goldPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (_manualMode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "👆 ${l10n.manualCompassHint}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.goldPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),

              if (!_hasLocationPermission)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldPrimary,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.location_on),
                    label: Text(l10n.enableLocation),
                    onPressed: _requestLocationAndInitCompass,
                  ),
                ),

              // Interactive / Sensor Compass Ring
              GestureDetector(
                onPanUpdate: _manualMode
                    ? (details) {
                        double newHeading = (_heading + details.delta.dx * 0.5) % 360;
                        if (newHeading < 0) newHeading += 360;
                        _updateAlignment(newHeading, false);
                      }
                    : null,
                child: SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Compass Rose - rotates opposite to heading
                      Transform.rotate(
                        angle: -_heading * (3.14159265 / 180),
                        child: Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isAligned ? AppColors.emeraldAccent : AppColors.goldPrimary,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_isAligned ? AppColors.emeraldAccent : AppColors.goldPrimary).withValues(alpha: 0.25),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // N label
                              Positioned(
                                top: 12,
                                child: Text('N', style: TextStyle(
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                              ),
                              // S label
                              Positioned(
                                bottom: 12,
                                child: Text('S', style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                              ),
                              // E label
                              Positioned(
                                right: 12,
                                child: Text('E', style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                              ),
                              // W label
                              Positioned(
                                left: 12,
                                child: Text('W', style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                              ),
                              // North needle (red arrow)
                              Positioned(
                                top: 30,
                                child: Icon(Icons.arrow_drop_up, color: Colors.red.shade400, size: 36),
                              ),
                              // Inner ring
                              Center(
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.goldPrimary.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Kaaba Direction Pointer
                      Transform.rotate(
                        angle: (_kaabaBearing - _heading) * (3.14159265 / 180),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _isAligned ? AppColors.emeraldAccent : AppColors.goldAccent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isAligned ? AppColors.emeraldAccent : AppColors.goldAccent).withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.mosque, color: Colors.black, size: 24),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),

                      // Center circle with heading degree
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: _isAligned ? AppColors.emeraldAccent : AppColors.goldPrimary,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${_heading.toStringAsFixed(0)}°',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _isAligned ? AppColors.emeraldAccent : AppColors.goldPrimary,
                          ),
                        ),
                      ),

                      // Fixed top indicator (device direction)
                      Positioned(
                        top: 0,
                        child: Container(
                          width: 3,
                          height: 14,
                          decoration: BoxDecoration(
                            color: _isAligned ? AppColors.emeraldAccent : AppColors.goldPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Compass Stats
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(l10n.angleToMecca, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "${_kaabaBearing.toStringAsFixed(1)}°",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      Container(height: 30, width: 1, color: Colors.grey.withValues(alpha: 0.3)),
                      Column(
                        children: [
                          const Text("Kâbe Uzaklığı", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            "${distanceKm.toStringAsFixed(0)} km",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
