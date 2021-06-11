package com.fremont.workbench.service.impl;

import com.fremont.workbench.dao.ContactsDao;
import com.fremont.workbench.domain.Contacts;
import com.fremont.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/10-12:53
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsDao contactsDao;


    @Override
    public List<Contacts> getContactsByName(String cname) {
        return contactsDao.getContactsByName(cname);
    }
}
