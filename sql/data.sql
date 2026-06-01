-- 插入演示用户（密码统一为 123456，实际使用BCrypt加密，此处为占位符）
-- 注意：真实开发时密码需BCrypt.encode("123456")，本示例用明文仅作测试，正式环境必须加密
INSERT INTO `t_user` (`username`, `password`, `email`, `role`) VALUES
                                                                   ('zhangwei', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EfMlqY4YkqWqPqQqQqQqQ', 'wei@example.com', 'USER'),
                                                                   ('liyang', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EfMlqY4YkqWqPqQqQqQqQ', 'yang@example.com', 'USER'),
                                                                   ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EfMlqY4YkqWqPqQqQqQqQ', 'admin@system.com', 'ADMIN');

-- 插入分类（用户1：zhangwei）
INSERT INTO `t_category` (`user_id`, `name`, `parent_id`, `sort_order`) VALUES
                                                                            (1, 'Java编程', NULL, 1),
                                                                            (1, 'Spring Boot', NULL, 2),
                                                                            (1, '设计模式', NULL, 3),
                                                                            (1, 'JVM底层', 3, 1),      -- 设计模式下的子分类
                                                                            (2, '前端开发', NULL, 1),
                                                                            (2, 'React教程', 5, 1);

-- 插入知识条目（用户1）
INSERT INTO `t_knowledge_entry` (`user_id`, `category_id`, `title`, `content`, `summary`) VALUES
                                                                                              (1, 1, 'Java Stream API 详解', 'Stream是Java8引入的函数式编程风格...', '掌握Stream常用操作'),
                                                                                              (1, 2, 'Spring Boot 自动配置原理', '通过@EnableAutoConfiguration和条件注解...', '深入理解starter机制'),
                                                                                              (1, 3, '单例模式七种写法', '饿汉、懒汉、双重检查锁、静态内部类...', '线程安全的单例实现'),
                                                                                              (2, 5, 'ES6 箭头函数与this', '箭头函数没有自己的this，从上下文捕获...', '彻底弄懂this指向');

-- 插入标签
INSERT INTO `t_tag` (`user_id`, `name`, `color`) VALUES
                                                     (1, 'Java8', '#e67e22'),
                                                     (1, '重要', '#e74c3c'),
                                                     (1, '面试题', '#2ecc71'),
                                                     (2, 'JavaScript', '#f1c40f'),
                                                     (2, '必看', '#e74c3c');

-- 关联知识条目与标签
INSERT INTO `t_entry_tag` (`entry_id`, `tag_id`) VALUES
                                                     (1, 1),   -- Stream API → Java8
                                                     (1, 2),   -- Stream API → 重要
                                                     (2, 2),   -- Spring Boot → 重要
                                                     (2, 3),   -- Spring Boot → 面试题
                                                     (3, 3),   -- 单例模式 → 面试题
                                                     (4, 4);   -- ES6箭头函数 → JavaScript

-- 插入日程任务（轻量级）
INSERT INTO `t_task` (`user_id`, `title`, `description`, `deadline`, `priority`, `status`) VALUES
                                                                                               (1, '完成知识库系统数据库设计', '撰写ER图和建表SQL，经组长评审', '2026-06-02 18:00:00', 3, 'IN_PROGRESS'),
                                                                                               (1, '学习Spring Security JWT', '阅读官方文档并完成demo', '2026-06-05 23:59:59', 2, 'PENDING'),
                                                                                               (2, 'JavaFX界面布局优化', '完成主框架菜单和卡片式笔记列表', '2026-06-03 20:00:00', 2, 'PENDING'),
                                                                                               (2, '测试日程提醒功能', '验证deadline临近通知', '2026-06-01 10:00:00', 1, 'COMPLETED');