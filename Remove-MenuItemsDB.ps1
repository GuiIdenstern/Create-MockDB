function Remove-MenuItemsDB {
    Install-PSql

    $Settings=(Get-Settings).PostgreSql

    $DBHost = $Settings.Host
    $DBUser = $Settings.User
    $DBPasword = $Settings.Pasword
    $DBPort = $Settings.Port
    $DBName = $Settings.Name

    $connection = Connect-PostgreSQL -Server $DBHost -User $DBUser -Password $DBPasword -Port $DBPort -Database $DBName

    $query = 'delete from menu_items'

    $result=
    Invoke-PostgreSQL -Query $query -Connection $connection
    Disconnect-PostgreSQL -Connection $connection
    return 'bruh'#$result
}