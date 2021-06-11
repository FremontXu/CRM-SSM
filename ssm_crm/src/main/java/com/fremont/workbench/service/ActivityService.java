package com.fremont.workbench.service;

import com.fremont.settings.domain.User;
import com.fremont.vo.PaginationVo;
import com.fremont.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/7-14:51
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface ActivityService {

    int saveAct(Activity activity);

    PaginationVo<Activity> pageList(Map<String,Object> map);

    int delAct(String[] ids);

    Activity getActById(String id);

    Boolean updateAct(Activity a);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByNameAndNotByClueId(Map<String,String> map);

    List<Activity> getActivityListByName(String aname);
}
