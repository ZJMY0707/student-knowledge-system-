-- =============================================
-- 学生知识库与日程标注系统 - 建表脚本
-- 设计日期: 2026-05-31
-- 版本: v1.0
-- =============================================

-- 1. 用户表
CREATE TABLE IF NOT EXISTS `t_user` (
                                        `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
                                        `username` VARCHAR(50) NOT NULL COMMENT '用户名（唯一）',
    `password` VARCHAR(255) NOT NULL COMMENT '加密密码',
    `email` VARCHAR(100) COMMENT '邮箱',
    `avatar` VARCHAR(255) COMMENT '头像URL',
    `role` VARCHAR(20) DEFAULT 'USER' COMMENT '角色：ADMIN/USER',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 分类表（用户自定义，一用户多分类）
CREATE TABLE IF NOT EXISTS `t_category` (
                                            `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
                                            `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
                                            `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
    `parent_id` BIGINT DEFAULT NULL COMMENT '父分类ID（支持二级分类，可为空）',
    `sort_order` INT DEFAULT 0 COMMENT '排序序号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`parent_id`) REFERENCES `t_category`(`id`) ON DELETE SET NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识分类表';

-- 3. 知识条目表（核心）
CREATE TABLE IF NOT EXISTS `t_knowledge_entry` (
                                                   `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '知识条目ID',
                                                   `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
                                                   `category_id` BIGINT NOT NULL COMMENT '所属分类ID',
                                                   `title` VARCHAR(200) NOT NULL COMMENT '标题',
    `content` TEXT COMMENT '正文内容（支持Markdown）',
    `summary` VARCHAR(500) COMMENT '摘要',
    `view_count` INT DEFAULT 0 COMMENT '浏览次数',
    `status` VARCHAR(20) DEFAULT 'NORMAL' COMMENT '状态：NORMAL/ARCHIVED/DELETED',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`category_id`) REFERENCES `t_category`(`id`) ON DELETE RESTRICT,
    INDEX `idx_user_category` (`user_id`, `category_id`),
    INDEX `idx_title` (`title`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识条目表';

-- 4. 标签表（全局标签，但可关联用户）
CREATE TABLE IF NOT EXISTS `t_tag` (
                                       `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签ID',
                                       `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
                                       `name` VARCHAR(30) NOT NULL COMMENT '标签名称',
    `color` VARCHAR(10) DEFAULT '#3498db' COMMENT '标签颜色（十六进制）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_user_tag` (`user_id`, `name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- 5. 知识条目-标签 中间表（多对多）
CREATE TABLE IF NOT EXISTS `t_entry_tag` (
                                             `entry_id` BIGINT NOT NULL,
                                             `tag_id` BIGINT NOT NULL,
                                             `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
                                             PRIMARY KEY (`entry_id`, `tag_id`),
    FOREIGN KEY (`entry_id`) REFERENCES `t_knowledge_entry`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`tag_id`) REFERENCES `t_tag`(`id`) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识条目与标签关联表';

-- 6. 日程任务表（轻量级）
CREATE TABLE IF NOT EXISTS `t_task` (
                                        `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '任务ID',
                                        `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
                                        `title` VARCHAR(100) NOT NULL COMMENT '任务标题',
    `description` VARCHAR(500) COMMENT '任务描述',
    `deadline` DATETIME COMMENT '截止时间',
    `priority` TINYINT DEFAULT 1 COMMENT '优先级：1低 2中 3高',
    `status` VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态：PENDING/IN_PROGRESS/COMPLETED/OVERDUE',
    `reminder_time` DATETIME COMMENT '提醒时间（可选）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `t_user`(`id`) ON DELETE CASCADE,
    INDEX `idx_user_deadline` (`user_id`, `deadline`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日程任务表';