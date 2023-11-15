$Settings=@{
    MockDB=@{
        Headers=@{
            Name="Наименование по меню(как указано ценниках)"
            Id="Внешний код в кассовой системе"
            Proto="Proto"
            Weight="Выход"
            Count="countable"
            Price="Цена"
            IsWeight="Весовое"
        }
        Replacers=@{
            Proto="compot1"
            Price="100"
            Weight=""
        }
        Usage=@{
            Headers=@{
                Proto=$false
                Weight=$false
                Count=$false
                Price=$false
                IsWeight=$false     
            }   
            Features=@{
                ClearDatabase=$false
                SavingOldMockDB=$false
            }   
        }
    }
    Paths=@{
        MockDB_BasePath="C:\Users\mitya\Documents\Test_LFP\"
        MockDB="MockDB.csv"
        MockDB_txt="MockDB.txt"
        MockDB_OLD="OLD_MockDB.csv"
    }
    Info=@{
        ObjectName="Test_Object"
    }
    PostgreSql=@{
        Host = 'localhost'
        User = 'postgres'
        Pasword = '1'
        Port = '5432'
        Name = 'TerminalDbSKU'
    }
}

ConvertTo-Json -InputObject $Settings -Depth 10|Set-Content ./Settings.json