package com.peaceful.auth.sdk.spring;

import com.peaceful.auth.sdk.util.AppConfigsImpl;
import com.peaceful.auth.sdk.util.Util;
import org.apache.commons.lang3.StringUtils;

/**
 * Date 14/11/15.
 * Author WangJun
 * Email wangjuntytl@163.com
 */
public abstract class AuthContext {

    private static String auth_context_impl_class = null;


    public abstract String getCurrentUser();

    protected static AuthContext init() {
        auth_context_impl_class = AppConfigsImpl.getMyAppConfigs("auth.properties").getString("auth.context.impl.class");
        AuthContext authContext = null;
        if (StringUtils.isEmpty(auth_context_impl_class)) {
            throw new InitAuthContextException("init auth context error,not find out auth_context_impl_class key in auth.properties");
        } else {
            try {
                Class<AuthContext> sessionClass = (Class<AuthContext>) Class.forName(auth_context_impl_class);
                Class clazz = sessionClass.getSuperclass();
                Util.report(clazz.getName());
                if (clazz != null && clazz.equals(AuthContext.class)) {
                    authContext = sessionClass.newInstance();
                    return authContext;
                }
                if (authContext == null) {
                    throw new InitAuthContextException(auth_context_impl_class.concat(" not implements AuthContext interface "));
                }
            } catch (ClassNotFoundException e) {
                throw new InitAuthContextException(("not find class ->").concat(auth_context_impl_class));
            } catch (InstantiationException e) {
                throw new InitAuthContextException("can't instantiation Class ".concat(auth_context_impl_class));
            } catch (IllegalAccessException e) {
                throw new InitAuthContextException("can't access Class ".concat(auth_context_impl_class));
            }
        }
        return authContext;
    }

    private static class SingletonHolder {
        private static AuthContext authContext = init();

    }

    public static AuthContext getAuthContext() {
        return SingletonHolder.authContext;
    }


}


