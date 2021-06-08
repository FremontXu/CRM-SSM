package com.fremont.workbench.service.impl;

import com.fremont.workbench.dao.ActivityRemarkDao;
import com.fremont.workbench.domain.ActivityRemark;
import com.fremont.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/8-11:24
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkDao activityRemarkDao;

    @Override
    public boolean saveRemark(ActivityRemark ar) {
        int i = activityRemarkDao.saveRemark(ar);
        return i > 0;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String activityId) {
        return activityRemarkDao.getRemarkListByAid(activityId);
    }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        int i = activityRemarkDao.updateRemark(ar);
        return i > 0;
    }

    @Override
    public int delRemark(String id) {
        return activityRemarkDao.delRemark(id);
    }

}
