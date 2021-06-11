package com.fremont.workbench.service.impl;

import com.fremont.workbench.dao.CustomerDao;
import com.fremont.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/10-15:07
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerDao customerDao;

    @Override
    public List<String> getCustomerName(String name) {
        return customerDao.getCustomerName(name);
    }
}
