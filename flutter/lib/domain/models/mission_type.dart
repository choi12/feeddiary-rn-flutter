// 미션/식물액션 enum — 미션 종류와 보상 아이템(물주기/사랑주기). RN types/mission(Mission·PlantAction) 대응.

/// 미션 종류. 백엔드 wire 값은 enum 이름(diary/comment/visible/like)과 동일하다. RN `Mission` 유니온.
enum MissionType { diary, comment, visible, like }

/// 화분 액션이자 미션 보상 아이템. wire 값은 enum 이름(watering/love). RN `PlantAction`.
enum PlantAction { watering, love }
