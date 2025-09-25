@echo off
echo MsgBox "QUAS WEX EXORT", 0, "Alert" > "%temp%\tempmsg.vbs"
cscript //nologo "%temp%\tempmsg.vbs"
del "%temp%\tempmsg.vbs"
