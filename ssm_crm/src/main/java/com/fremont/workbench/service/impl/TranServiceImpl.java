package com.fremont.workbench.service.impl;

import com.fremont.utils.DateTimeUtil;
import com.fremont.utils.UUIDUtil;
import com.fremont.workbench.dao.CustomerDao;
import com.fremont.workbench.dao.TranDao;
import com.fremont.workbench.dao.TranHistoryDao;
import com.fremont.workbench.domain.Customer;
import com.fremont.workbench.domain.Tran;
import com.fremont.workbench.domain.TranHistory;
import com.fremont.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/10-9:02
 * @Since:jdk1.8
 * @Description:TODO
 */
@Service
public class TranServiceImpl implements TranService {

    @Autowired
    private TranDao tranDao;
    @Autowired
    private TranHistoryDao tranHistoryDao;
    @Autowired
    private CustomerDao customerDao;

    @Override
    public boolean save(Tran tran) {
        //交易添加业务
        boolean flag = true;
        String customerName = tran.getCustomerId();
        //判断customerName,根据客户名称在客户表进行精确查询
        Customer cus = customerDao.getCustomerByName(customerName);

        if (cus == null) {
            //如果没有这个客户,则在客户表新建一条客户信息,然后将新建的客户的id取出,封装到t对象中
            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setName(customerName);
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setCreateBy(tran.getCreateBy());
            cus.setContactSummary(tran.getContactSummary());
            cus.setNextContactTime(tran.getNextContactTime());
            cus.setOwner(tran.getOwner());
            // 添加客户
            int count1 = customerDao.save(cus);
            if (count1 != 1) {
                flag = false;
            }
        }
        // 通过以上对于客户的处理,不论是查询出来已有的客户,还是以前没有我们新增的客户,总之客户已经有了,客户的id就有了
        // 将客户的id封装到t对象中
        tran.setCustomerId(cus.getId());

        int count2 = tranDao.save(tran);
        if (count2 != 1) {
            flag = false;
        }

        // 添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(tran.getId());
        th.setStage(tran.getStage());
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(tran.getCreateBy());
        int count3 = tranHistoryDao.save(th);
        if (count3 != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public int delTran(String[] ids) {
        int result = 0;
        for (String id : ids) {
            result += tranDao.delete(id);
        }
        return result;
    }

    @Override
    public boolean update(Tran tran) {
        return tranDao.changeStage(tran) > 0;
    }

    @Override
    public Map<String, Object> pageList(Map<String, Object> map) {
        Integer total = tranDao.getTotal();
        List<Tran> tList = tranDao.pageList(map);

        Map<String, Object> map1 = new HashMap<>();
        map1.put("total", total);
        map1.put("tList", tList);

        return map1;
    }

    @Override
    public Tran detail(String id) {
        return tranDao.detail(id);
    }

    @Override
    public List<TranHistory> getHistoryListByTranId(String tranId) {
        return tranHistoryDao.getHistoryListByTranId(tranId);
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag = true;
        // 改变交易阶段
        int count1 = tranDao.changeStage(t);
        if(count1 != 1){
            flag = false;
        }
        // 交易阶段改变后,生成一条交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setExpectedDate(t.getExpectedDate());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        // 添加交易历史
        int count2 = tranHistoryDao.save(th);
        if(count2 != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getChars() {
        // 取得total
        int total = tranDao.getTotal();

        // 取得dataList
        List<Map<String,Object>> dataList = tranDao.getChars();

        // 将total和dataList保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("total",total);
        map.put("dataList",dataList);

        // 返回map
        return map;
    }
}
