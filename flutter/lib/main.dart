// 앱 진입점 — Riverpod ProviderScope 로 앱 전체를 감싸 실행.
import 'package:feeddiary/app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: FeedDiaryApp()));
}
