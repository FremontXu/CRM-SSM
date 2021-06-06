package com.fremont.handle;

import com.fremont.exception.LoginException;
import com.fremont.utils.PrintJson;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/6-19:45
 * @Since:jdk1.8
 * @Description:TODO
 */
@ControllerAdvice
@EnableWebMvc
public class GlobalExceptionHandler{

    @ExceptionHandler(LoginException.class)
    @ResponseBody
    public Object doLoginException(LoginException ex) {

        System.out.println("登录失败");
        System.out.println(ex.getMsg());
        Map<String, Object> map = new HashMap<>();
        map.put("result", false);
        map.put("msg", ex.getMsg());
        return map;
    }


}
