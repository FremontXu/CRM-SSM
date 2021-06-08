package com.fremont.workbench.controller;

import com.fremont.settings.domain.User;
import com.fremont.settings.service.UserService;
import com.fremont.utils.DateTimeUtil;
import com.fremont.utils.PrintJson;
import com.fremont.utils.ServiceFactory;
import com.fremont.utils.UUIDUtil;
import com.fremont.workbench.domain.Activity;
import com.fremont.workbench.domain.Clue;
import com.fremont.workbench.service.ActivityService;
import com.fremont.workbench.service.ClueService;
import com.fremont.workbench.service.impl.ActivityServiceImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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

    //--------------------------clue的增删改查-----------------------------

    /**
     * 添加线索
     * @param session s
     * @param clue boolean
     * @return
     */
    @RequestMapping("/saveClue.do")
    @ResponseBody
    public boolean save(HttpSession session, Clue clue){
        System.out.println("添加线索");

        String id = UUIDUtil.getUUID();
        String createBy = ((User)session.getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        clue.setId(id);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);

        boolean flag = clueService.save(clue);

        return flag;

    }

    /**
     * 分页
     * @param clue
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/pageList.do")
    @ResponseBody
    public Map<String,Object> pageList(Clue clue,Integer pageNo,Integer pageSize){
        System.out.println("分页查询线索");
        String fullname = clue.getFullname();
        String company = clue.getCompany();
        String phone = clue.getPhone();
        String source = clue.getSource();
        String owner = clue.getOwner();
        String mphone = clue.getMphone();
        String state = clue.getState();

        int skipCount = (pageNo-1) * pageSize;
        Map<String,Object> map = new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        Map<String,Object> cMap = clueService.pageList(map);
        return cMap;
    }

    //----------------------查询辅助信息---------------------

    /**
     * 获取用户信息列表
     * @return
     */
    @RequestMapping("/userList.do")
    @ResponseBody
    private List<User> getUserList() {
        System.out.println("获取用户信息列表");
        List<User> uList = userService.getUserList();
        return uList;
    }






}
