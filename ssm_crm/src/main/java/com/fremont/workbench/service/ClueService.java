package com.fremont.workbench.service;

import com.fremont.workbench.domain.Clue;

import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/8-17:18
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface ClueService {

    boolean save(Clue clue);

    Map<String,Object> pageList(Map<String,Object> map);
}
