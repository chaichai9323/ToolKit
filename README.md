# ToolKit
自定义工具集,使用方法：

1.打开终端，进入podfile目录

2.复制下边的命令，执行

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chaichai9323/ToolKit/main/exe.sh)"


注意事项：

1.工程里边需要存在GoogleService-Info.plist的正式服文件，名字可以是[GoogleService-Info*.plist]中的任意

  #需要注意工程里边测试的GoogleService配置包含 test-project
  
2.检查一下target工程配置的 active compilation conditions: Release不能手动配置内容 (如需添加配置，请配置在工程配置，不要直接配置target)

使用方法：

var apiURL: String {

#if AppStoreEnv//线上环境

    "http://18.217.239.18"
    
#else//开发环境

    #if DEBUG//debug模式    
        "http://18.217.239.18"
    #else//release模式
        "http://18.217.239.18"
    #endif
#endif

}
