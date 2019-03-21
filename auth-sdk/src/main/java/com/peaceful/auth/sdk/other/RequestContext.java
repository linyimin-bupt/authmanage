package com.peaceful.auth.sdk.other;

public class RequestContext {

    private static ThreadLocal<String> currentUser = new ThreadLocal<String>();

    public static void setCurrentUser(String username){
        currentUser.set(username);
    }

    public static String getCurrentUser(){
        return currentUser.get();
    }
}
