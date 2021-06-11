package com.fremont.workbench.dao;


import com.fremont.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int save(Contacts con);

    List<Contacts> getContactsByName(String cname);
}
