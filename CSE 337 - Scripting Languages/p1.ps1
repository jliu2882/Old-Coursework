#Jack Liu
#jalliu
#112655156
If((Get-Process -Name $args[0] -ErrorAction SilentlyContinue) -eq $Null){ 
    echo "No such processes is running."
	exit
}

Else{ 
	Get-Process -Name $args[0]
	Stop-Process -Name $args[0] -Force
	Get-Job | Wait-Job
	Get-Process
}
