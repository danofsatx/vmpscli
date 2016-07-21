<# setIPAddress.ps1
Author:   Dan Mossor, RHCSA
Created:  20 July 2016

Purpose:  Programmatically assign IP addresses
          to Windows Virtual Machines within
          a Vmware VCenter environment.

Usage:    setIPAddress -site <sitename> -conn "<Connection Name>"

          sitename points to a local file named
          sitename.csv which is a comma separated
          value list of virtual machine names and
          IP addresses having a header row of 
          "hostname,ipadx".
		  
		  Connection Name is the name of the interface within
		  Windows, such as "Local Area Connection 3". #>

param (
    [Parameter(Mandatory=$True)]
    [string]$site = "",
    [Parameter(Mandatory=$True)]
	[string]$conn = ""
    )

$targetvms = Import-Csv .\$site.csv # Imports the CSV file for parsing
$user = "administrator" # Virtual Machine Guest username
$pass = "SuperSecretPassword" # Virtual Machine Guest password

ForEach ($vm in $targetvms) #  For each line in the CSV file
    {
        # Set the hostname from the "hostname" column
        $tgt = $vm.hostname
        
        # Set the IP address from the "ipadx" column
        $ip = $vm.ipadx
        
        # The actual command to be run on the Windows guest
        $cmdtext = "netsh interface ip set address name=`"$conn`" static $ip"
        
        # The Vmware PowerCLI cmdlet that will connect to the guest, login, and run the above command
        # Valid options for ScriptType are bat for MSDOS commands, PowerShell for PS, or bash for Linux guests
        Invoke-VMScript -ScriptText $cmdtext -ScriptType bat -VM "$tgt" -GuestUser "$user" -GuestPassword "$pass"
    }