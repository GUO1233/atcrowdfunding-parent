package com.atguigu.atcrowdfunding.listener;

import com.atguigu.atcrowdfunding.util.Const;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class StartSystemInitListener implements ServletContextListener {
    //服务器启动时执行事件处理
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("StartSystemInitListener - contextInitialized");
        ServletContext application = servletContextEvent.getServletContext();
        String path = application.getContextPath();
        application.setAttribute(Const.PATH,path);
        System.out.println("PATH = " + path);

    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
