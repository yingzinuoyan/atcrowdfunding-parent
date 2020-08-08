package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TMenu;

import java.util.List;

public interface MenuService {
    List<TMenu> listAllMenus();

    List<TMenu> listAllMenusTree();

    void saveTMenu(TMenu menu);

    void updateTMenu(TMenu menu);

    void deleteTMenu(Integer id);

    TMenu getTMenu(Integer id);
}
