@echo off

powershell -command "Expand-Archive -Force '%~dp0library\NiTE2\Data\lbsdata.lbd.zip' '%~dp0library\NiTE2\Data\'"

@pause