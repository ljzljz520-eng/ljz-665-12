package org.jeecg.modules.equipment.entity;

import java.io.Serializable;
import java.util.Date;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import org.jeecg.common.aspect.annotation.Dict;
import org.jeecg.common.system.base.entity.JeecgEntity;
import org.jeecgframework.poi.excel.annotation.Excel;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * @Description: 设备档案表
 * @Author: jeecg-boot
 * @Date: 2026-09-10
 * @Version: V1.0
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@Schema(description = "设备档案")
@TableName("equipment_archive")
public class EquipmentArchive extends JeecgEntity implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 设备编号（唯一）
     */
    @Excel(name = "设备编号", width = 20)
    @Schema(description = "设备编号")
    private String deviceCode;

    /**
     * 设备名称
     */
    @Excel(name = "设备名称", width = 25)
    @Schema(description = "设备名称")
    private String deviceName;

    /**
     * 设备类型
     */
    @Excel(name = "设备类型", width = 15, dicCode = "equipment_type")
    @Dict(dicCode = "equipment_type")
    @Schema(description = "设备类型")
    private String deviceType;

    /**
     * 所属部门编码
     */
    @Excel(name = "所属部门", width = 20, dictTable = "sys_depart", dicText = "depart_name", dicCode = "org_code")
    @Dict(dictTable = "sys_depart", dicText = "depart_name", dicCode = "org_code")
    @Schema(description = "所属部门编码")
    private String sysOrgCode;

    /**
     * 安装位置
     */
    @Excel(name = "安装位置", width = 25)
    @Schema(description = "安装位置")
    private String installLocation;

    /**
     * 购置日期
     */
    @Excel(name = "购置日期", width = 15, format = "yyyy-MM-dd")
    @JsonFormat(timezone = "GMT+8", pattern = "yyyy-MM-dd")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Schema(description = "购置日期")
    private Date purchaseDate;

    /**
     * 责任人（用户名）
     */
    @Excel(name = "责任人", width = 15, dictTable = "sys_user", dicText = "realname", dicCode = "username")
    @Dict(dictTable = "sys_user", dicText = "realname", dicCode = "username")
    @Schema(description = "责任人")
    private String responsiblePerson;

    /**
     * 使用状态（1在用 2闲置 3维修中 4报废）
     */
    @Excel(name = "使用状态", width = 15, dicCode = "equipment_use_status")
    @Dict(dicCode = "equipment_use_status")
    @Schema(description = "使用状态")
    private String useStatus;

    /**
     * 备注
     */
    @Excel(name = "备注", width = 30)
    @Schema(description = "备注")
    private String remark;
}
