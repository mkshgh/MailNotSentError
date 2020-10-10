# OfficalScriplets
Handy Dandy Scriplets to use for daily official use. Using scripts to make the task easier at the office.

## _net_mail_notWorking.ps1


HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\vX.0.30319 

#### makes changes to the following Regestry keys: ####
 - HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\<<chosen .net version>>
    ( is the .net version eg: v4.0.30319)
 - HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\<<chosen .net version>>

#### Use this script if you have the following done ####
 - Using Sql server 2012, 2012R2
 - Use IISCrypto disabling the TLS 1.0 and 1.1 
 - Gives "mail not sent" error in sql server


### HOW TO USE ###
 - Open Powershell as administrator
 - Go the location of the script
 - Run the script 
 

`PS E:\PowerShellScripts\OfficalScriplets> .\_net_mail_notWorking.ps1`

 - Enter the .net version you want to enter. Leave Empty if you want to enable it for all.
 Normally .NET2 and .NET4 are sufficient in Windows server 2012 and 2012R2
 
`Enter the .net Version to Enable TLS 1.2 on (Leave Empty if for all .NET versions): 24`
![alt text](https://raw.githubusercontent.com/mkshgh/OfficalScriplets/main/pictures/_net_mail_notWorking.png)
