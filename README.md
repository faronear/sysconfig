远程服务器使用策略：
* 统一使用 debian 系统。
* 禁止 root 用户远程登录，另建 adot (admin+root) 用户用于远程登录。
* 软件、配置安装在 /faronear 目录下，尽量保持与 git 仓库的路径一致，例如 /faronear/tic/wallet/dist/
* /faronear 允许 adot 访问，但必须把其中机密文件的权限设置到最小。
* 用 adot 账号远程登录后，su 后启动软件。