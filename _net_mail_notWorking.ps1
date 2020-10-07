
#This will be used to check which values are already set in the protocols
#Returns the validated .net paths where the values need to be changed
#reutrns the valid _net_path
function _net_path_parser{

}
function update_SystemDefaultTlsVersions_net {

    #The path to check if the .net versions are available or not
    $reg_parent_path1 = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework"
    $reg_parent_path2 = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\.NETFramework"

    Write-Host "Enter the .net Versions you want to enable TLS 1.2 for"
    Write-Host "Eg: if .NET2 and .NET4 write: 24"
    #Input the versions that you need to enable the TLS 1.2 in
    $_net_versions = Read-Host ".net Versions" 

    #If empty set to check all the versions then use all the .net version from 1-9 though might not exist
    if (!$_net_versions) {
        $_net_versions = '[1-9]'
    }

    #Get the child items of this Node
    #pipeline the output to filter the name of the child nodes
    $_net_paths = Get-ChildItem -Path $reg_parent_path1 | Select-Object
    #array to store the validated paths for checking
    
    #check if the item is the given .net version or not 
    #store the checked values to the given array
    #If the it is not a .net version then add to an array v[24] means v2 or v4 which searches these keys
    $_net_path_array = (Get-ChildItem $reg_parent_path1).Name -match "v[$_net_versions]"
    #add the reg_parent_path2 childItems to the list too
    $_net_path_array += (Get-ChildItem $reg_parent_path2).Name -match "v[$_net_versions]"

    #Adding the property ("Name","PropertyType","Value") from this array
    $property_param="SystemDefaultTlsVersions","DWord","00000001"
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
            Get-ItemProperty -Path "Registry::$_net_path" 
        }
    }

}
update_SystemDefaultTlsVersions_net