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

@RequestMapping("/role")
@Controller
public class RoleController {
    @Autowired
    RoleService roleService;

    @ResponseBody
    @RequestMapping("/dodelete")
    public String dodelete(Integer id){
        roleService.deleteRole(id);
        return "ok";
    }

    @ResponseBody
    @RequestMapping("/doUpdate")
    public String doUpdate(TRole role){
        roleService.updateRole(role);
        return "ok";
    }
    @ResponseBody
    @RequestMapping("/getRoleById")
    public TRole getRoleById(Integer id){
        TRole tRole=roleService.getRoleById(id);
        return tRole;
    }

    @ResponseBody
    @RequestMapping("/doAdd")
    public String doAdd(TRole role){
        roleService.saveRole(role);
        return "ok";
    }

    @RequestMapping("/index")
    public String index(){
        return "role/index";
    }

    @ResponseBody
    @RequestMapping("/loadData")
    public  PageInfo<TRole> loadData(@RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
                         @RequestParam(value = "pageSize",required = false,defaultValue = "2") Integer pageSize,
                         @RequestParam(value = "condition",required = false,defaultValue = "") String condition){

        PageHelper.startPage(pageNum,pageSize);
        PageInfo<TRole> pageInfo=roleService.getPageInfo(condition);
        return pageInfo;
    }
}
