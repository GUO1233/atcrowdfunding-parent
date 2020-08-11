package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.execption.LoginException;
import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MeauService;
import com.atguigu.atcrowdfunding.util.Const;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class DispatcherController {
    @Autowired
    AdminService adminService;
    @Autowired
    MeauService meauService;

    @RequestMapping("/main")
    public String main(HttpSession session){
        System.out.println("main...");
        if (session.getAttribute("listParentMenus")==null){
            List<TMenu> tMenus = meauService.queryTMenus();
            session.setAttribute("listParentMenus",tMenus);
        }
        return "main";
    }

    @RequestMapping("/login")
    public String login(String loginacct, String userpswd, HttpSession session, Model model){
        try {
            TAdmin admin = adminService.getAdminByLogin(loginacct, userpswd);
            session.setAttribute(Const.LOGIN_ADMIN,admin);
            return "redirect:/main";
        } catch (LoginException e) {
            e.printStackTrace();
            model.addAttribute("message",e.getMessage());
            return "forward:/login.jsp";
        }catch(Exception e){
            e.printStackTrace();
            model.addAttribute("message","系统出现问题");
            return "forward:/login.jsp";
        }

    }
    @RequestMapping("/loginOut")
    public String loginOut(HttpSession session){
        TAdmin admin = (TAdmin)session.getAttribute(Const.LOGIN_ADMIN);
        if(admin!=null){
            session.invalidate();
        }
        return "redirect:/login.jsp";
    }

/*    public static void main(String[] args) throws SQLException {
        Connection connection = dataSource.getConnection();
        System.out.println("connection = " + connection);

    }*/
}
