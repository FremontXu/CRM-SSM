package com.fremont.exception;


/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/6-16:31
 * @Since:jdk1.8
 * @Description:TODO
 */
public class LoginException extends UserException {

    private String msg;

    public LoginException() {
        super();
    }

    public LoginException(String message) {
        this.msg = message;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
