ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ESX = exports['es_extended']:getSharedObject()

PrinterList = {}

PrinterPrice = {
  [1] = 1000,
  [2] = 2000,
  [3] = 3000,
  [4] = 4000,
  [5] = 5000,
  [6] = 6000
}

MoneyGet = {
  [1] = 2,
  [2] = 5,
  [3] = 7,
  [4] = 8,
  [5] = 10,
  [6] = 12
}

RegisterServerEvent('esx_printer:addMoney')
AddEventHandler('esx_printer:addMoney', function(id , money)

  MySQL.Async.fetchAll('SELECT * FROM MPrinter WHERE id = @id', {
    ['@id'] = id
  }, function(result)
    if result[1] then
      MySQL.Async.execute('UPDATE MPrinter SET moneyinside = @moneyinside WHERE id = @id', {
        ['@moneyinside'] = result[1].moneyinside + money,
        ['@id'] = id
      }, function(rowsChanged)
      end)
    end
  end)
end)

ESX.RegisterServerCallback('esx_printer:getOwnedPrinters', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll('SELECT * FROM MPrinter WHERE owner = @owner', {
      ['@owner'] = xPlayer.identifier
  }, function(result)
      cb(result)
  end)
end)

ESX.RegisterServerCallback('esx_printer:getPrinterInfos', function(source, cb, id)
  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.fetchAll('SELECT * FROM MPrinter WHERE id = @id', {
      ['@id'] = id
  }, function(result)
      cb(result)
  end)
end)


RegisterServerEvent('esx_printer:removeMoneyAll')
AddEventHandler('esx_printer:removeMoneyAll', function()
  local xPlayer = ESX.GetPlayerFromId(source)

  local result = MySQL.Sync.fetchAll('SELECT * FROM MPrinter WHERE owner = @owner AND moneyinside >= @moneyinside', {
    ['@owner'] = xPlayer.identifier,
    ['@moneyinside'] = 1000
  })
  if result == nil then 
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il faut au moins 1000 $ dans vos printer pour retirer l\'argent')
    return
  end
  if #result == 1 then
    MySQL.Async.execute('UPDATE MPrinter SET moneyinside = @moneyinside WHERE id = @id', {
      ['@moneyinside'] = 0,
      ['@id'] = result[1].id
    }, function(rowsChanged)
      xPlayer.addMoney(result[1].moneyinside)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré l\'argent')
    end)
  else
    for k,v in pairs(result) do
      MySQL.Async.execute('UPDATE MPrinter SET moneyinside = @moneyinside WHERE id = @id', {
        ['@moneyinside'] = 0,
        ['@id'] = v.id
      }, function(rowsChanged)
        xPlayer.addMoney(v.moneyinside)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré l\'argent')
      end)
    end
  end
end)

RegisterServerEvent('esx_printer:addPaperAll')
AddEventHandler('esx_printer:addPaperAll', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local result = MySQL.Sync.fetchAll('SELECT * FROM MPrinter WHERE owner = @owner', {
    ['@owner'] = xPlayer.identifier
  })
  if #result == 1 then
    if xPlayer.getMoney() >= 100 then
      xPlayer.removeMoney(100)
      MySQL.Async.execute('UPDATE MPrinter SET paper = @paper WHERE id = @id', {
        ['@paper'] = 100,
        ['@id'] = result[1].id
      }, function(rowsChanged)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ajouté du papier')
      end)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez d\'argent')
      return
    end
  else
    if xPlayer.getMoney() >= 100 * #result then
      xPlayer.removeMoney(100 * #result)
      for k,v in pairs(result) do
        MySQL.Async.execute('UPDATE MPrinter SET paper = @paper WHERE id = @id', {
          ['@paper'] = 100,
          ['@id'] = v.id
        }, function(rowsChanged)
          TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ajouté du papier')
        end)
      end
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez d\'argent')
      return
    end
  end


end)

RegisterServerEvent('esx_printer:buyPrinter')
AddEventHandler('esx_printer:buyPrinter', function(grade)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= PrinterPrice[grade] then
        xPlayer.removeMoney(PrinterPrice[grade])
        MySQL.Async.execute('INSERT INTO MPrinter (owner, grade, paper) VALUES (@owner, @grade, @paper)', {
            ['@owner'] = xPlayer.identifier,
            ['@grade'] = grade,
            ['@paper'] = 100
        }, function(rowsChanged)
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez acheté une imprimante')
        end)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez d\'argent')
    end

end)

function AddMoneyInPrinter(id, money)
  result = MySQL.Sync.fetchAll('SELECT * FROM MPrinter WHERE id = @id', {
    ['@id'] = id
  })
  if result[1].moneyinside >= 10000 then
    return
  end

  if result[1].paper <= 0 then
      MySQL.Async.execute('UPDATE MPrinter SET paper = @paper WHERE id = @id', {
        ['@paper'] = 0,
        ['@id'] = id
      }, function(rowsChanged)

        
      end)
    return

  end  

  MySQL.Async.fetchAll('SELECT * FROM MPrinter WHERE id = @id', {
    ['@id'] = id
  }, function(result)
    if result[1] then
      MySQL.Async.execute('UPDATE MPrinter SET moneyinside = @moneyinside WHERE id = @id', {
        ['@moneyinside'] = result[1].moneyinside + money,
        ['@id'] = id
      }, function(rowsChanged)
        random = math.random(1, 3)
        random1 = math.random(1, 5)
        if random1 == 2 then 
          if random == 1 then
            MySQL.Async.execute('UPDATE MPrinter SET paper = @paper WHERE id = @id', {
              ['@paper'] = result[1].paper - 1,
              ['@id'] = id
            }, function(rowsChanged)
            end)

          end
        end 
      end)
    end
  end)
end 

RegisterServerEvent('esx_printer:addPaper')
AddEventHandler('esx_printer:addPaper', function(id)
  local xPlayer = ESX.GetPlayerFromId(source)
  local result = MySQL.Sync.fetchAll('SELECT * FROM MPrinter WHERE id = @id', {
    ['@id'] = id
  })
  local money = xPlayer.getMoney()
  if money >= 100 then
    xPlayer.removeMoney(100)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas assez d\'argent')
    return
  end
  if result[1] then
    MySQL.Async.execute('UPDATE MPrinter SET paper = @paper WHERE id = @id', {
      ['@paper'] = 100,
      ['@id'] = id
    }, function(rowsChanged)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ajouté du papier')
    end)
  end
end)

RegisterServerEvent('esx_printer:removeMoney')
AddEventHandler('esx_printer:removeMoney', function(id)
  local xPlayer = ESX.GetPlayerFromId(source)
  local result = MySQL.Sync.fetchAll('SELECT * FROM MPrinter WHERE id = @id', {
    ['@id'] = id
  })
  if result[1].moneyinside >= 1000 then
    MySQL.Async.execute('UPDATE MPrinter SET moneyinside = @moneyinside WHERE id = @id', {
      ['@moneyinside'] = 0,
      ['@id'] = id
    }, function(rowsChanged)
      xPlayer.addMoney(result[1].moneyinside)
      TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré l\'argent')
    end)
  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Il faut au moins 1000 $ dans vos printer pour retirer l\'argent')
  end

end)

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(5000)
    MySQL.Async.fetchAll('SELECT * FROM MPrinter', {}, function(result)
      for k,v in pairs(result) do
        AddMoneyInPrinter(v.id, MoneyGet[v.grade])
      end
    end)
  end
end)

