package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class AdminController {

    @Autowired
    AdminService adminService;


    @Autowired
    private RoleService roleService;

    @RequestMapping("/admin/assignRole")
    public String assignRole(Integer id, Model model) {
        // 1.查询所有角色
        List<TRole> allRoleList = roleService.listAll();

        // 2.查询该用户所拥有的角色id
        List<Integer> selfRoleIdList = roleService.listRoleIdByAdminId(id);

        List<TRole> assignList = new ArrayList<TRole>();
        List<TRole> unAssignList = new ArrayList<TRole>();

        model.addAttribute("assignList", assignList);
        model.addAttribute("unAssignList", unAssignList);

        for (TRole role : allRoleList) {

            if (selfRoleIdList.contains(role.getId())) {// 已分配
                // 3.获得已分配角色集合
                assignList.add(role);
            } else { // 未分配
                // 4.获得未分配角色集合
                unAssignList.add(role);
            }
        }

        return "admin/assignRole";
    }

    @RequestMapping("/admin/deleteBatch")
    public String deleteBatch(String ids,Integer pageNum){
        adminService.deleteBatch(ids);
        return "redirect:/admin/index?pageNum="+pageNum;
    }

    @RequestMapping("/admin/doDelete")
    public String doDelete(Integer id,Integer pageNum){
        adminService.deleteAdminById(id);
        return "redirect:/admin/index?pageNum="+pageNum;
    }

    @RequestMapping("/admin/doUpdate")
    public String doUpdate(TAdmin admin,Integer pageNum){
        adminService.updateAdmin(admin);
        return "redirect:/admin/index?pageNum="+pageNum;
    }


    @RequestMapping("/admin/toUpdate")
    public String toUpdate(Integer id,Model model){
        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("admin",admin);
        return "admin/update";
    }


    @RequestMapping("/admin/doAdd")
    public String doAdd(TAdmin admin){
        adminService.saveAdmin(admin);
        //添加后跳转到最后一页。根据分页合理化实现的。
        return "redirect:/admin/index?pageNum="+Integer.MAX_VALUE ; //保存数据后，重定向到分页查询页面
    }


    @RequestMapping("/admin/toAdd")
    public String toAdd(){
        return "admin/add";
    }



    @RequestMapping("/admin/index")
    public String index(
            @RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize",required = false,defaultValue = "2") Integer pageSize,
            @RequestParam(value = "condition",required = false,defaultValue = "") String condition,
            Model model){

        //1.开启分页插件功能
        PageHelper.startPage(pageNum,pageSize); //将数据通过ThreadLocal绑定到线程上，传递给后续流程

        //2.获取分页数据。
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("condition",condition);

        PageInfo<TAdmin> page = adminService.listPage(paramMap);

        //3.数据存储
        model.addAttribute("page",page);

        //4.跳转页面
        return "admin/index";
    }
}
