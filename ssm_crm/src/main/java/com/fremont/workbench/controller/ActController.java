package com.fremont.workbench.controller;

import com.fremont.settings.domain.User;
import com.fremont.settings.service.UserService;
import com.fremont.utils.DateTimeUtil;
import com.fremont.utils.UUIDUtil;
import com.fremont.vo.PaginationVo;
import com.fremont.workbench.domain.Activity;
import com.fremont.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
     * @param activity 活动查询条件
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


}
