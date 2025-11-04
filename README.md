# EVE-NG 自动安装工具

自动化在 Ubuntu 系统上安装和配置 EVE-NG 网络仿真平台的工具。

## 简介

EVE-NG (Emulated Virtual Environment - Next Generation) 是一个强大的网络仿真平台，支持多种虚拟化技术。本项目提供自动化脚本，简化在 Ubuntu 系统上部署 EVE-NG 的过程。

## 系统要求

- Ubuntu 20.04 LTS 或更高版本
- 最低 4GB RAM (推荐 8GB+)
- 最低 40GB 磁盘空间
- Root 权限
- 稳定的网络连接

## 使用方法

```bash
sudo ./install-eve-ng.sh
```

## 功能特性

- 自动检测系统版本
- 配置 EVE-NG 官方软件源
- 安装所有必需依赖
- 自动配置网络和服务
- 完整的错误处理

## 安装后

安装完成后，通过浏览器访问：

```
http://<your-server-ip>
```

默认登录凭证：
- 用户名: `admin`
- 密码: `eve`

**重要**: 首次登录后请立即修改默认密码。

## 注意事项

- 建议在全新安装的 Ubuntu 系统上运行
- 安装完成后需要重启系统
- 确保系统已正确配置网络

## 许可证

MIT

## 贡献

欢迎提交 Issue 和 Pull Request。
