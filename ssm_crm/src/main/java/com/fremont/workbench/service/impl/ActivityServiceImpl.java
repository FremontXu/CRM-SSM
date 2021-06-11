package com.fremont.workbench.service.impl;

import com.fremont.vo.PaginationVo;
import com.fremont.workbench.dao.ActivityDao;
import com.fremont.workbench.domain.Activity;
import com.fremont.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/7-14:53
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;

    @Override
    public int saveAct(Activity activity) {
        return activityDao.saveAct(activity);
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        //total
        int total = activityDao.getTotalByCondition(map);

        //list
        List<Activity> dataList = activityDao.getActListByCondition(map);

        //vo
        PaginationVo<Activity> vo = new PaginationVo<>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        System.out.println(vo);
        return vo;
    }

    @Override
    public int delAct(String[] ids) {
        int i = activityDao.delAct(ids);
        return i;
    }

    @Override
    public Activity getActById(String id) {
        return activityDao.getActById(id);
    }

    @Override
    public Boolean updateAct(Activity a) {
        int i = activityDao.updateAct(a);
        return i > 0;
    }

    @Override
    public List<Activity> getActivityListByClueId(String clueId) {
        return activityDao.getActivityListByClueId(clueId);
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {
        return activityDao.getActivityListByNameAndNotByClueId(map);
    }

    @Override
    public List<Activity> getActivityListByName(String aname) {
        return activityDao.getActivityListByName(aname);
    }

}
