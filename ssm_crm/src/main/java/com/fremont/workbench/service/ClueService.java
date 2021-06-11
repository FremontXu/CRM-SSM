package com.fremont.workbench.service;

import com.fremont.workbench.domain.Clue;
import com.fremont.workbench.domain.ClueRemark;
import com.fremont.workbench.domain.Tran;

import java.util.List;
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

    int delClue(String[] ids);

    int updateClue(Clue clue);

    Clue getClueById(String id);

    boolean bund(String cid, String[] aids);

    boolean unbund(String id);

    Clue getDetail(String id);

    boolean convert(String clueId, Tran t, String createBy);

    boolean saveRemark(ClueRemark clueRemark);

    boolean updateRemark(ClueRemark clueRemark);

    boolean delRemark(String id);

    List<ClueRemark> getListByClueId(String clueId);
}
