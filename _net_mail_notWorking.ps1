Write-Host "##################################################################################"
Write-Host "Copyright © 2020, [mkshgh](https://github.com/mkshgh)" -ForegroundColor Green
Write-Host "##################################################################################"


#This will be used to check which values are already set in the protocols
#Returns the validated .net paths where the values need to be changed
#reutrns the valid _net_path
function get_net_versions{
    $reg_parent_path1 = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework"
    #Get the .Net version Name using regex v[24] means v2 or v4 which searches these keys
    $_net_path_array = (Get-ChildItem $reg_parent_path1).Name -match "v[1-9]"
    $_version = foreach ($item in $_net_path_array) {
         Split-Path $item -leaf
    }
    Write-Host $_version -ForegroundColor Green
}


function update_SystemDefaultTlsVersions_net {

    #The parameters are here
    #The path to check if the .net versions are available or not
    $reg_parent_path1 = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework"
    $reg_parent_path2 = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework"
    #Adding the property ("Name","PropertyType","Value") from this array
    $property_param="SystemDefaultTlsVersions","DWord","00000001"


    #This prints the available versions in the system
    Write-Host "You have the followig .NET versions available: "-NoNewline; get_net_versions
    Write-Host "##################################################################################"
    Write-Host""
    Write-Host "Eg: if .NET2 and .NET4 write: "-ForegroundColor Yellow -NoNewline; Write-Host "24" -ForegroundColor Green;


    #Input the versions that you need to enable the TLS 1.2 in
    $_net_versions = Read-Host "Enter the .net Version to Enable TLS 1.2 on (Leave Empty if for all .NET versions)" ; 

    #Adds all the avialable versions to enable the TLS 1.2 in the computers
    if ([string]::IsNullOrEmpty($_net_versions)) {
        Write-Host "enteredhere"
        #Although only upto .NETv4 is available. we use 1-9 for searching here, which is fine.
        $_net_versions = '1-9'
    }
    elseif (!($_net_versions -match '[1-9]')) {
        Write-Error 'The Versions can be only Decimal Numbers, alphabets or characters not allowed'
    }

    #check if the item is the given .net version or not 
    #store the checked values to the given array
    #If the it is not a .net version then add to an array 
    #Get the .Net version Name using regex v[24] means v2 or v4 which searches these keys
    $_net_path_array = (Get-ChildItem $reg_parent_path1).Name -match "v[$_net_versions]"
    #add the reg_parent_path2 childItems to the list too
    $_net_path_array += (Get-ChildItem $reg_parent_path2).Name -match "v[$_net_versions]"


    #Adding the Regestry keys in the windows system
    foreach ($_net_path in $_net_path_array) {
        #Try to insert create a new property
        try{   
            New-ItemProperty -Path "Registry::$_net_path" -Name $property_param[0] -PropertyType $property_param[1] -Value $property_param[2]   -ErrorAction stop
        }

        #Try to update the existing property if exist already
        catch{
            # if((Read-Host "Do you want to change the Values") -like '[Yy]'){
            #     write-host "continue"
            Set-ItemProperty -Path "Registry::$_net_path" -Name $property_param[0] -Value $property_param[2]
            # }
            # else{
            #     write-host "end"
            # }
        }

        #show the updated values at the end.
        finally{
            Write-Host "At $_net_path"
            Write-Host "Paremeter set to "-ForegroundColor Red -NoNewLine; 
            Write-Host "$property_param" -ForegroundColor Green; 
        }
    }

}

update_SystemDefaultTlsVersions_net

# # This is where I test the code
# function Test {
#   
# }

# Test
