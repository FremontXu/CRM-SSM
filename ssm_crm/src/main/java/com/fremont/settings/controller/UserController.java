package com.fremont.settings.controller;

import com.fremont.exception.LoginException;
import com.fremont.settings.domain.User;
import com.fremont.settings.service.UserService;
import com.fremont.utils.DateTimeUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/6-15:51
 * @Since:jdk1.8
 * @Description:TODO
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService userService;

    /**
     * 处理登录
     *
     * @param loginAct 登录账号
     * @param loginPwd 登录密码
     * @param request  请求
     * @throws LoginException 登录失败异常
     */
    @RequestMapping("/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, HttpServletRequest request) throws Exception {

        //获取IP
        String ip = request.getRemoteAddr();
        System.out.println(loginAct + " " + loginPwd + " " + ip);

        User user = userService.login(loginAct, loginPwd);

        //验证登录:登录失败，抛出异常
        if (user == null) {
            throw new LoginException("login information error");
        }
        System.out.println("找到信息");
        //验证失效时间 expire time
        String currentTime = DateTimeUtil.getSysTime();
        if (currentTime.compareTo(user.getExpireTime()) > 0) {
            throw new LoginException("user is not valid");
        }
        System.out.println("登录时间：" + currentTime);

        //判断锁定
        if ("0".equals(user.getLockState())) {
            throw new LoginException("user is locked");
        }
        System.out.println("账号未锁定");

        //判断ip
        if (!user.getAllowIps().contains(ip)) {
            throw new LoginException("IP is not allowed");
        }
        System.out.println("IP:" + ip);

        //登录成功
        System.out.println("登录成功");
        request.getSession().setAttribute("user", user);

        Map<String, Object> map = new HashMap<>();
        map.put("result", true);
        return map;
    }

    /**
     * 注销登录
     *
     * @param request 请求
     * @return 返回到登录页面
     */
    @RequestMapping("/logOut.do")
    public String logOut(HttpServletRequest request) {
        request.getSession().invalidate();
        System.out.println("注销");
        return "login";
    }

}
