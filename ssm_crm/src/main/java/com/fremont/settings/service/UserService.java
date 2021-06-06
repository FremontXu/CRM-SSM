package com.fremont.settings.service;

import com.fremont.exception.LoginException;
import com.fremont.exception.UserException;
import com.fremont.settings.domain.User;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/6-15:49
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface UserService {

    User login(String loginAct, String loginPwd);

}
