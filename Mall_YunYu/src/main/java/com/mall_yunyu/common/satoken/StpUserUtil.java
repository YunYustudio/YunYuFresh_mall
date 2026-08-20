package com.mall_yunyu.common.satoken;

import cn.dev33.satoken.stp.StpLogic;

public class StpUserUtil {

    public static final String TYPE = "user";
    public static final StpLogic stpLogic = new StpLogic(TYPE);

    public static void login(Object id) {
        stpLogic.login(id);
    }

    public static void logout() {
        stpLogic.logout();
    }

    public static boolean isLogin() {
        return stpLogic.isLogin();
    }

    public static void checkLogin() {
        stpLogic.checkLogin();
    }

    public static Object getLoginId() {
        return stpLogic.getLoginId();
    }

    public static long getLoginIdAsLong() {
        return stpLogic.getLoginIdAsLong();
    }

    public static String getTokenValue() {
        return stpLogic.getTokenValue();
    }
}
