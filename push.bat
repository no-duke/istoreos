@echo off
chcp 65001 >nul
echo ===== ZN-M2 iStoreOS 推送脚本 =====
echo.
echo 请先确保你已经 fork 了 https://github.com/no-duke/istoreos-m2
echo 到你的 GitHub 账号下，名字可自行修改。
echo.
set /p REPO="请输入你的 fork 地址，例如 yourname/istoreos-m2: "
echo.
echo 正在配置远程...
cd /d %~dp0
git remote set-url origin https://github.com/%REPO%.git
echo 远程已设为: https://github.com/%REPO%.git
echo.
set /p TOKEN="请输入 GitHub Personal Access Token (repo scope): "
echo.
git remote set-url origin https://%TOKEN%@github.com/%REPO%.git
echo.
echo 正在提交并推送 zn-m2 分支...
git add -A
git commit -m "feat: add ZN M2 device support for iStoreOS istoreos-24.10" || echo "nothing to commit"
git push -u origin zn-m2
echo.
echo ===== 推送完成！=====
echo 请在浏览器访问:
echo https://github.com/%REPO%/actions
echo 选择 zn-m2 分支的 workflow，点击 Run workflow 开始编译。
echo 编译产物通常需要 30-60 分钟。
echo.
echo 如果你想用更简单的方式触发，可以用 GitHub Actions UI:
echo 1. 打开上面的 actions URL
echo 2. 左侧选择 "Firmware Build"
echo 3. 点击 "Run workflow" 按钮
echo 4. 确认 Run 即可
echo.
pause
