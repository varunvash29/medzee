import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

/// Gemini models, in the order each kind of request should try them.
///
/// Each model has its own free-tier allowance, so when one is rate-limited
/// (or retired) the next one is tried instead of failing the request.
abstract final class AiModels {
  static const String flash = 'gemini-3.5-flash';
  static const String lite = 'gemini-3.5-flash-lite';

  /// Reading a photographed prescription: accuracy first.
  static const List<String> vision = <String>[flash, lite];

  /// Short text tasks. The lite model is a fallback only: it is far less
  /// reliable at structured, factual answers.
  static const List<String> text = <String>[flash, lite];
}

/// True when [e] means "this model can't serve you right now".
bool isQuotaOrMissingModel(Object e) {
  final String t = e.toString().toLowerCase();
  return t.contains('quota') ||
      t.contains('429') ||
      t.contains('resource_exhausted') ||
      t.contains('rate limit') ||
      t.contains('no longer available') ||
      t.contains('not found') ||
      t.contains('404');
}

/// True when [e] is specifically the daily/rate quota.
bool isQuotaError(Object e) {
  final String t = e.toString().toLowerCase();
  return t.contains('quota') || t.contains('429') || t.contains('resource_exhausted');
}

/// Runs [content] against each model in [models] until one answers.
Future<GenerateContentResponse> generateWithFallback({
  required List<String> models,
  required GenerativeModel Function(String model) build,
  required List<Content> content,
  Duration timeout = const Duration(seconds: 60),
}) async {
  Object? last;
  for (final String m in models) {
    try {
      return await build(m).generateContent(content).timeout(timeout);
    } catch (e) {
      last = e;
      debugPrint('AI model $m failed: $e');
      if (!isQuotaOrMissingModel(e)) rethrow;
    }
  }
  throw last ?? StateError('No AI model available.');
}
