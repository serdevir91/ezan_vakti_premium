import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewService {

  static const String _hasReviewedKey = 'has_reviewed_app';
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> requestInAppReview({bool isManualTrigger = false}) async {
    final prefs = await SharedPreferences.getInstance();
    bool hasReviewed = prefs.getBool(_hasReviewedKey) ?? false;

    if (!isManualTrigger && hasReviewed) return;

    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
        await prefs.setBool(_hasReviewedKey, true);
      } else {
        await openStoreListing();
      }
    } catch (_) {
      await openStoreListing();
    }
  }

  Future<void> openStoreListing() async {
    try {
      await _inAppReview.openStoreListing(
        appStoreId: 'com.ezanvakti.premium',
      );
    } catch (_) {}
  }
}
