# https://blog.csdn.net/fuxin123123/article/details/122288466
# Mac TimeMachine 全速备份
# 如果你的 Mac 是第一次备份，一般都很慢，可以调节参数的方式将其调节为全速进行备份，记得备份完后将其调整回来，否则可能会导致你的电脑在正常使用的时候由于同时在备份导致卡顿。
# 打开终端，执行如下命令开启全速备份：
# 测试发现，对通过 Finder 备份 iPhone 也有效
sudo sysctl debug.lowpri_throttle_enabled=0

# 关闭全速备份：
sudo sysctl debug.lowpri_throttle_enabled=1
