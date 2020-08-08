package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

/**
 * @author qi
 * @create 2020-07-28 16:36
 */
public interface RoleService {
    PageInfo<TRole> listPage(Map<String, Object> paramMap);

    void saveRole(TRole role);

    TRole getRoleById(Integer id);

    void updateRole(TRole role);

    void deleteRoleById(Integer id);

    List<TRole> listAll();

    List<Integer> listRoleIdByAdminId(Integer id);
}
