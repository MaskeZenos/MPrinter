
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ESX = exports['es_extended']:getSharedObject()

object = nil
color = "~g~"
MoneyTotal = 0 
MoneyTotal2 = 0
IdSelected = nil
Paper = 0
Money = 0 
Id = 0
Grade = 0 
PrinterInfos2 = {}
PrinterList = {}

OwnedOrNot = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false 
}

PrinterPrice = {
    [1] = 1000,
    [2] = 2000,
    [3] = 3000,
    [4] = 4000,
    [5] = 5000,
    [6] = 6000
}


RMenu.Add('Printer', 'mainPrinter', RageUI.CreateMenu("Printer", "Printer"))
RMenu.Add('Printer', 'subPrinter', RageUI.CreateSubMenu(RMenu:Get('Printer', 'mainPrinter'), "Printer", "Printer"))
RMenu.Add('Printer', 'geresubPrinter', RageUI.CreateSubMenu(RMenu:Get('Printer', 'mainPrinter'), "Printer", "Printer"))
RMenu.Add('Printer', 'geresubPrinter2', RageUI.CreateSubMenu(RMenu:Get('Printer', 'geresubPrinter'), "Printer", "Printer"))

Citizen.CreateThread(function()

    while true do
        RageUI.IsVisible(RMenu:Get('Printer', 'mainPrinter'), function()
        
            RageUI.Separator("↓ ~b~ Printer ~s~↓")

            RageUI.Line()


            RageUI.Button("> Payer des printer", nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                end
            }, RMenu:Get('Printer', 'subPrinter'))

            RageUI.Button("> Gerer ses printer", nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                end
            }, RMenu:Get('Printer', 'geresubPrinter'))
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('Printer', 'geresubPrinter'), function()
            RageUI.Separator("↓ ~b~ Liste de vos printer ~s~↓")
            if #PrinterList > 0 then
                RageUI.Separator("Argent total dans les printers : ~g~" .. MoneyTotal .. " $")
                RageUI.Line()

                MoneyTotal = 0
                for k,v in pairs(PrinterList) do
                    for i=1,#PrinterList do 
                        if type(v) == "table" and v.grade == i then
                            MoneyTotal = MoneyTotal + v.moneyinside
                        end
                    end
                end

                MoneyTotal2 = 0
                for k,v in pairs(PrinterList) do
                    if v.moneyinside > 999 then 
                        for i=1,#PrinterList do 
                            if type(v) == "table" and v.grade == i then
                                MoneyTotal2 = MoneyTotal2 + v.moneyinside
                            end
                        end
                    end 
                end


                RageUI.Button("Prendre l'argent des printers", "Il prend seulement l'argent des printers qui ont minimum 1000 $", { RightLabel = "~g~" .. MoneyTotal2 .. " $" }, true, {
                    onSelected = function()
                        TriggerServerEvent('esx_printer:removeMoneyAll')
                    end
                })
                RageUI.Button("Acheter du papier pour les printers", nil, { RightLabel = "~g~" .. 100 * #PrinterList .. " $" }, true, {
                    onSelected = function()
                        TriggerServerEvent('esx_printer:addPaperAll')
                    end
                })
                RageUI.Line()

            end

            for k,v in pairs(PrinterList) do
                for i=1,#PrinterList do 
                    if type(v) == "table" and v.grade == i then
                        if v.paper > 70 then 
                            color = "~g~"
                        end 
                        if v.paper <= 70 then 
                            color = "~o~"
                        end
                        if v.paper <= 0 then 
                            color = "~r~"
                        end

                        RageUI.Button(color .. "Printer Lvl : ~b~"..v.grade.."~s~", "Papier : " .. v.paper .. " Argent : " .. v.moneyinside .. " $", { RightLabel = "Papier : " .. v.paper .. " Argent : " .. v.moneyinside .. " $"}, true, {
                            onSelected = function()
                                Paper = v.paper
                                Money = v.moneyinside
                                Id = v.id
                                Grade = v.grade
                                IdSelected = v.id
                            end
                        }, RMenu:Get('Printer', 'geresubPrinter2'))
                    end
                end
            end


            if #PrinterList == 0 then
                RageUI.Button("~r~Vous n'avez pas de printer", nil, { RightLabel = "" }, true, {
                    onSelected = function()
                    end
                }, RMenu:Get('Printer', 'subPrinter'))

            end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('Printer', 'geresubPrinter2'), function()
            RageUI.Separator("↓ ~b~ Gestion du printer ~s~↓")
            RageUI.SliderProgress("Papier " .. Paper .. " / 100 :", Paper, 100, nil, {ProgressBackgroundColor = {R = 0, G = 0, B = 0, A = 255}, ProgressColor = {R = 0, G = 100, B = 255, A = 255}}, true, {})
            RageUI.SliderProgress("Argent : " .. Money .. " $ / 10000 $ :", Money, 10000, nil, {ProgressBackgroundColor = {R = 0, G = 0, B = 0, A = 255}, ProgressColor = {R = 0, G = 100, B = 255, A = 255}}, true, {})
            RageUI.Separator("Id : "..Id.." Grade : "..Grade)

            RageUI.Line()

            RageUI.Button("Acheter du papier", nil, { RightLabel = "~g~100 $" }, true, {
                onSelected = function()
                    TriggerServerEvent('esx_printer:addPaper', Id)
                end
            })
            RageUI.Button("Retirer de l'argent", nil, { RightLabel = "→→→" }, true, {
                onSelected = function()
                    TriggerServerEvent('esx_printer:removeMoney', Id)
                end 
            })



        end, function()
        end)
        RageUI.IsVisible(RMenu:Get('Printer', 'subPrinter'), function()
        
            RageUI.Separator("↓ ~b~ Liste des printer ~s~↓")
            RageUI.Line()


            for k,v in pairs(OwnedOrNot) do
                if v == true then
                    RageUI.Button("~g~Vous avez déjà printer ~b~ lvl : "..k.."~s~", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                        end
                    })
                else

                    for i=1,6 do
                        if k == i then
                            if k == 1 then
                                RageUI.Button("~r~Acheter un printer ~b~ lvl : "..k.."~s~", nil, { RightLabel = "~g~"..PrinterPrice[k].."~s~" }, true, {
                                    onSelected = function()
                                        TriggerServerEvent('esx_printer:buyPrinter', k)
                                        Wait(200)
                                        GetOwnedPrinters() 
                                    end
                                })
                            end
                            if k > 1 then
                                if OwnedOrNot[k-1] == true then
                                    RageUI.Button("~r~Acheter un printer ~b~ lvl : "..k.."~s~", nil, { RightLabel = "~g~"..PrinterPrice[k].."~s~" }, true, {
                                        onSelected = function()
                                            TriggerServerEvent('esx_printer:buyPrinter', k)
                                            Wait(200)
                                            GetOwnedPrinters() 
                                        end
                                    })
                                else
                                    RageUI.Button("~r~Acheter un printer ~b~ lvl : "..k.."~s~", nil, { RightLabel = "~g~"..PrinterPrice[k].."~s~" }, true, {
                                        onSelected = function()
                                            ESX.ShowNotification("Vous devez avoir le printer Lvl : ".. k - 1 .." pour acheter le Lvl : "..k)
                                        end
                                    })
                                end
                            end
                        end
                    end




                end
            end

        end, function()
        end)
        Citizen.Wait(0)
    end
end)


function GetOwnedPrinters()
    ESX.TriggerServerCallback('esx_printer:getOwnedPrinters', function(ownedPrinters)
        PrinterList = ownedPrinters

        for k,v in pairs(PrinterList) do
            if type(v) == "table" and v.grade then
                OwnedOrNot[v.grade] = true
            end
        end
    end)
end


function GetPrinterInfos()
    if IdSelected == nil then
        return
    end
    ESX.TriggerServerCallback('esx_printer:getPrinterInfos', function(printerInfos)
        printerInfos = printerInfos
        for k,v in pairs(printerInfos) do
            if type(v) == "table" and v.paper then
                Paper = v.paper
                Money = v.moneyinside
                Id = v.id
                Grade = v.grade
            end
        end
    end, IdSelected)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        GetOwnedPrinters() 
        GetPrinterInfos()
    end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText or "", "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end



function OpenMenuPrinter()
    RageUI.Visible(RMenu:Get('Printer', 'mainPrinter'), not RageUI.Visible(RMenu:Get('Printer', 'mainPrinter')))
end


RegisterCommand("printer" ,function()
    GetOwnedPrinters()
    OpenMenuPrinter()
end)




