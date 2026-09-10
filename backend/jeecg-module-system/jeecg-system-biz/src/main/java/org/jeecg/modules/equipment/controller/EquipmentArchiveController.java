package org.jeecg.modules.equipment.controller;

import java.util.Arrays;
import java.util.List;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.jeecg.common.api.vo.Result;
import org.jeecg.common.aspect.annotation.AutoLog;
import org.jeecg.common.constant.CommonConstant;
import org.jeecg.common.system.base.controller.JeecgController;
import org.jeecg.common.system.query.QueryGenerator;
import org.jeecg.modules.equipment.entity.EquipmentArchive;
import org.jeecg.modules.equipment.service.IEquipmentArchiveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

/**
 * @Description: 设备档案表
 * @Author: jeecg-boot
 * @Date: 2026-09-10
 * @Version: V1.0
 */
@Slf4j
@Tag(name = "设备档案")
@RestController
@RequestMapping("/equipment/archive")
public class EquipmentArchiveController extends JeecgController<EquipmentArchive, IEquipmentArchiveService> {

    @Autowired
    private IEquipmentArchiveService equipmentArchiveService;

    /**
     * 分页列表查询（默认按更新时间倒序）
     *
     * @param equipmentArchive 查询条件
     * @param pageNo           页码
     * @param pageSize         每页条数
     * @param req              请求
     * @return 分页数据
     */
    @Operation(summary = "设备档案-分页列表查询")
    @GetMapping(value = "/list")
    public Result<?> queryPageList(EquipmentArchive equipmentArchive,
                                   @RequestParam(name = "pageNo", defaultValue = "1") Integer pageNo,
                                   @RequestParam(name = "pageSize", defaultValue = "10") Integer pageSize,
                                   HttpServletRequest req) {
        QueryWrapper<EquipmentArchive> queryWrapper = QueryGenerator.initQueryWrapper(equipmentArchive, req.getParameterMap());
        queryWrapper.orderByDesc("update_time");
        Page<EquipmentArchive> page = new Page<>(pageNo, pageSize);
        IPage<EquipmentArchive> pageList = equipmentArchiveService.page(page, queryWrapper);
        return Result.OK(pageList);
    }

    /**
     * 添加（校验设备编号唯一）
     *
     * @param equipmentArchive 设备档案
     * @return 结果
     */
    @AutoLog(value = "设备档案-添加")
    @Operation(summary = "设备档案-添加")
    @PostMapping(value = "/add")
    public Result<?> add(@RequestBody EquipmentArchive equipmentArchive) {
        String validMsg = this.validateDeviceCode(equipmentArchive.getDeviceCode(), null);
        if (validMsg != null) {
            return Result.error(validMsg);
        }
        equipmentArchiveService.save(equipmentArchive);
        return Result.OK("添加成功！");
    }

    /**
     * 编辑（校验设备编号唯一）
     *
     * @param equipmentArchive 设备档案
     * @return 结果
     */
    @AutoLog(value = "设备档案-编辑", operateType = CommonConstant.OPERATE_TYPE_3)
    @Operation(summary = "设备档案-编辑")
    @RequestMapping(value = "/edit", method = {RequestMethod.PUT, RequestMethod.POST})
    public Result<?> edit(@RequestBody EquipmentArchive equipmentArchive) {
        if (StringUtils.isBlank(equipmentArchive.getId())) {
            return Result.error("缺少主键ID，无法编辑！");
        }
        String validMsg = this.validateDeviceCode(equipmentArchive.getDeviceCode(), equipmentArchive.getId());
        if (validMsg != null) {
            return Result.error(validMsg);
        }
        equipmentArchiveService.updateById(equipmentArchive);
        return Result.OK("编辑成功！");
    }

    /**
     * 通过id删除
     *
     * @param id 主键
     * @return 结果
     */
    @AutoLog(value = "设备档案-通过id删除")
    @Operation(summary = "设备档案-通过id删除")
    @DeleteMapping(value = "/delete")
    public Result<?> delete(@RequestParam(name = "id") String id) {
        equipmentArchiveService.removeById(id);
        return Result.OK("删除成功！");
    }

    /**
     * 批量删除
     *
     * @param ids 主键集合，逗号分隔
     * @return 结果
     */
    @AutoLog(value = "设备档案-批量删除")
    @Operation(summary = "设备档案-批量删除")
    @DeleteMapping(value = "/deleteBatch")
    public Result<?> deleteBatch(@RequestParam(name = "ids") String ids) {
        this.equipmentArchiveService.removeByIds(Arrays.asList(ids.split(",")));
        return Result.OK("批量删除成功！");
    }

    /**
     * 通过id查询
     *
     * @param id 主键
     * @return 设备档案
     */
    @Operation(summary = "设备档案-通过id查询")
    @GetMapping(value = "/queryById")
    public Result<?> queryById(@RequestParam(name = "id") String id) {
        EquipmentArchive equipmentArchive = equipmentArchiveService.getById(id);
        return Result.OK(equipmentArchive);
    }

    /**
     * 导出excel
     *
     * @param request           请求
     * @param equipmentArchive 查询条件
     * @return ModelAndView
     */
    @RequestMapping(value = "/exportXls")
    public ModelAndView exportXls(HttpServletRequest request, EquipmentArchive equipmentArchive) {
        return super.exportXls(request, equipmentArchive, EquipmentArchive.class, "设备档案");
    }

    /**
     * 通过excel导入数据
     *
     * @param request  请求
     * @param response 响应
     * @return 结果
     */
    @Operation(summary = "设备档案-导入")
    @PostMapping(value = "/importExcel")
    public Result<?> importExcel(HttpServletRequest request, HttpServletResponse response) {
        return super.importExcel(request, response, EquipmentArchive.class);
    }

    /**
     * 校验设备编号唯一性
     *
     * @param deviceCode 设备编号
     * @param id         当前记录ID（编辑时排除自身，新增时为null）
     * @return 错误信息，null表示校验通过
     */
    private String validateDeviceCode(String deviceCode, String id) {
        if (StringUtils.isBlank(deviceCode)) {
            return "设备编号不允许为空！";
        }
        LambdaQueryWrapper<EquipmentArchive> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(EquipmentArchive::getDeviceCode, deviceCode);
        if (StringUtils.isNotBlank(id)) {
            queryWrapper.ne(EquipmentArchive::getId, id);
        }
        List<EquipmentArchive> existList = equipmentArchiveService.list(queryWrapper);
        if (existList != null && !existList.isEmpty()) {
            return "设备编号【" + deviceCode + "】已存在，请更换！";
        }
        return null;
    }
}
