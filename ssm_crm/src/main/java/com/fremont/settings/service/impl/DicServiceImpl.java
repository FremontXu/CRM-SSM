package com.fremont.settings.service.impl;

import com.fremont.settings.dao.DicTypeDao;
import com.fremont.settings.dao.DicValueDao;
import com.fremont.settings.dao.UserDao;
import com.fremont.settings.domain.DicType;
import com.fremont.settings.domain.DicValue;
import com.fremont.settings.service.DicService;
import org.springframework.stereotype.Service;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/8-17:49
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class DicServiceImpl implements DicService {


    @Override
    public Map<String, List<DicValue>> getAll(ServletContext application) {

        DicTypeDao dicTypeDao = WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicTypeDao.class);
        DicValueDao dicValueDao = WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicValueDao.class);
        //UserDao userDao = WebApplicationContextUtils.getWebApplicationContext(application).getBean(UserDao.class);


        Map<String,List<DicValue>> map = new HashMap<>();

        // 将字典类型列表取出
        List<DicType> dtList = dicTypeDao.getTypeList();

        // 将字典类型列表遍历
        for(DicType dicType : dtList){
            // 取得每一种类型的字典类型编码
            String code = dicType.getCode();
            // 根据每一个字典类型来取得字典值列表
            List<DicValue> dvList = dicValueDao.getListByCode(code);
            map.put(code+"List",dvList);
        }

        return map;
    }
}
