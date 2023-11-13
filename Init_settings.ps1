$Settings=@{
    MockDB=@{
        Headers=@{
            Name="Наименование по меню(как указано ценниках)"
            Id="Внешний код в кассовой системе"
            Proto="Proto"
            Weight=""
            Count=""
            Price=""
            IsWeight=""
        }
        Replacers=@{
            Proto=""
            Price=""
            Weight=""
        }
        Usage=@{
            Proto=$false
            Weight=$false
            Count=$false
            Price=$false
            IsWeight=$false           
        }
    }
    Paths=@{
        MockDB="C:\Users\mitya\Documents\Test_LFP\MockDB.csv"
        MockDB_txt="C:\Users\mitya\Documents\Test_LFP\MockDB.txt"
    }
    Info=@{
        ObjectName="Test_Object"
    }
}

ConvertTo-Json -InputObject $Settings|Set-Content .\Settings.json