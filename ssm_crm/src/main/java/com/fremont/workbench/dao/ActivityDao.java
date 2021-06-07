package com.fremont.workbench.dao;


import com.fremont.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/7-14:49
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface ActivityDao {

    int saveAct(Activity activity);

    Integer getTotalByCondition(Map<String, Object> map);

    List<Activity> getActListByCondition(Map<String,Object> map);

    int delAct(String[] ids);
}
