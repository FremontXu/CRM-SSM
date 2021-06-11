package com.fremont.workbench.service;

import com.fremont.workbench.domain.Contacts;

import java.util.List;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/10-12:52
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface ContactsService {

    List<Contacts> getContactsByName(String cname);

}
