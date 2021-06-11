package com.fremont.workbench.controller;

import com.fremont.settings.domain.User;
import com.fremont.settings.service.UserService;
import com.fremont.utils.DateTimeUtil;
import com.fremont.utils.UUIDUtil;
import com.fremont.vo.PaginationVo;
import com.fremont.workbench.domain.Activity;
import com.fremont.workbench.domain.ActivityRemark;
import com.fremont.workbench.service.ActivityRemarkService;
import com.fremont.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/7-14:56
 * @Since:jdk1.8
 * @Description:TODO
 */
@Controller
@RequestMapping("/act")
public class ActController {

    @Resource
    private ActivityService activityService;
    @Resource
    private UserService userService;
    @Resource
    private ActivityRemarkService activityRemarkService;

    //--------------------------------Activity的增删改查-----------------------------------

    /**
     * 获取用户信息
     *
     * @return 返回ajax
     */
    @RequestMapping("/userList.do")
    @ResponseBody
    public Object getUserList() {
        System.out.println("查询用户信息");

        List<User> users = userService.getUserList();

        System.out.println("用户数量：" + users.size());
        return users;
    }

    /**
     * 保存活动
     *
     * @param activity 活动
     * @param request  请求
     * @return 返回
     */
    @RequestMapping("/saveAct.do")
    @ResponseBody
    public Boolean saveAct(Activity activity, HttpServletRequest request) {
        System.out.println("执行添加活动");
        //设置其他信息
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) request.getSession().getAttribute("user")).getName();

        activity.setId(id);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);

        int i = activityService.saveAct(activity);
        System.out.println("已更新：" + i);
        return i > 0;
    }

    /**
     * 删除
     *
     * @param ids 数组存放id
     * @return j
     */
    @RequestMapping("/delAct.do")
    @ResponseBody
    public Boolean delAct(@RequestParam(value = "id") String[] ids) {
        System.out.println("删除：" + Arrays.toString(ids));
        int i = activityService.delAct(ids);
        return i > 0;
    }

    /**
     * 获取修改信息
     *
     * @param id id
     * @return map信息
     */
    @RequestMapping("/getUserListAndActivity.do")
    @ResponseBody
    public Object getEdit(String id) {
        System.out.println("查询修改操作");
        /*
         * controller调用service的方法,返回值是什么
         * 前端要什么,就要从service层取什么
         * uList
         * a
         * 信息复用率不高,选择使用map
         */
        Map<String, Object> map = new HashMap<>();
        //uList
        List<User> userList = userService.getUserList();
        map.put("uList", userList);
        //activity
        Activity activity = activityService.getActById(id);
        map.put("a", activity);

        return map;
    }

    /**
     * 保存 修改
     *
     * @param session 获取当前登录用户
     * @param a       传递的参数
     * @return 结果boolean
     */
    @RequestMapping("/updateAct.do")
    @ResponseBody
    public Boolean upAct(HttpSession session, Activity a) {
        System.out.println("保存修改");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) session.getAttribute("user")).getName();
        a.setEditTime(editTime);
        a.setEditBy(editBy);
        return activityService.updateAct(a);
    }

    /**
     * @param activity 活动查询条件分页
     * @param pageSize 页面大小
     * @param pageNo   页数
     * @return 列表
     */
    @RequestMapping("/pageList.do")
    @ResponseBody
    public Object getPage(Activity activity, Integer pageSize, Integer pageNo) {
        System.out.println("执行分页查询活动");

        String name = activity.getName();
        String owner = activity.getOwner();
        String startDate = activity.getStartDate();
        String endDate = activity.getEndDate();
        // 计算出略过的记录数
        int skipCount = (pageNo - 1) * pageSize;

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);

        map.put("pageSize", pageSize);
        map.put("skipCount", skipCount);

        PaginationVo<Activity> vo;
        vo = activityService.pageList(map);

        return vo;
    }

    /**
     * 获取细节信息
     *
     * @param id id
     * @return mv
     */
    @RequestMapping("/detailAct.do")
    public ModelAndView getDetail(String id) {
        System.out.println("转到活动细节");
        ModelAndView mv = new ModelAndView();
        Activity activity = activityService.getActById(id);
        mv.addObject(activity);
        mv.setViewName("forward:/workbench/activity/detail.jsp");
        return mv;
    }

    //--------------------------------ActivityRemark的增删改查-----------------------------------

    /**
     * 添加备注
     *
     * @param session 获取登录信息
     * @param ar      参数
     * @return map
     */
    @RequestMapping("/saveRemark.do")
    @ResponseBody
    public Object saveActRemark(HttpSession session, ActivityRemark ar) {
        System.out.println("保存备注");

        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User) session.getAttribute("user")).getName();
        String editFlag = "0";

        ar.setId(id);
        ar.setCreateBy(createBy);
        ar.setCreateTime(createTime);
        ar.setEditFlag(editFlag);

        boolean flag = activityRemarkService.saveRemark(ar);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("ar", ar);
        return map;
    }

    /**
     * 修改备注
     *
     * @param session 会话
     * @param ar      参数
     * @return map
     */
    @RequestMapping("/updateRemark.do")
    @ResponseBody
    public Object updateRemark(HttpSession session, ActivityRemark ar) {
        System.out.println("修改备注");

        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User) session.getAttribute("user")).getName();
        String editFlag = "1";

        ar.setEditTime(editTime);
        ar.setEditBy(editBy);
        ar.setEditFlag(editFlag);

        boolean flag = activityRemarkService.updateRemark(ar);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        map.put("ar", ar);

        return map;
    }

    /**
     * 删除备注
     *
     * @param id id
     * @return boolean
     */
    @RequestMapping("/deleteRemarkById.do")
    @ResponseBody
    public Boolean delRemark(String id) {
        System.out.println("删除备注：" + id);
        int i = activityRemarkService.delRemark(id);
        return i > 0;
    }

    /**
     * 获取备注列表
     *
     * @param activityId 活动ID
     * @return 列表
     */
    @RequestMapping("/getRemarkListByAid.do")
    @ResponseBody
    private List<ActivityRemark> getRemarkListByAid(String activityId) {
        System.out.println("备注列表");
        return activityRemarkService.getRemarkListByAid(activityId);
    }

}
