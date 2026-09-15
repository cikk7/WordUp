-- WordUp 数据库结构。该脚本可重复执行且不会删除现有业务数据。
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名登录账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '登录密码(加密密文)',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户头像地址',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '背词达人' COMMENT '用户昵称',
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '保密' COMMENT '性别：男女保密',
  `school` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未设置' COMMENT '学校',
  `grade` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '未设置' COMMENT '年级',
  `streak_days` int NULL DEFAULT 0 COMMENT '连续打卡天数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户基础信息表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `user_ai_event_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `event_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '1闭眼 2偏离镜头 3积极 4中性 5消极',
  `confidence` decimal(5, 2) NULL DEFAULT NULL COMMENT 'AI识别置信度/概率',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '事件发生时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户AI事件流水表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `user_daily_stats`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录主键',
  `user_id` bigint NOT NULL COMMENT '关联的 user 表 id',
  `record_date` date NOT NULL COMMENT '记录日期 (例如 2024-03-16)',
  `learned_count` int NULL DEFAULT 0 COMMENT '当日新学单词数',
  `reviewed_count` int NULL DEFAULT 0 COMMENT '当日复习单词数',
  `study_minutes` int NULL DEFAULT 0 COMMENT '当日学习时长(分钟)',
  `sleepy_count` int NOT NULL DEFAULT 0 COMMENT '当日打瞌睡触发次数',
  `unfocused_count` int NOT NULL DEFAULT 0 COMMENT '当日走神/偏离镜头次数',
  `happy_minutes` int NOT NULL DEFAULT 0 COMMENT '当日情绪积极时长(分钟)',
  `negative_minutes` int NOT NULL DEFAULT 0 COMMENT '当日情绪消极时长(分钟)',
  `ai_hard_words` int NOT NULL DEFAULT 0 COMMENT '当日AI情绪调度推送的难词数',
  `hard_pushed` tinyint(1) NOT NULL DEFAULT 0 COMMENT '标记今日困难词是否已全部推送完毕:0否1是',
  `easy_pushed` tinyint(1) NOT NULL DEFAULT 0 COMMENT '标记今日简单词是否已全部推送完毕:0否1是',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_date`(`user_id` ASC, `record_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '每日学习数据聚合表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `user_plan`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `book_id` bigint NOT NULL COMMENT '词书ID',
  `daily_target` int NOT NULL DEFAULT 150 COMMENT '今日待背目标数',
  `anti_sleep_on` tinyint(1) NOT NULL DEFAULT 0 COMMENT '防瞌睡开关:0关1开',
  `ai_sentence_on` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'AI造句开关:0关1开',
  `emotion_recog_on` tinyint(1) NOT NULL DEFAULT 0 COMMENT '情绪识别开关:0关1开',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `daily_new_target` int NULL DEFAULT 10 COMMENT '每日新词目标(用户输入)',
  `daily_review_target` int NULL DEFAULT 20 COMMENT '每日旧词复习目标(根据比例自动计算)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户学习计划与设置表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `user_review_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `word_id` bigint NOT NULL COMMENT '单词ID',
  `result` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '复习结果(例如: KNOWN, UNKNOWN)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '复习时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_word`(`user_id` ASC, `word_id` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户每次单词复习结果流水表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `user_word_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `word_id` bigint NOT NULL COMMENT '单词ID',
  `learn_status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0未学, 1学习中, 2已掌握',
  `is_temp_old` tinyint(1) NOT NULL DEFAULT 0 COMMENT '微观调度：是否为临时旧词 (1:是, 享有批次内最高推送优先级)',
  `consecutive_known_count` tinyint NOT NULL DEFAULT 0 COMMENT '微观调度：临时旧词连续点击认识的次数 (满3次归零并解除 is_temp_old)',
  `error_count` int NOT NULL DEFAULT 0 COMMENT '背错次数(用于判断难词)',
  `is_hard_marked` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为难词:0否1是',
  `current_stage` tinyint NOT NULL DEFAULT 1 COMMENT '当前复习阶段(1-5，分别代表:刚学习、1天后、2天后、4天后、7天后)',
  `last_batch_date` date NULL DEFAULT NULL COMMENT '最近一次分配批次的日期',
  `next_review_time` datetime NULL DEFAULT NULL COMMENT '下次复习时间(前端计算)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '首次学习时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_word`(`user_id` ASC, `word_id` ASC) USING BTREE,
  INDEX `idx_user_hard`(`user_id` ASC, `is_hard_marked` ASC) USING BTREE,
  INDEX `idx_review_time`(`user_id` ASC, `learn_status` ASC, `next_review_time` ASC) USING BTREE,
  INDEX `idx_temp_old`(`user_id` ASC, `is_temp_old` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 478 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户单词记忆记录表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `word`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `book_id` bigint NOT NULL COMMENT '所属词书ID',
  `spelling` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单词拼写',
  `phonetic` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '音标',
  `translation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '中文释义',
  `difficulty` tinyint NOT NULL DEFAULT 2 COMMENT '单词固有难度: 1难, 2中等, 3易',
  `common_meaning` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '通用释义',
  `cs_meaning` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '计算机专业释义',
  `en_example` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '英文例句',
  `cn_example` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '中文例句',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 898 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '单词字典表' ROW_FORMAT = Dynamic;

CREATE TABLE IF NOT EXISTS `word_book`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `book_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '书名',
  `total_words` int NOT NULL DEFAULT 0 COMMENT '总词汇量',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '词书表' ROW_FORMAT = Dynamic;
