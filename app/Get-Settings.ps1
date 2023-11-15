function Get-Settings{
    [CmdletBinding()]
    param(

    )
    
    #Проверка наличия файла Settings.json, прерывание если нет
    if(!(Test-Path .\Settings.json))
    {
        Write-Error "Файл Settings.json не найден."  -ErrorAction Stop
        "aaa"
    }

    $Settings=Get-Content .\Settings.json|ConvertFrom-Json
    
    return $Settings
}