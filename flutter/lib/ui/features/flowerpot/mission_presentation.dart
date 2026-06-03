// 미션/보상 표시 매핑 — 미션 종류별 제목·설명·아이콘, 보상 아이템별 라벨·이미지. RN Mission/data(MISSION_PRESET·REWARD_PRESET) 대응.
import 'package:feeddiary/config/app_assets.dart';
import 'package:feeddiary/domain/models/mission_type.dart';
import 'package:feeddiary/ui/core/icons/feed_icons.dart';
import 'package:flutter/material.dart';

/// 미션 종류별 화면 표시 정보. RN `MISSION_PRESET`(TEXT.MISSION).
extension MissionTypePresentation on MissionType {
  String get title => switch (this) {
    MissionType.diary => '일기 쓰기',
    MissionType.visible => '일기 공개하기',
    MissionType.comment => '댓글 달기',
    MissionType.like => '좋아요 누르기',
  };

  String get content => switch (this) {
    MissionType.diary => '일기를 작성해 보세요.',
    MissionType.visible => '일기 설정을 공개로 전환해 보세요.',
    MissionType.comment => '일기에 댓글을 작성해 보세요.',
    MissionType.like => '다른 유저의 일기에 좋아요를 눌러 보세요.',
  };

  // RN MISSION_PRESET 아이콘(FA5 book·Ionicons eye·MCI comment-processing·Ionicons heart)과 동일 글리프.
  IconData get icon => switch (this) {
    MissionType.diary => FeedIcons.tabDiary,
    MissionType.visible => FeedIcons.visibleOn,
    MissionType.comment => FeedIcons.comment,
    MissionType.like => FeedIcons.like,
  };

  /// RN MissionIcon size — diary/visible 20·comment 21·like 22.
  double get iconSize => switch (this) {
    MissionType.diary => 20,
    MissionType.visible => 20,
    MissionType.comment => 21,
    MissionType.like => 22,
  };
}

/// 보상 아이템(물주기/사랑주기) 표시 정보. RN `REWARD_PRESET`(TEXT.REWARD) — 아이콘이 아닌 PNG 이미지.
extension PlantActionPresentation on PlantAction {
  String get label => switch (this) {
    PlantAction.watering => '물 주기',
    PlantAction.love => '사랑 주기',
  };

  /// RN FastImage(watering.png/love.png).
  String get asset => switch (this) {
    PlantAction.watering => AppAssets.wateringPlant,
    PlantAction.love => AppAssets.lovePlant,
  };

  /// RN ActionButton image size — 물 33·사랑 26.
  double get buttonImageSize => switch (this) {
    PlantAction.watering => 33,
    PlantAction.love => 26,
  };
}
