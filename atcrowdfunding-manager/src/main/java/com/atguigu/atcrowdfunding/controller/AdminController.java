package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.DateUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    AdminService adminService;

    @RequestMapping("/deleteBatch")
    public String deleteBatch(String ids,Integer pageNum){
        adminService.deleteBatch(ids);
        return "redirect:/admin/index?pageNum="+pageNum;
    }


    @RequestMapping("/delete")
    public String delete(Integer id,Integer pageNum){
        adminService.deleteAdmin(id);
        return "redirect:/admin/index?pageNum="+pageNum;
    }

    @RequestMapping("/toUpdate")
    public String toUpdate(Integer id,Model model){
        TAdmin admin=adminService.getAdminById(id);
        model.addAttribute("admin",admin);
        return "admin/update";
    }
    @RequestMapping("/update")
    public String update(TAdmin admin,Integer pageNum){
        adminService.updateAdmin(admin);
        return "redirect:/admin/index?pageNum="+pageNum;
    }

    @RequestMapping("/toAdd")
    public String toAdd(){
        return "admin/add";
    }

    @RequestMapping("/add")
    public String add(TAdmin admin){
        admin.setUserpswd("123456");
        admin.setCreatetime(DateUtil.getFormatTime());
        adminService.saveAdmin(admin);
        return "redirect:/admin/index?pageNum="+Integer.MAX_VALUE;
    }

    //admin/index
    @RequestMapping("/index")
    public String index(
           @RequestParam (value = "pageNum",required = false,defaultValue = "1")Integer pageNum,
           @RequestParam (value = "pageSize",required = false,defaultValue = "2") Integer pageSize,
           @RequestParam (value = "condition",required = false,defaultValue = "") String condition,
           Model model){
        //1.开启分页插件功能  显示第几页，每页多少条数据
        PageHelper.startPage(pageNum,pageSize);//将数据通过ThreadLocal绑定到线程上，传递给后续流程
        //2.获取分页数据。业务层调用dao层获取数据，并封装成分页对象返回。
        HashMap<String, Object> paramMap = new HashMap<>();
        paramMap.put("condition",condition);
        PageInfo<TAdmin> pageInfo = adminService.listPage(paramMap);
        //3.数据存储
        model.addAttribute("page",pageInfo);
        //4.跳转页面
        return  "admin/index";
    }
}
