package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.MeauService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/menu")
public class MenuController {
    @Autowired
    MeauService meauService;
    @ResponseBody
    @RequestMapping("/update")
    public void update(TMenu menu){
       meauService.updateMenu(menu);

    }
    @ResponseBody
    @RequestMapping("/doUpdate")
    public TMenu doUpdate(Integer id){
        TMenu menu=meauService.doUpdateGetMenu(id);
        return menu;
    }

    @ResponseBody
    @RequestMapping("/delete")
    public String save(Integer id){
        meauService.deleteMenu(id);
        return "ok";
    }

    @ResponseBody
    @RequestMapping("/add")
    public String save(TMenu menu){
        meauService.saveMenu(menu);
        return "ok";
    }

    //loadTree
    @ResponseBody
    @RequestMapping("/loadTree")
    public List<TMenu> loadTree(){
        List<TMenu> list=meauService.listAllMeanusTree();
        return list;
    }
    //menu/index
    @RequestMapping("/index")
    public String index(){
        return "menu/index";
    }

}
