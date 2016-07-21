<# AddNetworkInterface.ps1
Author:   Dan Mossor, RHCSA

Created:  20 July 2016

Purpose:  Programmatically add an interface
          to Virtual Machines within
          a Vmware VCenter environment.

Usage:    AddNetworkInterface -site <sitename> -net <Network Name>
          
          sitename points to a local file named
          sitename.csv which is a comma separated
          value list of virtual machine names and
          IP addresses having a header row of 
          "hostname,ipadx".
          
          Network Name is the name of the Vmware network#>
          
param (
    [Parameter(Mandatory=$True)]
    [string]$site = "",
    [Parameter(Mandatory=$True)]
    [string]$net = ""
    )

$targetvms = Import-Csv "./$site.txt"

ForEach ($vm in $targetvms)
    {
    $tgt = $vm.hostname
    New-NetworkAdapter -NetworkName $net -StartConnected -Type e1000 -VM $tgt
    }