package com.fremont.workbench.service.impl;

import com.fremont.workbench.dao.ClueDao;
import com.fremont.workbench.domain.Clue;
import com.fremont.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/8-17:18
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;

    @Override
    public boolean save(Clue clue) {
        return clueDao.save(clue) > 0;
    }

    @Override
    public Map<String, Object> pageList(Map<String, Object> map) {
        Integer total = clueDao.getTotalByCondition(map);
        List<Clue> cList = clueDao.pageList(map);
        Map<String, Object> map1 = new HashMap<>();
        map1.put("total", total);
        map1.put("cList", cList);
        return map1;
    }

}
