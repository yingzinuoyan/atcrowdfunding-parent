package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TPermissionMenuExample;
import com.atguigu.atcrowdfunding.dao.TPermissionMapper;
import com.atguigu.atcrowdfunding.dao.TPermissionMenuMapper;
import com.atguigu.atcrowdfunding.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qi
 * @create 2020-07-30 8:40
 */
@Service
public class PermissionServiceImpl implements PermissionService {

    @Autowired
    TPermissionMapper permissionMapper;

	@Autowired
    TPermissionMenuMapper permissionMenuMapper;

	@Override
	public List<TPermission> getAllPermissions() {
		return permissionMapper.selectByExample(null);
	}

	@Override
	public void savePermission(TPermission permission) {
		permissionMapper.insertSelective(permission);
	}

	@Override
	public void deletePermission(Integer id) {
		permissionMapper.deleteByPrimaryKey(id);
	}

	@Override
	public void editPermission(TPermission permission) {
		permissionMapper.updateByPrimaryKeySelective(permission);
	}

	@Override
	public TPermission getPermissionById(Integer id) {
		return permissionMapper.selectByPrimaryKey(id);
	}

	@Override
	public void assignPermissionToMenu(Integer mid, List<Integer> perIdArray) {
		// 1、删除之前菜单对应的权限
		TPermissionMenuExample example = new TPermissionMenuExample();
		example.createCriteria().andMenuidEqualTo(mid);
		permissionMenuMapper.deleteByExample(example);
		// 2、插入提交过来的新的权限集合
		if (perIdArray!=null && perIdArray.size() > 0) {
			permissionMenuMapper.insertBatch(mid, perIdArray);
		}
	}

	@Override
	public List<TPermission> getPermissionByMenuid(Integer mid) {
		return permissionMapper.getPermissionByMenuid(mid);
	}

}
