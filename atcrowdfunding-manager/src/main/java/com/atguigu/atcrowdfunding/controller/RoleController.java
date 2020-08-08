package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

/**
 * @author qi
 * @create 2020-07-28 16:34
 */
@Controller
public class RoleController {

    @Autowired
    RoleService roleService;


    @ResponseBody
    @RequestMapping("/role/doDelete")
    public String doDelete(Integer id){
        roleService.deleteRoleById(id);
        return "ok";
    }

    @ResponseBody
    @RequestMapping("/role/doUpdate")
    public String doUpdate(TRole role){
        roleService.updateRole(role);
        return "ok";
    }

    @ResponseBody
    @RequestMapping("/role/getRoleById")
    public TRole get(Integer id){
        return roleService.getRoleById(id);
    }

    @ResponseBody
    @RequestMapping("/role/doAdd")
    public String doAdd(TRole role){
        roleService.saveRole(role);
        return "ok";
    }

    @ResponseBody // 将bean数据转换成json格式 return 就返回的是本来的 不是跳转路径
    @RequestMapping("/role/loadData")
    public PageInfo<TRole> loadData(
            // value = "" 默认的名字  required= false 是可以为空,defaultValue 设置默认值为..
            @RequestParam(value = "pageNum",required = false,defaultValue = "") Integer pageNum,
            @RequestParam(value = "pageSize",required = false,defaultValue = "") Integer pageSize,
            @RequestParam(value = "condition",required = false,defaultValue = "") String condition){

        PageHelper.startPage(pageNum,pageSize);

        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("condition",condition);

        PageInfo<TRole> pageInfo = roleService.listPage(paramMap);
        return pageInfo;
    }
    @RequestMapping("role/index")
    public String index(){
        return "role/index";
    }

}
