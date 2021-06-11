package com.fremont.workbench.controller;

import com.fremont.settings.domain.User;
import com.fremont.settings.service.UserService;
import com.fremont.utils.DateTimeUtil;
import com.fremont.utils.PrintJson;
import com.fremont.utils.ServiceFactory;
import com.fremont.utils.UUIDUtil;
import com.fremont.workbench.domain.Activity;
import com.fremont.workbench.domain.Clue;
import com.fremont.workbench.domain.ClueRemark;
import com.fremont.workbench.domain.Tran;
import com.fremont.workbench.service.ActivityService;
import com.fremont.workbench.service.ClueService;
import com.fremont.workbench.service.impl.ActivityServiceImpl;
import com.fremont.workbench.service.impl.ClueServiceImpl;
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
 * @Date：2021/6/8-17:19
 * @Since:jdk1.8
 * @Description:TODO
 */
@Controller
@RequestMapping("/clue")
public class ClueController {

    @Resource
    private ClueService clueService;
    @Resource
    private UserService userService;
    @Resource
    private ActivityService activityService;

    //--------------------------clue的增删改查-----------------------------

    /**
     * 添加线索
     *
     * @param session s
     * @param clue    boolean
     * @return
     */
    @RequestMapping("/saveClue.do")
    @ResponseBody
    public boolean save(HttpSession session, Clue clue) {
        System.out.println("添加线索");

        String id = UUIDUtil.getUUID();
        String createBy = ((User) session.getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        clue.setId(id);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);

        boolean flag = clueService.save(clue);

        return flag;

    }

    /**
     * 分页
     *
     * @param clue
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/pageList.do")
    @ResponseBody
    public Map<String, Object> pageList(Clue clue, Integer pageNo, Integer pageSize) {
        System.out.println("分页查询线索");
        String fullname = clue.getFullname();
        String company = clue.getCompany();
        String phone = clue.getPhone();
        String source = clue.getSource();
        String owner = clue.getOwner();
        String mphone = clue.getMphone();
        String state = clue.getState();

        int skipCount = (pageNo - 1) * pageSize;
        Map<String, Object> map = new HashMap<>();
        map.put("skipCount", skipCount);
        map.put("pageSize", pageSize);
        map.put("fullname", fullname);
        map.put("company", company);
        map.put("phone", phone);
        map.put("source", source);
        map.put("owner", owner);
        map.put("mphone", mphone);
        map.put("state", state);
        Map<String, Object> cMap = clueService.pageList(map);
        return cMap;
    }

    /**
     * 删除 多选
     *
     * @param ids id
     * @return boolean
     */
    @RequestMapping("/delClue.do")
    @ResponseBody
    public boolean deleteclue(@RequestParam(value = "id") String[] ids) {
        boolean flag = true;
        System.out.println("删除线索：" + Arrays.toString(ids));
        int count = ids.length;
        int result = clueService.delClue(ids);
        if (count != result) {
            flag = false;
        }
        return flag;
    }

    /**
     * 修改
     *
     * @param session session
     * @param clue    clue
     * @return boolean
     */
    @RequestMapping("/updateClue.do")
    @ResponseBody
    public boolean updateClue(HttpSession session, Clue clue) {
        boolean flag = true;
        String editBy = ((User) session.getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        int count = clueService.updateClue(clue);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    /**
     * 获取修改的单个记录
     *
     * @param id id
     * @return clue
     */
    @RequestMapping("/getClue.do")
    @ResponseBody
    public Clue getClueById(String id) {
        return clueService.getClueById(id);
    }

    /**
     * 获取细节信息
     *
     * @param id id
     * @return mv
     */
    @RequestMapping("/detailClue.do")
    public ModelAndView getDetail(String id) {
        System.out.println("转到线索细节");
        ModelAndView mv = new ModelAndView();
        Clue clue = clueService.getDetail(id);
        mv.addObject(clue);
        mv.setViewName("forward:/workbench/clue/detail.jsp");
        return mv;
    }

    //----------------------remark的增删改查-------------------

    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public boolean saveClueRemark(HttpSession session, ClueRemark clueRemark) {
        System.out.println("保存备注");

        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) session.getAttribute("user")).getName();
        String editFlag = "0";

        clueRemark.setId(id);
        clueRemark.setCreateBy(createBy);
        clueRemark.setCreateTime(createTime);
        clueRemark.setEditFlag(editFlag);

        return clueService.saveRemark(clueRemark);
    }

    @RequestMapping("/updateRemark.do")
    @ResponseBody
    public boolean updateClueRemark(HttpSession session, ClueRemark clueRemark) {
        System.out.println("修改备注");

        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) session.getAttribute("user")).getName();
        String editFlag = "1";

        clueRemark.setEditTime(editTime);
        clueRemark.setEditBy(editBy);
        clueRemark.setEditFlag(editFlag);

        return clueService.updateRemark(clueRemark);
    }

    @RequestMapping("/delRemark.do")
    @ResponseBody
    public boolean delClueRemark(String id) {
        System.out.println("删除备注：" + id);
        return clueService.delRemark(id);
    }

    @RequestMapping("/getClueRemark.do")
    @ResponseBody
    public List<ClueRemark> getListByClueId(String clueId){
        System.out.println("备注列表");
        return clueService.getListByClueId(clueId);
    }

    //----------------------查询辅助信息---------------------

    /**
     * 获取用户信息列表
     *
     * @return 用户信息
     */
    @RequestMapping("/userList.do")
    @ResponseBody
    private List<User> getUserList() {
        System.out.println("获取用户信息列表");
        return userService.getUserList();
    }

    /**
     * 线索id查询关联的市场活动
     *
     * @param req  请求
     * @param resp 响应
     */
    @RequestMapping("/getActivityListByClueId.do")
    @ResponseBody
    private List<Activity> getActivityListByClueId(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("根据线索id查询关联的市场活动列表");
        String clueId = req.getParameter("clueId");

        return activityService.getActivityListByClueId(clueId);
    }

    /**
     * 根据名称模糊查询未关联指定线索的活动列表
     *
     * @param req  请求
     * @param resp 响应
     */
    @RequestMapping("/getActivityNotBund.do")
    private void getActivityListByNameAndNotByClueId(HttpServletRequest req, HttpServletResponse resp) {

        System.out.println("根据名称模糊查询未关联指定线索的活动列表");

        String aname = req.getParameter("aname");
        String clueId = req.getParameter("clueId");

        Map<String, String> map = new HashMap<String, String>();
        map.put("aname", aname);
        map.put("clueId", clueId);

        List<Activity> aList = activityService.getActivityListByNameAndNotByClueId(map);

        PrintJson.printJsonObj(resp, aList);
    }

    @RequestMapping("/getActivityListByName.do")
    private void getActivityListByName(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("根据名称模糊查询市场活动列表");
        String aname = req.getParameter("aname");

        List<Activity> aList = activityService.getActivityListByName(aname);

        PrintJson.printJsonObj(resp, aList);
    }

    //----------------------业务操作----------------------------

    /**
     * 建立关联 多选
     *
     * @param req 请求
     * @param resp 响应
     */
    @RequestMapping("/bund.do")
    @ResponseBody
    private boolean bund(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("关联活动与线索");
        String cid = req.getParameter("cid");
        String[] aids = req.getParameterValues("aid");

        return clueService.bund(cid, aids);
    }

    /**
     * 解除关联
     *
     * @param req  请求
     * @param resp 响应
     */
    @RequestMapping("/unbund.do")
    @ResponseBody
    private boolean unbund(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println("解除关联");
        String id = req.getParameter("id");
        return clueService.unbund(id);
    }

    /**
     * 转换业务
     *
     * @param req  请求
     * @param resp 响应
     */
    @RequestMapping("/convert.do")
    public void convert(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        System.out.println("执行线索转换操作");

        // 接收是否需要创建交易的标记
        String flag = req.getParameter("flag");
        String clueId = req.getParameter("clueId");
        String createBy = ((User) req.getSession().getAttribute("user")).getName();
        Tran t = null;

        if ("a".equals(flag)) {
            // 接收交易表单中的参数
            String money = req.getParameter("money");
            String name = req.getParameter("name");
            String expectedDate = req.getParameter("expectedDate");
            String stage = req.getParameter("stage");
            String activityId = req.getParameter("activityId");
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();

            t = new Tran();
            t.setId(id);
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setCreateTime(createTime);
            t.setCreateBy(createBy);
        }

        boolean f = clueService.convert(clueId, t, createBy);
        // 执行成功直接重定向
        if (f) resp.sendRedirect(req.getContextPath() + "/workbench/clue/index.jsp");
    }

}
