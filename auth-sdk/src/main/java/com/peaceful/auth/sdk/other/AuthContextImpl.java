package com.peaceful.auth.sdk.other;

import com.peaceful.auth.sdk.spring.AuthContext;
import com.peaceful.common.util.Http;

/**
 * 为了可以让权限中心知道当前你系统的登录用户，需要实现AuthContext
 * <p/>
 */
public class AuthContextImpl extends AuthContext {
    @Override
    public String getCurrentUser() {
        return (String) Http.getRequest().getSession().getAttribute(Constant.CURRENT_USER);
    }
}
