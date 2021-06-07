package com.fremont.settings.service.impl;

import com.fremont.exception.LoginException;
import com.fremont.exception.UserException;
import com.fremont.settings.dao.UserDao;
import com.fremont.settings.domain.User;
import com.fremont.settings.service.UserService;
import com.fremont.utils.DateTimeUtil;
import com.fremont.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/6-15:49
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd) {

        Map<String, Object> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", MD5Util.getMD5(loginPwd));

        return userDao.login(map);
    }

    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }
}
