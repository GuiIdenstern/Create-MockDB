function Set-MockDB {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [ValidateScript({
                Test-Path -Path $_
            }, ErrorMessage = 'Файл меню по адресу не найден')]
        [ValidateScript({
            (Split-Path -Path $_ -Extension) -eq '.txt'
            }, ErrorMessage = 'Файл меню имеет расширение, отличное от .txt')]
        [ValidateScript({
            (Get-Content -Path $_).Length -gt 1
            }, ErrorMessage = 'Файл меню пуст')]
        [string]$Path_Menu,

        [ValidateScript({
            (Split-Path -Path $_ -Extension) -eq '.csv'
            }, ErrorMessage = 'Файл меню имеет расширение, отличное от .csv')]
        [string]$Path_Mock = 'C:\Users\mitya\Desktop\MockDb_test.csv',

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Header_Name,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Header_Id,

        [ValidateNotNullOrEmpty()]
        [string]$Header_Weight,

        [ValidateNotNullOrEmpty()]
        [string]$Header_Count,

        [ValidateNotNullOrEmpty()]
        [string]$Header_Proto,

        [ValidateNotNullOrEmpty()]
        [string]$Header_Price,

        [ValidateNotNullOrEmpty()]
        [string]$Header_IsWeight,

        [ValidateNotNullOrEmpty()]
        [string] $Replacer_Proto='compot1',

        [ValidateNotNullOrEmpty()]
        [string]$Replacer_Price=100,

        [switch] $ClearDatabase
    )
    
    $OLD_MockDB_Path=Join-Path -Path (Split-Path -Path $Path_Mock -Parent) -ChildPath 'OLD_MockDB.csv'

    $menu_list = [System.Collections.ArrayList]::new()
    $id_list = [System.Collections.ArrayList]::new()

    if ($ClearDatabase) {
        Remove-MenuItemsDB
        Write-Debug 'Все позиции меню в базе данных были удалены'
    } 
    
    #Пересоздание файла MockDB
    if (Test-Path $Path_Mock) {
        Write-Debug "Файл Mock по адресу $Path_Mock уже существует"
        if(Test-Path ($OLD_MockDB_Path)){
            Remove-Item -Path $OLD_MockDB_Path
            Write-Debug "Старый файл Mock по адресу $OLD_MockDB_Path был удален"
        }
        $newname = Rename-Item -Path $Path_Mock -NewName 'OLD_MockDB.csv' -PassThru -Force
        Write-Debug "Новый файл Mock по адресу $newname был создан"
    }
    else {
        New-Item -Path $Path_Mock
        Write-Debug "Новый файл Mock по адресу $Path_Mock был создан"
    }

    #Получение содержимого файла меню
    $menu = Get-Content -Path $Path_Menu -Encoding UTF8


    #Получение заголовков
    $headers = $menu[0].Split('	')

        #Получение номеров столбцов с нужными заголовками
        $NamePosition = $headers.IndexOf($Header_Name)
        if($NamePosition -eq -1){
            Write-Debug "Заголовок имени '$Header_Name' не найден, выход из скрипта.."
            return
        }

        $IdPosition = $headers.IndexOf($Header_Id)
        if($IdPosition -eq -1){
            Write-Debug "Заголовок кода '$Header_Id' не найден, выход из скрипта.."
            return
        }

        $WeightPosition=$headers.IndexOf($Header_Weight)
        $CountPosition=$headers.IndexOf($Header_Count)
        $ProtoPosition=$headers.IndexOf($Header_Proto)
        $PricePosition=$headers.IndexOf($Header_Price)
        $IsWeightPosition=$headers.IndexOf($Header_IsWeight)

        


        #Обход меню
        for ([int]$i = 1; $i -lt $menu.Length; $i++) {

            #Разделение текущей строки на свойства блюда через табуляцию
            $item = $menu[$i].Split('	')

            #Обработка имени
            $item_name = $item[$NamePosition]
            #Проверка на пустое имя, прекращение обхода если да
            if ([string]::IsNullOrEmpty($item_name)) {
                Write-Debug "Обход меню закончен на позиции $i из-за пустого имени"
                break
            }
            #Форматирование имени
            $item_name=$item_name.
            Replace(',',' ').
            Replace('"',' ').
            Replace('/',' ').
            Replace('  ',' ').
            Replace('  ',' ').
            Trim(' ')

            #Обработка кода
            $item_id = $item[$IdPosition]
            #Замена отсутствующего кода на номер строки для обеспечения уникальности кодов
            if ([string]::IsNullOrEmpty($item_id)) {
                Write-Debug "Строка $i не имеет кода, использован идентификатор строки"
                $item_id = $i.ToString()
            }
            #Проверка на уникальность кода
            if ($id_list.IndexOf($item_id) -ne -1) {
                Write-Debug "Строка $i имеет повторяющийся код, добавлен идентификатор строки"
                $item_id = $item_id + '(' + $i.ToString() + ')'
            }
            #Запись кода в лист уникальных
            [void]$id_list.Add($item_id)

            #Обработка веса
            if($WeightPosition -ne -1){
                $item_weight=$item[$WeightPosition]
                if(![string]::IsNullOrEmpty($item_weight)){
                    $item_name+=" $item_weight"
                }
            }

            #Обработка счетности
            if($CountPosition -ne -1){
                $item_count=$item[$CountPosition]
                if(![string]::IsNullOrEmpty($item_count)){
                    $item_name+=" СЧЕТНОСТЬ: $item_count"
                }
            }

            #Обработка прото
            if($ProtoPosition -ne -1){
                $item_proto=$item[$ProtoPosition]
                if([string]::IsNullOrEmpty($item_proto)){
                    $item_proto=$Replacer_Proto
                }
            }
            else {
                $item_proto=$Replacer_Proto
            }

            #Обработка цены
            if($PricePosition -ne -1){
                $item_price=[int]($item[$PricePosition] -replace '\D')
                if([string]::IsNullOrEmpty($item_proto)){
                    $item_price=$Replacer_Price
                }
            }            
            else {
                $item_price=$Replacer_Price
            }

            #Обработка весовости
            if($IsWeightPosition -ne -1){
                $item_isweight=$item[$IsWeightPosition]
                if([string]::IsNullOrEmpty($item_isweight) -or ($item_isweight -eq 'false')){
                    $item_isweight='false'
                }
                else {
                    $item_isweight='true'
                }
            }
            else {
                $item_isweight='false'
            }

            #Генерация строки MockDB
            $str = "$i,$item_id,$item_name,$item_price,$item_isweight,$item_proto"

            #Запись строки в лист меню
            [void]$menu_list.Add($str)
            
        }
    Set-Content -Path $Path_Mock -Value $menu_list -Encoding UTF8
    #$menu_list
}

function Remove-MenuItemsDB {
    Install-PSql

    $DBHost = 'localhost'
    $DBUser = 'postgres'
    $DBPasword = '1'
    $DBport = '5432'
    $DBName = 'TerminalDbSKU'

    $connection = Connect-PostgreSQL -Server $DBHost -User $DBUser -Password $DBPasword -Port $DBport -Database $DBName

    $query = 'select * from menu_items'

    $result=
    Invoke-PostgreSQL -Query $query -Connection $connection
    Disconnect-PostgreSQL -Connection $connection
    return $result
}
function Install-PSql {
    if (!(Get-Module -ListAvailable -Name PostgreSQLCmdlets)) {
        Install-Module -Name PostgreSQLCmdlets -Force
    }
    Import-Module -Name PostgresqlCmdlets
}

function Get-Settings{
    $Settings=Get-Content .\Settings.json|ConvertFrom-Json
    
    return $Settings
}

#Set-MockDB -Path_Menu "C:\Users\mitya\Desktop\Текстовый документ.txt" -Header_Name 'Наименование по меню(как указано ценниках)' -Header_Id 'Внешний код в кассовой системе'  -Header_Proto 'Proto' -Debug