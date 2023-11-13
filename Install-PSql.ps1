function Install-PSql {
    if (!(Get-Module -ListAvailable -Name PostgreSQLCmdlets)) {
        Install-Module -Name PostgreSQLCmdlets -Force
    }
    Import-Module -Name PostgresqlCmdlets
}