:: --------------------------------------------------------------
::	项目: CloudflareSpeedTest 自动更新域名解析记录
::	版本: 1.0.4
::	作者: XIU2
::	项目: https://github.com/XIU2/CloudflareSpeedTest
:: --------------------------------------------------------------
@echo off
Setlocal Enabledelayedexpansion

:: 这里可以自己添加、修改 CloudflareST 的运行参数，echo.| 的作用是自动回车退出程序（不再需要加上 -p 0 参数了）
echo.|CloudflareST.exe -o "result_ddns.txt" -f GcoreCDN-ip.txt -tl 100

:: 判断结果文件是否存在，如果不存在说明结果为 0
if not exist result_ddns.txt (
    echo.
    echo CloudflareST 测速结果 IP 数量为 0，跳过下面步骤...
    goto :END
)

for /f "tokens=1 delims=," %%i in (result_ddns.txt) do (
    Set /a n+=1 
    If !n!==2 (
        Echo %%i
        if "%%i"=="" (
            echo.
            echo CloudflareST 测速结果 IP 数量为 0，跳过下面步骤...
            goto :END
        )
        :: 可以从这里下载脚本  https://github.com/evlon/gcore-ddns 
        ::  .gcore-api-token  保存申请的 api token, 文件里面不要有多余的东西
        python gcore-ddns.py --token .gcore-api-token --domain <主域名> --sub <子域名部分> --value %%i --ttl 120
        goto :END
    )
)
:END
pause
