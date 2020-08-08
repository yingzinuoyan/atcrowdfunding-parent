package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @author qi
 * @create 2020-07-29 11:36
 */
@Controller
public class MenuController {

    @Autowired
    MenuService menuService;

    @ResponseBody
	@RequestMapping("/menu/delete")
	public String delete(Integer id) {
		menuService.deleteTMenu(id);
		return "ok";
	}

    @ResponseBody
    @RequestMapping("/menu/update")
    public String update(TMenu menu){
        menuService.updateTMenu(menu);
        return "ok";
    }
    @ResponseBody
	@RequestMapping("/menu/get")
	public TMenu get(Integer id) {
		TMenu menu = menuService.getTMenu(id);
		return menu;
	}

    @ResponseBody
    @RequestMapping("/menu/save")
    public String save(TMenu menu){
        menuService.saveTMenu(menu);
        return "ok";
    }

    @ResponseBody
    @RequestMapping("/menu/loadTree")
    public List<TMenu> loadTree(){
        return menuService.listAllMenusTree() ;
    }


    @RequestMapping("/menu/index")
    public String index(){
        return "menu/index";
    }

}
