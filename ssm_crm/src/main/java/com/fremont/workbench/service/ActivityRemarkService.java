package com.fremont.workbench.service;

import com.fremont.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/8-11:24
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface ActivityRemarkService {
    boolean saveRemark(ActivityRemark ar);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    boolean updateRemark(ActivityRemark ar);

    int delRemark(String id);
}
