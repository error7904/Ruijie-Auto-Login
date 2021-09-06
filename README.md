# Ruijie-Auto-Login
## 简介
本脚本基于 [链接](https://github.com/1203746884/RuijiePortalLoginShellScript) 修改制作，仅适用于广东科学职业技术学院珠海校区使用，广州校区自测。
广东科学职业技术学院 锐捷web 认证 shell

# 脚本工作原理

这个 Shell script 主要工作原理如下：

1. 向 [Captive Portal Server](https://en.wikipedia.org/wiki/Captive_portal) 发送 GET 请求，检查返回的 HTTP 状态码是否为 204：
   1. 如果为 204 则说明当前已经能正常联网，退出脚本，停止后续认证流程；
   2. 如果不是 204 则说明当前未进行锐捷认证（一般来说，在未认证的情况下请求任意页面，认证服务器都会返回一个 HTTP 302 或者 301 状态码，用于将你重定向到 ePortal 认证页面），则将 HTTP 重定向所转向的页面的 URL 作为认证页面 URL。
2. 构造进行锐捷 ePortal 认证所需的 HTTP 请求，并通过 curl 发送该请求。
3. 认证成功。

# 基本用法

```shell
./ruijie_student.sh username password
```

- username 参数为认证用户名。
- password 参数为认证密码。


# 局限性

如果多次认证失败（例如用户名或密码错误）或者多次重复刷新认证页面，则认证过程需要输入页面上显示的验证码。此脚本并没有识别验证码的功能。

如果你所在的学校需要在认证过程中输入验证码，则不适合使用这个 shell script 进行认证，需要使用 Python 等脚本语言实现验证码识别功能再进行认证。

#自动认证方式
可配合OpenWRT路由器接入认证，定时运行脚本即可。路由器需要curl的支持

安装curl
```shell
opkg update
opkg install curl
```

