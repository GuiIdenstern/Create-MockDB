function Get-Settings{
    $Settings=Get-Content .\Settings.json|ConvertFrom-Json
    
    return $Settings
}