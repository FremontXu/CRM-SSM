package com.fremont.settings.service;


import com.fremont.settings.domain.DicValue;

import javax.servlet.ServletContext;
import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/8-17:49
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface DicService {

    Map<String,List<DicValue>> getAll(ServletContext application);
}
