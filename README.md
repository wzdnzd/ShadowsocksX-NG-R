# 使用须知
## 本工具是为了方便学习与工作，毕竟很多东西用Google搜比Baidu更靠谱，因此希望大家注意以下几点

- GFW=智商墙，请注意提高自己的智力，勿被境外利益集团洗脑 

- 墙外≠法外，请注意自己言行，本工具是为了学习而不是让你叛国

- 爱国富强的前提是自己要有独立思考问题的能力，而不是秀智力

- 下载地址：[releases](https://github.com/wzdnzd/ShadowsocksX-NG-R/releases)
  
## 软件删除方法
首先从应用程序中将.app文件放到废纸篓（随便什么方式）
然后打开命令行，依次输入：
```
rm -rf /Library/Application\ Support/ShadowsocksX-NG-R8
rm -rf ~/Library/Application\ Support/ShadowsocksX-NG-R8
rm -rf ~/Library/LaunchAgents/com.qiuyuzhou.shadowsocksX-NG.http.plist
rm -rf ~/Library/LaunchAgents/com.qiuyuzhou.shadowsocksX-NG.local.plist
rm -rf ~/.ShadowsocksX-NG
rm -rf ~/Library/Preferences/com.qiuyuzhou.ShadowsocksX-NG.plist
rm -rf ~/Library/Caches/com.qiuyuzhou.ShadowsocksX-NG
```
如果提示权限不足，请sudo后执行


# ShadowsocksX-NG-R

[![Build Status](https://travis-ci.org/shadowsocksr/ShadowsocksX-NG.svg?branches=develop)](https://travis-ci.org/shadowsocksr/ShadowsocksX-NG)
[![Swift](https://img.shields.io/badge/swift-5.2-orange.svg)](https://www.python.org/downloads/)
[![platform](https://img.shields.io/badge/platform-macOS-green.svg)](https://github.com/MobSF/Mobile-Security-Framework-MobSF/)
[![License](https://img.shields.io/:license-GPL--3.0--only-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)

[ShadowsocksX-NG](https://github.com/shadowsocks/ShadowsocksX-NG) with SSR support.

## Why?

It's hard to maintain the original implement. There are too many unused code in it. 
It also embed ss-local source. It's crazy to maintain depandences of ss-local. 
So it's hard to update ss-local version.

Now I just copy the ss-local from home brew. Run ss-local executable as a Launch Agent in background. 
Serve pac js file as a file url. So there are only some souce code related to GUI left. 
Then I rewrite the GUI code by swift.

## Requirements

### Running

- macOS 10.12 +

### Building

- Xcode 11.4.1+
- cocoapod 1.8.4+

## Fetures

- SSR features!
- Ability to check update from GitHub.
- White domain list & white IP list
- Use ss-local from shadowsocksr-libev 2.5.6
- Ability to update PAC by download GFW List from GitHub. (You can even customize your list)
- Ability to update ACL white list from GutHub. (You can even customize your list)
- Show QRCode for current server profile.
- Scan QRCode from screen.
- Import config.json to config all your servers (SSR-C# password protect not supported yet)
- Auto launch at login.
- User rules for PAC.
- Support for OTA is removed
- An advance preferences panel to configure:
  - Local socks5 listen address.
  - Local socks5 listen port.
  - Local socks5 timeout.
  - If enable UDP relay.
  - GFW List url.
  - ACL White List url.
  - ACL GFW list and proxy bach CHN list.
- Manual spesify network service profiles which would be configure the proxy.
- Could reorder shadowsocks profiles by drag & drop in servers preferences panel.
- Auto check update (unable to auto download)

## Different from orignal ShadowsocksX

Run ss-local as backgroud service through launchd, not in app process.
So after you quit the app, the ss-local maybe is still running. 

Add a manual mode which won't configure the system proxy settings. 
Then you could configure your apps to use socks5 proxy manual.

## Contributing

Contributions must be available on a separately named branch based on the latest version of the main branch develop.

ref: [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/)


## License

The project is released under the terms of GPLv3.

