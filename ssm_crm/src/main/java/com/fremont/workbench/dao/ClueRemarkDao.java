package com.fremont.workbench.dao;


import com.fremont.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getListByClueId(String clueId);

    int delRemark(String id);

    int saveRemark(ClueRemark clueRemark);

    int updateRemark(ClueRemark clueRemark);
}
