package com.fremont.workbench.service;

import com.fremont.workbench.domain.Tran;
import com.fremont.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/10-9:02
 * @Since:jdk1.8
 * @Description:TODO
 */
public interface TranService {

    boolean save(Tran tran);

    int delTran(String[] ids);

    boolean update(Tran tran);

    Map<String,Object> pageList(Map<String,Object> map);

    Tran detail(String id);

    List<TranHistory> getHistoryListByTranId(String tranId);

    boolean changeStage(Tran t);

    Map<String,Object> getChars();
}
