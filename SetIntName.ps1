<# setIntName.ps1
Author:   Dan Mossor, RHCSA
Created:  20 July 2016

Purpose:  Programmatically rename an interface
          on Windows Virtual Machines within
          a Vmware VCenter environment.

		  Usage:    setIntName -site <sitename> -net <Network Name>

          sitename points to a local file named
          sitename.csv which is a comma separated
          value list of virtual machine names and
          IP addresses having a header row of 
          "hostname,ipadx".

          Network Name is the new name of the connection.#>

param (
    [Parameter(Mandatory=$True)]
    [string]$site = "",
    [Parameter(Mandatory=$True)]
    [string]$net = ""
    )


$user = "administrator" # Guest User Name
$pass = "SuperSecretPassword" # Guest Password
# Networks being added to Windows usually are assigned this name
$intfc = "`"Local Area Connection 3`""
# Command to be passed to Windows Guest machines
$cmdtext = "netsh interface set interface name=`"$intfc`" newname=`"$net`"; "
$targetvms = Import-Csv "./$site.csv"

ForEach ($vm in $targetvms)
    {
    $tgt = $vm.hostname
    Invoke-VMScript -ScriptText $cmdtext -ScriptType bat -VM "$tgt" -GuestUser "$user" -GuestPassword "$pass"
    }