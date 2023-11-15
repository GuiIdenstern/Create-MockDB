function Remove-MenuItemsDB {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Settings
    )

    $DBHost = $Settings.PostgreSql.Host
    $DBUser = $Settings.PostgreSql.User
    $DBPasword = $Settings.PostgreSql.Pasword
    $DBPort = $Settings.PostgreSql.Port
    $DBName = $Settings.PostgreSql.Name

    $connection = Connect-PostgreSQL -Server $DBHost -User $DBUser -Password $DBPasword -Port $DBPort -Database $DBName

    $query = 'delete from menu_items'

    $result=
    Invoke-PostgreSQL -Query $query -Connection $connection
    Disconnect-PostgreSQL -Connection $connection
    return $result
}