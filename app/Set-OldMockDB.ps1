
function Set-OldMockDB{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Settings
    )

    #Получение путей из файла настроек
    $Path=Join-Path -Path $Settings.Paths.MockDB_BasePath -ChildPath $Settings.Paths.MockDB
    $Path_Old=Join-Path -Path $Settings.Paths.MockDB_BasePath -ChildPath $Settings.Paths.MockDB_OLD

    #Проверка наличия файла MockDB
    if(!(Test-Path $Path)){
        Write-Error "Файл MockDB.csv не найден" -ErrorAction Break
    }

    #Удаление старого файла OLD_MockDB если он существует
    if(Test-Path $Path_Old){
        Write-Debug "Файл OLD_MockDB.csv уже существует"
        Remove-Item $Path_Old
        Write-Debug "Файл OLD_MockDB.csv удален"
    }

    #Копирование MockDB в OLD_MockDB
    Copy-Item -Path $Path -Destination $Path_Old
    Write-Debug "Файл OLD_MockDB.csv создан"
    return 0
}