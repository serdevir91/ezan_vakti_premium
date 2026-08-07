import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/prayer_time_service.dart';
import '../services/adhan_notification_service.dart';

abstract class PrayerState {}

class PrayerInitial extends PrayerState {}

class PrayerLoading extends PrayerState {}

class PrayerLoaded extends PrayerState {
  final PrayerSchedule schedule;
  final Duration timeRemaining;
  final int dailyPrayersCompleted;

  PrayerLoaded({
    required this.schedule,
    required this.timeRemaining,
    required this.dailyPrayersCompleted,
  });

  PrayerLoaded copyWith({
    PrayerSchedule? schedule,
    Duration? timeRemaining,
    int? dailyPrayersCompleted,
  }) {
    return PrayerLoaded(
      schedule: schedule ?? this.schedule,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      dailyPrayersCompleted: dailyPrayersCompleted ?? this.dailyPrayersCompleted,
    );
  }
}

class PrayerCubit extends Cubit<PrayerState> {
  final PrayerTimeService _service;
  Timer? _tickerTimer;

  PrayerCubit(this._service) : super(PrayerInitial());

  Future<void> loadPrayerTimes() async {
    emit(PrayerLoading());
    try {
      final pos = await _service.getCurrentLocation();
      final schedule = await _service.getPrayerTimes(
        latitude: pos?.latitude,
        longitude: pos?.longitude,
      );

      final now = DateTime.now();
      Duration remaining = schedule.nextPrayer.time.difference(now);
      if (remaining.isNegative) remaining = Duration.zero;

      emit(PrayerLoaded(
        schedule: schedule,
        timeRemaining: remaining,
        dailyPrayersCompleted: 4, // Default 4/5 for demo
      ));

      AdhanNotificationService().scheduleAdhanAlarms(schedule);

      _startTimer();
    } catch (_) {
      final fallbackSchedule = await _service.getPrayerTimes();
      final now = DateTime.now();
      Duration remaining = fallbackSchedule.nextPrayer.time.difference(now);
      if (remaining.isNegative) remaining = Duration.zero;

      emit(PrayerLoaded(
        schedule: fallbackSchedule,
        timeRemaining: remaining,
        dailyPrayersCompleted: 4,
      ));

      _startTimer();
    }
  }

  void _startTimer() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is PrayerLoaded) {
        final current = state as PrayerLoaded;
        final now = DateTime.now();
        Duration remaining = current.schedule.nextPrayer.time.difference(now);
        if (remaining.isNegative) {
          loadPrayerTimes();
        } else {
          emit(current.copyWith(timeRemaining: remaining));
        }
      }
    });
  }

  void togglePrayerCompleted(int index) {
    if (state is PrayerLoaded) {
      final current = state as PrayerLoaded;
      int count = current.dailyPrayersCompleted;
      if (count < 5) {
        count++;
      } else {
        count = 0;
      }
      emit(current.copyWith(dailyPrayersCompleted: count));
    }
  }

  @override
  Future<void> close() {
    _tickerTimer?.cancel();
    return super.close();
  }
}
