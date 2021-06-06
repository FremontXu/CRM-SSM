package com.fremont.settings.dao;

import com.fremont.settings.domain.User;

import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/6-15:41
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface UserDao {

    User login(Map<String, Object> map);

}
