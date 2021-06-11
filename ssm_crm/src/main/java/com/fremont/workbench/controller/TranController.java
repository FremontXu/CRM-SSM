package com.fremont.workbench.controller;

import com.fremont.settings.domain.User;
import com.fremont.settings.service.UserService;
import com.fremont.utils.DateTimeUtil;
import com.fremont.utils.PrintJson;
import com.fremont.utils.ServiceFactory;
import com.fremont.utils.UUIDUtil;
import com.fremont.workbench.domain.Activity;
import com.fremont.workbench.domain.Contacts;
import com.fremont.workbench.domain.Tran;
import com.fremont.workbench.domain.TranHistory;
import com.fremont.workbench.service.ActivityService;
import com.fremont.workbench.service.ContactsService;
import com.fremont.workbench.service.CustomerService;
import com.fremont.workbench.service.TranService;
import com.fremont.workbench.service.impl.TranServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/10-9:03
 * @Since:jdk1.8
 * @Description:TODO
 */
@Controller
@RequestMapping("/tran")
public class TranController {

    @Resource
    private TranService tranService;
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;
    @Resource
    private ContactsService contactsService;
    @Resource
    private CustomerService customerService;


    //------------------------------------tran的增删改查-----------------------------------

    /**
     * 进入添加页面
     *
     * @return 0
     */
    @RequestMapping("add.do")
    public ModelAndView add() {
        System.out.println("跳转到交易添加页");
        ModelAndView mv = new ModelAndView();

        List<User> uList = userService.getUserList();
        mv.addObject("uList", uList);
        mv.setViewName("forward:/workbench/transaction/save.jsp");
        return mv;
    }

    /**
     * 保存
     *
     * @param request  r
     * @param response r
     * @param tran     t
     * @throws IOException e
     */
    @RequestMapping("saveTran.do")
    public void saveTran(HttpServletRequest request, HttpServletResponse response, Tran tran) throws IOException {
        System.out.println("添加新交易");

        String id = UUIDUtil.getUUID();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();

        tran.setId(id);
        tran.setCreateBy(createBy);
        tran.setCreateTime(createTime);

        // 此处的customerId储存的是名字，还没有转换为id
        boolean flag = tranService.save(tran);
        if (flag) {
            // 如果添加交易成功,跳转到列表页
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        } else {
            System.out.println("添加交易失败");
        }
    }

    /**
     * 删除 多选
     *
     * @param ids ids
     * @return bool
     */
    @RequestMapping("delTran.do")
    @ResponseBody
    public boolean delTran(@RequestParam(value = "id") String[] ids) {
        boolean flag = true;
        System.out.println("删除线索：" + Arrays.toString(ids));
        int count = ids.length;
        int result = tranService.delTran(ids);
        if (count != result) flag = false;
        return flag;
    }

//    /**
//     * 转到编辑页面
//     *
//     * @return
//     */
//    @RequestMapping("edit.do")
//    public ModelAndView edit(String id) {
//        System.out.println("跳转到交易修改页");
//        ModelAndView mv = new ModelAndView();
//
//
//        mv.setViewName("forward:/workbench/transaction/edit.jsp");
//        return mv;
//    }

//    /**
//     * 修改交易
//     *
//     * @param session s
//     * @param tran    t
//     * @return b
//     */
//    @RequestMapping("/updateTran.do")
//    @ResponseBody
//    public boolean updateTran(HttpSession session, Tran tran) {
//        System.out.println("修改交易");
//
//        String editBy = ((User) session.getAttribute("user")).getName();
//        String editTime = DateTimeUtil.getSysTime();
//
//        tran.setEditBy(editBy);
//        tran.setEditTime(editTime);
//
//        return tranService.update(tran);
//    }

    /**
     * 改变阶段状态
     *
     * @param req  r
     * @param resp r
     * @return o
     */
    @RequestMapping("/changeStage.do")
    @ResponseBody
    public Map<String, Object> changeState(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("执行改变阶段的操作");

        String id = req.getParameter("id");
        String stage = req.getParameter("stage");
        String money = req.getParameter("money");
        String expectedDate = req.getParameter("expectedDate");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) req.getSession().getAttribute("user")).getName();

        Tran t = new Tran();
        t.setId(id);
        t.setStage(stage);
        t.setMoney(money);
        t.setExpectedDate(expectedDate);
        t.setEditBy(editBy);
        t.setEditTime(editTime);

        boolean flag = tranService.changeStage(t);

        Map<String, String> pMap = (Map<String, String>) req.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(stage);

        t.setPossibility(possibility);

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("success", flag);
        map.put("t", t);

        return map;
    }

    @RequestMapping("/getChars.do")
    @ResponseBody
    public Map<String, Object> getChars(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("取得交易阶段数量统计图标的数据");

        /**
         * 业务层为我们返回
         *  total
         *  dataList
         *
         *  通过map打包以上两项进行返回
         */
        return tranService.getChars();
    }

    /**
     * 分页查询
     *
     * @param tran     t
     * @param pageNo   p
     * @param pageSize p
     * @return map
     */
    @RequestMapping("/pageList.do")
    @ResponseBody
    public Map<String, Object> pageList(Tran tran, Integer pageNo, Integer pageSize) {
        System.out.println("分页查询线索");

        String owner = tran.getOwner();
        String name = tran.getName();
        String state = tran.getStage();
        String customerId = tran.getCustomerId();
        String stage = tran.getStage();
        String type = tran.getType();
        String source = tran.getSource();
        String contactsId = tran.getContactsId();

        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("owner", owner);
        map.put("name", name);
        map.put("state", state);
        map.put("customer", customerId);
        map.put("stage", stage);
        map.put("type", type);
        map.put("source", source);
        map.put("contact", contactsId);

        Map<String, Object> tMap = tranService.pageList(map);
        return tMap;
    }

    /**
     * 获取细节信息
     *
     * @param req r
     * @param id  id
     * @return mv
     */
    @RequestMapping("/detailTran.do")
    public ModelAndView getDetail(HttpServletRequest req, String id) {
        System.out.println("跳转到交易细节页");
        ModelAndView mv = new ModelAndView();

        Tran t = tranService.detail(id);

        // 处理可能性
        String stage = t.getStage();
        Map<String, String> pMap = (Map<String, String>) req.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(stage);
        t.setPossibility(possibility);


        mv.addObject("t", t);
        mv.setViewName("forward:/workbench/transaction/detail.jsp");
        return mv;
    }


    //---------------------------------查询辅助信息--------------------------------

    @RequestMapping("/getActivity.do")
    @ResponseBody
    public List<Activity> getActByName(String aname) {
        System.out.println("动态模糊查询活动");
        return activityService.getActivityListByName(aname);
    }

    @RequestMapping("/getContact.do")
    @ResponseBody
    public List<Contacts> getContacts(String cname) {
        System.out.println("动态模糊查询联系人");
        return contactsService.getContactsByName(cname);
    }

    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name) {
        System.out.println("取得客户名称列表(按照客户的名称进行模糊查询)");
        return customerService.getCustomerName(name);
    }

    @RequestMapping("/getHistoryListByTranId.do")
    @ResponseBody
    public List<TranHistory> getTranHistory(HttpServletRequest req, String tranId) {

        System.out.println("根据交易id取得相应的历史列表");

        List<TranHistory> ths = tranService.getHistoryListByTranId(tranId);

        // 阶段和可能性之间的对应关系
        Map<String, String> pMap = (Map<String, String>) req.getServletContext().getAttribute("pMap");

        // 将交易历史列表遍历
        for (TranHistory th : ths) {

            // 根据每条交易历史,取出每一个阶段
            String stage = th.getStage();
            String possibility = pMap.get(stage);
            th.setPossibility(possibility);

        }
        return ths;
    }

    //--------------------------------remark的增删改查--------------------------------

}
