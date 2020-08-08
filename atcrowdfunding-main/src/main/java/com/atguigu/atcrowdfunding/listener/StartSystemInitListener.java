package com.atguigu.atcrowdfunding.listener;

import com.atguigu.atcrowdfunding.util.Const;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * ServletContextListener 监听服务器启动和消化时触发事件。重点监听ServletContext对象的创建和消化。
 */
public class StartSystemInitListener implements ServletContextListener {

    //服务器启动时执行事件处理
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("StartSystemInitListener - contextInitialized");
        ServletContext application = servletContextEvent.getServletContext();
        String contextPath = application.getContextPath();
        application.setAttribute(Const.PATH,contextPath);
        System.out.println("contextPath = " + contextPath);
    }

    //服务器停止时执行事件处理
    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("StartSystemInitListener - contextDestroyed");
    }
}
