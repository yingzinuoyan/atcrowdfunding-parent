package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.bean.TRolePermissionExample;
import com.atguigu.atcrowdfunding.dao.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.dao.TRoleMapper;
import com.atguigu.atcrowdfunding.dao.TRolePermissionMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;

/**
 * @author qi
 * @create 2020-07-28 16:36
 */
@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    TRoleMapper tRoleMapper;

    @Autowired
    TAdminRoleMapper adminRoleMapper;

    @Autowired
    TRolePermissionMapper rolePermissionMapper;



    @Override
    public PageInfo<TRole> listPage(Map<String, Object> paramMap) {

        TRoleExample example = new TRoleExample();
        String condition = (String) paramMap.get("condition");
        if(!StringUtils.isEmpty(condition)){
            example.createCriteria().andNameLike("%"+condition+"%");
        }
        List<TRole> list = tRoleMapper.selectByExample(example);
        PageInfo<TRole> pageInfo = new PageInfo<>(list,5);
        return pageInfo;
    }

    @Override
    public void saveRole(TRole role) {
        tRoleMapper.insertSelective(role);
    }

    @Override
    public TRole getRoleById(Integer id) {
        return tRoleMapper.selectByPrimaryKey(id);
    }

    @Override
    public void updateRole(TRole role) {
        tRoleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void deleteRoleById(Integer id) {
        tRoleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public List<TRole> listAll() {
        return tRoleMapper.selectByExample(null);
    }

    @Override
    public List<Integer> listRoleIdByAdminId(Integer id) {
        return adminRoleMapper.listRoleIdByAdminId(id);
    }

//    @Override
//    public void saveAdminAndRoleRelationship(Integer adminId, Integer[] roleId) {
//        adminRoleMapper.saveAdminAndRoleRelationship(adminId, roleId);
//    }
//
//    @Override
//    public void deleteAdminAndRoleRelationship(Integer adminId, Integer[] roleId) {
//        adminRoleMapper.deleteAdminAndRoleRelationship(adminId, roleId);
//    }
//
//    @Override
//    public void saveRoleAndPermissionRelationship(Integer roleId, List<Integer> ids) {
//        TRolePermissionExample example = new TRolePermissionExample();
//        example.createCriteria().andRoleidEqualTo(roleId);
//        // 保存角色和许可关系数据前，将以前分配的许可关系数据删除
//        rolePermissionMapper.deleteByExample(example);
//        if (ids!=null && ids.size()>0) {
//            // 重新保存最新关系数据。（这样，不必区分哪些id是需要保存，哪些id需要删除，以及哪些id是不动的。）
//            rolePermissionMapper.saveRoleAndPermissionRelationship(roleId, ids);
//        }
//    }
//
//    @Override
//    public List<Integer> listPermissionIdByRoleId(Integer roleId) {
//        return rolePermissionMapper.listPermissionIdByRoleId(roleId);
}
