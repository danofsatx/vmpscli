<# ListInterfaces.ps1
Author:		Dan Mossor, RHCSA
Created:	20 July 2016

Purpose:	Programmatically list network
			interfaces on Windows Guests
			within a Vmware VCenter environment.

Usage:    ListInterfaces -site <sitename>
          
          sitename points to a local file named
          sitename.csv which is a comma separated
          value list of virtual machine names and
          IP addresses having a header row of 
          "hostname,ipadx".#>
		  
param (
    [Parameter(Mandatory=$True)]
	[string]$site = ""
	)

$user = "administrator"
$pass = "SuperSecretPassword"
$cmdtext = "netsh interface show interface"
$targetvms = Import-Csv "$site.csv"

ForEach ($vm in $targetvms)
    {Invoke-VMScript -ScriptText "$cmdtext" -VM "$vm" -GuestUser "$user" -GuestPassword "$pass"}