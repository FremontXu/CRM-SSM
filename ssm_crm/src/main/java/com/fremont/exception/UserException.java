package com.fremont.exception;

/**
 * @Author：xuhongfei
 * @Version：1.0
 * @Date：2021/6/6-19:44
 * @Since:jdk1.8
 * @Description:TODO
 */
public class UserException extends Exception {

    private String msg;

    public UserException() {
    }

    public UserException(String message) {
        this.msg = message;
    }
}
