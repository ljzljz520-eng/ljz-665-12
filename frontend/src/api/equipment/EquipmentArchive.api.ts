import { defHttp } from '/@/utils/http/axios';
import { Modal } from 'ant-design-vue';

enum Api {
  list = '/equipment/archive/list',
  save = '/equipment/archive/add',
  edit = '/equipment/archive/edit',
  get = '/equipment/archive/queryById',
  delete = '/equipment/archive/delete',
  deleteBatch = '/equipment/archive/deleteBatch',
  exportXlsUrl = '/equipment/archive/exportXls',
  importExcelUrl = '/equipment/archive/importExcel',
}

/**
 * 导出api
 */
export const getExportUrl = Api.exportXlsUrl;
/**
 * 导入api
 */
export const getImportUrl = Api.importExcelUrl;

/**
 * 查询设备档案列表（默认按更新时间倒序，由后端统一排序）
 * @param params
 */
export const getEquipmentArchiveList = (params) => {
  return defHttp.get({ url: Api.list, params });
};

/**
 * 保存或者更新设备档案
 * @param params
 * @param isUpdate
 */
export const saveOrUpdateEquipmentArchive = (params, isUpdate) => {
  let url = isUpdate ? Api.edit : Api.save;
  return defHttp.post({ url: url, params });
};

/**
 * 查询设备档案详情
 * @param params
 */
export const getEquipmentArchiveById = (params) => {
  return defHttp.get({ url: Api.get, params });
};

/**
 * 删除设备档案
 * @param params
 * @param handleSuccess
 */
export const deleteEquipmentArchive = (params, handleSuccess) => {
  return defHttp.delete({ url: Api.delete, data: params }, { joinParamsToUrl: true }).then(() => {
    handleSuccess();
  });
};

/**
 * 批量删除设备档案
 * @param params
 * @param handleSuccess
 */
export const batchDeleteEquipmentArchive = (params, handleSuccess) => {
  Modal.confirm({
    title: '确认删除',
    content: '是否删除选中数据',
    okText: '确认',
    cancelText: '取消',
    onOk: () => {
      return defHttp.delete({ url: Api.deleteBatch, data: params }, { joinParamsToUrl: true }).then(() => {
        handleSuccess();
      });
    },
  });
};
