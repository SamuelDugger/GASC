$arg1 = $args[0]
$arg2 = $args[1]
Test-Connection -ComputerName $arg1 -Count 1 | Out-File -FilePath $arg2.txt