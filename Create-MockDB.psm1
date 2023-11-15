function Set-MockDB {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        .\app\Get-Settings.ps1
        .\app\Install-PSql.ps1
        .\app\Remove-MenuItemsDB.ps1
        .\app\Set-OldMockDB.ps1
    }
    
    process {
        
        $Settings=Get-Settings

        "bbb"
    }
    
    end {
        
    }
}

Set-MockDB

<#
function _Set-MockDB {
          
    Remove-MenuItemsDB
    

    $menu_list = [System.Collections.ArrayList]::new()
    $id_list = [System.Collections.ArrayList]::new()



    if ($ClearDatabase) {
        Remove-MenuItemsDB
        Write-Debug 'Все позиции меню в базе данных были удалены'
    } 
    
    #Пересоздание файла MockDB


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
}#>



#Set-MockDB -Path_Menu "C:\Users\mitya\Desktop\Текстовый документ.txt" -Header_Name 'Наименование по меню(как указано ценниках)' -Header_Id 'Внешний код в кассовой системе'  -Header_Proto 'Proto' -Debug