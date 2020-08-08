package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TPermission;

import java.util.List;

/**
 * @author qi
 * @create 2020-07-30 8:39
 */
public interface PermissionService {
    List<TPermission> getAllPermissions();

	void savePermission(TPermission permission);

	void deletePermission(Integer id);

	void editPermission(TPermission permission);

	TPermission getPermissionById(Integer id);

	List<TPermission> getPermissionByMenuid(Integer mid);

	void assignPermissionToMenu(Integer mid, List<Integer> perIdArray);
}
