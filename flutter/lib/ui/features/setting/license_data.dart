// 오픈소스 라이선스 목록 — Flutter 스택 의존성(이름/라이선스/설명 3필드). RN License/data.ts 구조 1:1, 내용은 Flutter 의존성.
/// 라이선스 화면에 노출하는 라이브러리 한 줄. RN `LicenseItem`(libraryName/_license/_description) 대응.
class LicenseEntry {
  const LicenseEntry({required this.name, required this.license, required this.description});

  final String name;
  final String license;
  final String description;
}

/// 사용 중인 오픈소스 라이브러리. RN 은 React Native 의존성이지만 Flutter 는 자신의 pubspec 의존성을 나열한다(스택별 동등 목록).
const List<LicenseEntry> openSourceLicenses = [
  LicenseEntry(
    name: 'flutter',
    license: 'BSD-3-Clause',
    description: 'The portable UI toolkit for building natively compiled applications from a single codebase.',
  ),
  LicenseEntry(
    name: 'flutter_riverpod',
    license: 'MIT',
    description: 'A reactive caching and state-management framework with compile-time safety.',
  ),
  LicenseEntry(
    name: 'riverpod_annotation',
    license: 'MIT',
    description: 'Annotations for generating providers with riverpod_generator and build_runner.',
  ),
  LicenseEntry(
    name: 'go_router',
    license: 'BSD-3-Clause',
    description: 'A declarative routing package built on the Router API with deep-linking support.',
  ),
  LicenseEntry(
    name: 'dio',
    license: 'MIT',
    description: 'A powerful HTTP client for Dart with interceptors, FormData, and timeout handling.',
  ),
  LicenseEntry(
    name: 'freezed_annotation',
    license: 'MIT',
    description: 'Annotations for the freezed code generator (immutable models, unions, copyWith).',
  ),
  LicenseEntry(
    name: 'json_annotation',
    license: 'BSD-3-Clause',
    description: 'Annotations for json_serializable to convert JSON into typed models.',
  ),
  LicenseEntry(
    name: 'flutter_secure_storage',
    license: 'BSD-3-Clause',
    description: 'Encrypted key-value storage backed by Keychain (iOS) and Keystore (Android).',
  ),
  LicenseEntry(
    name: 'shared_preferences',
    license: 'BSD-3-Clause',
    description: 'Persistent key-value storage wrapping each platform store for simple data.',
  ),
  LicenseEntry(
    name: 'lottie',
    license: 'MIT',
    description: 'Renders After Effects animations exported as JSON (Bodymovin) natively.',
  ),
  LicenseEntry(
    name: 'image_picker',
    license: 'BSD-3-Clause',
    description: 'Picks images and videos from the device gallery or camera.',
  ),
  LicenseEntry(
    name: 'url_launcher',
    license: 'BSD-3-Clause',
    description: 'Launches URLs, emails, and other schemes in the mobile platform.',
  ),
];
