-- =====================================================================
-- 设备档案模块 增量脚本（MySQL 5.7 / 8.x）
-- 日期: 2026-09-10
-- 说明: 全新部署已由 jeecgboot-mysql-5.7.sql 初始化，无需执行本脚本。
--       已有环境升级时执行本脚本即可；脚本全程幂等、可重复执行：
--       equipment_archive 表仅在不存在时创建，不会删除已有设备档案数据；
--       字典/菜单/权限等种子数据按主键去重插入。
--       执行后请在【角色授权】中给相应角色授权“设备管理”菜单，并重新登录。
-- =====================================================================

-- 1. 设备档案表（仅新建，不删除、不覆盖已有数据）
CREATE TABLE IF NOT EXISTS `equipment_archive`  (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键id',
  `device_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备编号（唯一）',
  `device_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '设备名称',
  `device_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '设备类型',
  `sys_org_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属部门编码',
  `install_location` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '安装位置',
  `purchase_date` date NULL DEFAULT NULL COMMENT '购置日期',
  `responsible_person` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '责任人（用户名）',
  `use_status` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '使用状态（1在用 2闲置 3维修中 4报废）',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_equipment_archive_code`(`device_code`) USING BTREE,
  INDEX `idx_equipment_archive_org`(`sys_org_code`) USING BTREE,
  INDEX `idx_equipment_archive_uptime`(`update_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '设备档案表' ROW_FORMAT = DYNAMIC;

-- 2. 数据字典（设备类型 / 使用状态）
INSERT IGNORE INTO `sys_dict` VALUES ('ea000000000000000000000000000001', '设备类型', 'equipment_type', '设备档案-设备类型', 0, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, NULL);
INSERT IGNORE INTO `sys_dict` VALUES ('ea000000000000000000000000000002', '使用状态', 'equipment_use_status', '设备档案-使用状态（1在用 2闲置 3维修中 4报废）', 0, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, NULL);

INSERT IGNORE INTO `sys_dict_item` VALUES ('ea100000000000000000000000000001', 'ea000000000000000000000000000001', '机械设备', '1', 'blue', NULL, 1, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea100000000000000000000000000002', 'ea000000000000000000000000000001', '电气设备', '2', 'cyan', NULL, 2, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea100000000000000000000000000003', 'ea000000000000000000000000000001', '仪器仪表', '3', 'green', NULL, 3, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea100000000000000000000000000004', 'ea000000000000000000000000000001', '运输设备', '4', 'orange', NULL, 4, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea100000000000000000000000000005', 'ea000000000000000000000000000001', '办公设备', '5', 'purple', NULL, 5, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea100000000000000000000000000006', 'ea000000000000000000000000000001', '其他', '9', 'default', NULL, 9, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea200000000000000000000000000001', 'ea000000000000000000000000000002', '在用', '1', 'green', NULL, 1, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea200000000000000000000000000002', 'ea000000000000000000000000000002', '闲置', '2', 'default', NULL, 2, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea200000000000000000000000000003', 'ea000000000000000000000000000002', '维修中', '3', 'orange', NULL, 3, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);
INSERT IGNORE INTO `sys_dict_item` VALUES ('ea200000000000000000000000000004', 'ea000000000000000000000000000002', '报废', '4', 'red', NULL, 4, 1, 'admin', '2026-09-10 10:00:00', NULL, NULL);

-- 3. 菜单与按钮权限
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000001', '', '设备管理', '/equipment', 'layouts/default/index', 1, NULL, '/equipment/archive', 0, NULL, '1', 5.00, 1, 'ant-design:hdd-outlined', 0, 0, 0, 0, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000002', 'ea300000000000000000000000000001', '设备档案', '/equipment/archive', 'equipment/archive/index', 1, NULL, NULL, 1, NULL, '1', 1.00, 0, 'ant-design:profile-outlined', 1, 1, 0, 0, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000003', 'ea300000000000000000000000000002', '新增', NULL, NULL, 1, NULL, NULL, 2, 'equipment:archive:add', '1', 1.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000004', 'ea300000000000000000000000000002', '编辑', NULL, NULL, 1, NULL, NULL, 2, 'equipment:archive:edit', '1', 2.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000005', 'ea300000000000000000000000000002', '删除', NULL, NULL, 1, NULL, NULL, 2, 'equipment:archive:delete', '1', 3.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000006', 'ea300000000000000000000000000002', '批量删除', NULL, NULL, 1, NULL, NULL, 2, 'equipment:archive:deleteBatch', '1', 4.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000007', 'ea300000000000000000000000000002', '导出', NULL, NULL, 1, NULL, NULL, 2, 'equipment:archive:exportXls', '1', 5.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);
INSERT IGNORE INTO `sys_permission` VALUES ('ea300000000000000000000000000008', 'ea300000000000000000000000000002', '导入', NULL, NULL, 1, NULL, NULL, 2, 'equipment:archive:importExcel', '1', 6.00, 0, NULL, 1, 0, 0, NULL, NULL, 'admin', '2026-09-10 10:00:00', NULL, NULL, 0, 0, '1', 0);

-- 4. 给 admin 管理员角色（role_id=f6817f48af4fb3af11b9e8bf182f618b）授权；其他角色请在系统管理-角色授权中配置
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000001', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000001', NULL, '2026-09-10 10:00:00', NULL);
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000002', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000002', NULL, '2026-09-10 10:00:00', NULL);
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000003', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000003', NULL, '2026-09-10 10:00:00', NULL);
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000004', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000004', NULL, '2026-09-10 10:00:00', NULL);
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000005', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000005', NULL, '2026-09-10 10:00:00', NULL);
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000006', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000006', NULL, '2026-09-10 10:00:00', NULL);
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000007', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000007', NULL, '2026-09-10 10:00:00', NULL);
INSERT IGNORE INTO `sys_role_permission` VALUES ('ea400000000000000000000000000008', 'f6817f48af4fb3af11b9e8bf182f618b', 'ea300000000000000000000000000008', NULL, '2026-09-10 10:00:00', NULL);

-- 5. 重复校验表白名单（prod 防火墙模式下 /sys/duplicate/check 依赖此配置；dev 模式会自动添加）
INSERT IGNORE INTO `sys_table_white_list` VALUES ('ea500000000000000000000000000001', 'equipment_archive', '*', '1', 'admin', '2026-09-10 10:00:00', NULL, NULL);
