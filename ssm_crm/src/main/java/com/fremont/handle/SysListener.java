package com.fremont.handle;

import com.fremont.settings.domain.DicValue;
import com.fremont.settings.service.DicService;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/8-21:33
 * @Since:jdk1.8
 * @Description:TODO
 */
public class SysListener implements ServletContextListener {

    /**
     * 该方法是用来监听上下文域对象的方法,当服务器启动,上下文域对象创建
     * 对象创建完毕后,马上执行该方法
     *
     * event: 该参数能够取得监听的对象
     *      监听的是什么对象,就可以通过该参数取得什么对象
     *      例如我们现在监听的是上下文域对象,通过该参数就可以取得上下文域对象
     */
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {

        System.out.println("初始化数据字典");
        ServletContext application = servletContextEvent.getServletContext();
        DicService dicService = WebApplicationContextUtils.getWebApplicationContext(servletContextEvent.getServletContext()).getBean(DicService.class);

        //获取数据字典
        Map<String,List<DicValue>> map = new HashMap<>();
        map = dicService.getAll(application);
        // 将map解析为上下文域对象中保存的键值对
        Set<String> set = map.keySet();
        for (String s : set) {
            application.setAttribute(s,map.get(s));
        }

        // 解析Stage2Possibility.properties文件
        Map<String,String> pMap = new HashMap<String, String>();
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> e = rb.getKeys();

        while(e.hasMoreElements()){
            // 阶段
            String key = e.nextElement();
            // 可能性
            String value = rb.getString(key);

            pMap.put(key,value);

        }
        // 将pMap保存到服务器缓存中
        application.setAttribute("pMap",pMap);
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
