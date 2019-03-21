<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="author" content="WangJun">
    <title>
        手册
    </title>
    <link rel="shortcut icon" type="image/vnd.microsoft.icon" href='/image/icon.png'>
    <link href="/css/bootstrap3.css" rel="stylesheet">
    <link href="/css/docs.css" rel="stylesheet">
    <link href="/css/common.css" rel="stylesheet">

    <script src="/js/jquery.min.js"></script>
    <script src="/js/bootstrap.js"></script>
</head>
<body>
<div class="bs-docs-container container">
    <div class="bs-callout bs-callout-warning" id="jquery-required" style="margin-top: -30px;">
        <h4 class="page-header">关于</h4><br>

        <p>权限中心系统是根据大街基础平台部开发的一套统一控制系统权限的API改进而来，它的基本功能如下：</p>

        <p class="text-center">
            <img src="/image/auth.png">
        </p>
        <h4 class="page-header" id="config">使用与配置</h4><br>

        <p>
            一、首先到需要权限中心注册系统，如下,填写系统相关的基本信息，然后系统会为你的系统分配一个唯一标识，APP key及secret。在客户端配置的时候需要用到这三个值。
        </p>

        <p class="text-center">
            <img src="/image/registSystem.jpg" width="876">
        </p>
        <p>
            二、引入SDK jar包
        </p>
        <p class="text-center">

            <code>
                <pre>
1. 打包
    git clone https://github.com/linyimin-bupt/peaceful-basic-platform.git
    cd ./peaceful-basic-platform
    bash ./build.sh
    cd ..
    rm -rf peaceful-basic-platform
    git clone https://github.com/linyimin-bupt/authmange.git
    cd authmanage/auth-sdk
    mvn -f pom.xml install -Dmaven.test.skip=true
    cd ..
    cd auth-spring
    mvn -f pom.xml install -Dmaven.test.skip=true
    cd ..
    rm -rf authmanage

2. 引入jar包

    &lt;dependency&gt;
        &lt;groupId&gt;com.peaceful&lt;/groupId&gt;
        &lt;artifactId&gt;nuggets-auth-sdk&lt;/artifactId&gt;
        &lt;version&gt;1.0-SNAPSHOT&lt;/version&gt;
    &lt;/dependency&gt;

    &lt;dependency&gt;
        &lt;groupId&gt;com.peaceful&lt;/groupId&gt;
        &lt;artifactId&gt;peaceful-common-utils&lt;/artifactId&gt;
        &lt;version&gt;1.0-SNAPSHOT&lt;/version&gt;
    &lt;/dependency&gt;

                </pre>
            </code>
        </p>
        <p>
            三、添加配置文件：在项目的classpath根路径引入配置文件：auth.properties
        </p>
        <p class="text-center">
            <code>
                <pre>
    auth.app.id=1
    auth.appkey=356c2e62887a17d67af5aa489583e845
    auth.secret=3b30c75b9f3ad2c1a04233a90803cb8d
    #权限中心地址
    #sdk包与权限中心建立连接，需要知道权限中心的位置
    auth.service.address=http://127.0.0.1:8888
    #user info 缓存时间
    #第一次通过getUser()获取用户权限信息时，会把配置信息缓存在客户端的服务器，之后会在缓存中获取
    #如果缓存失效，会再次请求权限中心
    auth.user.session.out.time=2
    auth.client.cache.valid.time=1
    #system info 缓存时间 ，目的同上
    auth.system.session.out.time=300
    auth.context.impl.class=com.peaceful.auth.sdk.other.AuthContextImpl
                </pre>
            </code>
        </p>
        <p>
            四、引入Spring bootl拦截器， 添加FilterConfig和InterceptorConfig两个文件
        </p>
        <p class="text-center">
            <code>
                <pre>
import com.peaceful.common.util.HttpContextFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

@Configuration
public class FilterConfig {
    @Bean
    public FilterRegistrationBean httpContextFilter(){
        //创建 过滤器注册bean
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();

        HttpContextFilter filter = new HttpContextFilter();

        registrationBean.setFilter(filter);

        List urls = new ArrayList();
        urls.add("/*");   //给所有请求加过滤器
        //设置 有效url
        registrationBean.setUrlPatterns(urls);

        return registrationBean;
    }
}

import com.peaceful.auth.sdk.spring.AuthInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
public class InterceptorConfig extends WebMvcConfigurerAdapter {
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new AuthInterceptor());
    }
}

                </pre>
            </code>
        </p>
        <p>

            五、配置已经完成了，你可以在权限中心系统配置你的基本权限设置，然后通过提供的API获得你想要的数据：例如加入权限
        </p>

        <p class="text-center">
            <img src="/image/authConfig.jpg" width="876">
        </p>
        <br><br>
        <p>
            六、使用SDK包进行相关权限管理
        </p>
        <p class="text-center">
            <code>
                <pre>
// 角色为“管理员”的用户才能访问
@AUTH.Role("管理员")
@RequestMapping(value = "/item", method = RequestMethod.GET)
public String addMeta() {
    return "Hello World";
}

// 要求登录，才能访问
@AUTH.RequireLogin
@AUTH.Role("管理员")
@RequestMapping(value = "/item", method = RequestMethod.GET)
public String addMeta() {
    return "Hello World";
}

// 或者使用相关接口进行相关扩展
AuthService authService = AuthServiceImpl.getAuthService()
// getSystem() 获得客户端在权限中心注册的所有配置信息
// getUser(String email) 获得客指定用户的所有配置信息
                </pre>
            </code>
        </p>
    </div>
</div>
</body>
</html>