package com.fremont.workbench.dao;

import com.fremont.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/7-16:16
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface ActivityRemarkDao {

    int saveRemark(ActivityRemark ar);

    List<ActivityRemark> getRemarkListByAid(String activityId);

    int updateRemark(ActivityRemark ar);

    int delRemark(String id);
}
