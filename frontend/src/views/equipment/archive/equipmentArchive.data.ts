import { BasicColumn, FormSchema } from '/@/components/Table';
import { rules } from '/@/utils/helper/validator';

/**
 * 设备档案-列定义（列表默认按更新时间倒序，排序由后端统一处理）
 */
export const columns: BasicColumn[] = [
  {
    title: '设备编号',
    dataIndex: 'deviceCode',
    width: 160,
    align: 'center',
  },
  {
    title: '设备名称',
    dataIndex: 'deviceName',
    width: 180,
  },
  {
    title: '设备类型',
    dataIndex: 'deviceType_dictText',
    width: 120,
    align: 'center',
  },
  {
    title: '所属部门',
    dataIndex: 'sysOrgCode_dictText',
    width: 140,
  },
  {
    title: '安装位置',
    dataIndex: 'installLocation',
    width: 160,
  },
  {
    title: '购置日期',
    dataIndex: 'purchaseDate',
    width: 120,
    align: 'center',
  },
  {
    title: '责任人',
    dataIndex: 'responsiblePerson_dictText',
    width: 110,
    align: 'center',
  },
  {
    title: '使用状态',
    dataIndex: 'useStatus_dictText',
    width: 100,
    align: 'center',
  },
  {
    title: '备注',
    dataIndex: 'remark',
    width: 200,
  },
  {
    title: '更新时间',
    dataIndex: 'updateTime',
    width: 160,
    align: 'center',
  },
];

/**
 * 设备档案-查询条件
 */
export const searchFormSchema: FormSchema[] = [
  {
    field: 'deviceCode',
    label: '设备编号',
    component: 'Input',
    colProps: { span: 6 },
  },
  {
    field: 'deviceName',
    label: '设备名称',
    component: 'Input',
    colProps: { span: 6 },
  },
  {
    field: 'deviceType',
    label: '设备类型',
    component: 'JDictSelectTag',
    componentProps: {
      dictCode: 'equipment_type',
      placeholder: '请选择设备类型',
    },
    colProps: { span: 6 },
  },
  {
    field: 'useStatus',
    label: '使用状态',
    component: 'JDictSelectTag',
    componentProps: {
      dictCode: 'equipment_use_status',
      placeholder: '请选择使用状态',
    },
    colProps: { span: 6 },
  },
  {
    field: 'sysOrgCode',
    label: '所属部门',
    component: 'JSelectDept',
    componentProps: {
      multiple: false,
      rowKey: 'orgCode',
      primaryKey: 'orgCode',
    },
    colProps: { span: 6 },
  },
  {
    field: 'responsiblePerson',
    label: '责任人',
    component: 'JSelectUser',
    componentProps: {
      rowKey: 'username',
      labelKey: 'realname',
      showButton: false,
    },
    colProps: { span: 6 },
  },
];

/**
 * 设备档案-新增/编辑表单
 */
export const formSchema: FormSchema[] = [
  {
    field: 'id',
    label: 'ID',
    component: 'Input',
    show: false,
  },
  {
    field: 'deviceCode',
    label: '设备编号',
    component: 'Input',
    required: true,
    componentProps: {
      placeholder: '请输入设备编号',
      maxlength: 64,
    },
    // 设备编号唯一校验：新增、编辑都会调用后端重复校验接口（编辑时按id排除自身）
    dynamicRules: ({ model, schema }) => {
      return rules.duplicateCheckRule('equipment_archive', 'device_code', model, schema, true);
    },
  },
  {
    field: 'deviceName',
    label: '设备名称',
    component: 'Input',
    required: true,
    componentProps: {
      placeholder: '请输入设备名称',
      maxlength: 100,
    },
  },
  {
    field: 'deviceType',
    label: '设备类型',
    component: 'JDictSelectTag',
    required: true,
    componentProps: {
      dictCode: 'equipment_type',
      placeholder: '请选择设备类型',
    },
  },
  {
    field: 'sysOrgCode',
    label: '所属部门',
    component: 'JSelectDept',
    required: true,
    componentProps: {
      multiple: false,
      rowKey: 'orgCode',
      primaryKey: 'orgCode',
    },
  },
  {
    field: 'installLocation',
    label: '安装位置',
    component: 'Input',
    componentProps: {
      placeholder: '请输入安装位置',
      maxlength: 200,
    },
  },
  {
    field: 'purchaseDate',
    label: '购置日期',
    component: 'DatePicker',
    componentProps: {
      valueFormat: 'YYYY-MM-DD',
      format: 'YYYY-MM-DD',
    },
  },
  {
    field: 'responsiblePerson',
    label: '责任人',
    component: 'JSelectUser',
    componentProps: {
      rowKey: 'username',
      labelKey: 'realname',
      showButton: false,
    },
  },
  {
    field: 'useStatus',
    label: '使用状态',
    component: 'JDictSelectTag',
    defaultValue: '1',
    required: true,
    componentProps: {
      dictCode: 'equipment_use_status',
      placeholder: '请选择使用状态',
    },
  },
  {
    field: 'remark',
    label: '备注',
    component: 'InputTextArea',
    componentProps: {
      placeholder: '请输入备注',
      rows: 3,
      maxlength: 500,
    },
  },
];
