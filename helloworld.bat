@echo off
echo MsgBox "Hello World", 0, "Alert" > "%temp%\tempmsg.vbs"
cscript //nologo "%temp%\tempmsg.vbs"
del "%temp%\tempmsg.vbs"
