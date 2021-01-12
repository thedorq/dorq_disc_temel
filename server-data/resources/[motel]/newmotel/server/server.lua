ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
MySQL.ready(function() print("^2[utk_motels]^1 OTEL SISTEMI HAZIR YAZISI CIKANA KADAR OYUNCULARI SUNUCUYA SOKMAYIN!^0") while not ________ do Citizen.Wait(5000) end ReadySQL() end)

ItemData = {}
PlayerNotifies = {}
local disc_ok = false

RegisterServerEvent("utk_motels:getUTK")
AddEventHandler("utk_motels:getUTK", function(cb)
    while disc_ok == false do
        Citizen.Wait(100)
    end
    cb(UTK)
end)

AddEventHandler('esx:playerLoaded', function(id, xPlayer)
    local result = MySQL.Sync.fetchAll("SELECT `key`, `roommate` FROM utk_keys WHERE holder = @holder", {["@holder"] = xPlayer.identifier})
    local data = {}
    local roomMateData = {}

    if result ~= nil then
        for i = 1, #result, 1 do
            local l = result[i].key:len()
            local a = result[i].key:sub(5, 5)
            local b = result[i].key:sub(7, l)

            table.insert(data, {motelId = tonumber(a), roomId = tonumber(b), roommate = result[i].roommate})
        end
    end
    if Config.roommate then
        local result2 = MySQL.Sync.fetchAll("SELECT `key` FROM utk_keys WHERE roommate = @roommate", {["@roommate"] = xPlayer.identifier})

        if result2 ~= nil then
            for i = 1, #result2, 1 do
                local l = result2[i].key:len()
                local a = result2[i].key:sub(5, 5)
                local b = result2[i].key:sub(7, l)

                table.insert(roomMateData, {motelId = tonumber(a), roomId = tonumber(b)})
            end
        end
    end
    TriggerClientEvent("utk_motels:sendData", xPlayer.source, UTK, data, roomMateData, xPlayer)
    local waitingNotifies = MySQL.Sync.fetchAll("SELECT text, type FROM utk_motels_notifies WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})

    if waitingNotifies ~= nil then
        for n = 1, #waitingNotifies, 1 do
            MySQL.Async.execute("DELETE FROM utk_motels_notifies WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})
            TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = waitingNotifies[n].type, text = waitingNotifies[n].text, lenght = 5000})
        end
    end
end)

if Config.lockpick ~= nil then
    ESX.RegisterUsableItem(Config.lockpick.item, function(source)
        TriggerClientEvent("utk_motels:useLockpick", source)
    end)

    RegisterServerEvent("utk_motels:useLockpick")
    AddEventHandler("utk_motels:useLockpick", function()
        local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.removeInventoryItem(Config.lockpick.item, 1)
    end)
end

RegisterServerEvent("utk_motels:toggleDoor")
AddEventHandler("utk_motels:toggleDoor", function(motelId, roomId, state)
    UTK[motelId].rooms[roomId].locked = state
    TriggerClientEvent("utk_motels:toggleDoor", -1, motelId, roomId, state)
end)

RegisterServerEvent("utk_motels:toggleStash")
AddEventHandler("utk_motels:toggleStash", function(motelId, roomId, state)
    UTK[motelId].rooms[roomId].locked2 = state
    TriggerClientEvent("utk_motels:toggleStash", -1, motelId, roomId, state)
end)

ESX.RegisterServerCallback("utk_motels:nearbyNames", function(source, cb, players)
    for i = 1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i].id)
        local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})

        if result ~= nil then
            players[i].label = result[1].firstname.." "..result[1].lastname.." ["..players[i].id.."]"
        end
    end
    cb(players)
end)

ESX.RegisterServerCallback("utk_motels:getReceptionInfos", function(source, cb, motelId)
    local keydata = MySQL.Sync.fetchAll("SELECT * FROM utk_keys")
    local data = {}
    data.empty = {}
    data.full = {}
    for i = 1, #keydata, 1 do
        if tonumber(keydata[i].key:sub(5, 5)) == motelId then
            if keydata[i].holder:len() < 5 then
                local room = tonumber(keydata[i].key:sub(7, keydata[i].key:len()))
                table.insert(data.empty, {key = keydata[i].key, roomId = room, holder = ""})
            else
                local room = tonumber(keydata[i].key:sub(7, keydata[i].key:len()))
                local temptable = MySQL.Sync.fetchAll("SELECT firstname, lastname, phone_number FROM users WHERE identifier = @identifier", {["@identifier"] = keydata[i].holder})
                table.insert(data.full, {key = keydata[i].key, roomId = room, holder = keydata[i].holder, holdername = temptable[1].firstname.." "..temptable[1].lastname, phone = temptable[1].phone_number})
            end
        end
    end
    cb(data)
end)

ESX.RegisterServerCallback("utk_motels:getEmptyRoom", function(source, cb, motelId)
    local result = MySQL.Sync.fetchAll("SELECT * FROM utk_keys")
    local el = {}
    for i = 1, #result, 1 do
        if result[i].key:sub(5, 5) == tostring(motelId) then
            if result[i].holder:len() < 5 then
                local roomId = tonumber(result[i].key:sub(7, result[i].key:len()))
                table.insert(el, {label = "Oda-"..roomId, motelId = motelId, roomId = roomId})
            end
        end
    end
    if #el ~= 0 then
        cb(el)
    else
        cb(false)
    end
end)

RegisterServerEvent("utk_motels:soundRequest")
AddEventHandler("utk_motels:soundRequest", function(coords, file)
    TriggerClientEvent("utk_motels:soundHandle", -1, coords, file)
end)

RegisterServerEvent("utk_motels:setRoommate")
AddEventHandler("utk_motels:setRoommate", function(motelId, roomId, playerId)
    local owner = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromId(playerId)

    MySQL.Async.execute("UPDATE utk_keys SET roommate = @roommate WHERE holder = @holder", {["@roommate"] = target.identifier, ["@holder"] = owner.identifier})
    TriggerClientEvent("utk_motels:updateRoommates", target.source, motelId, roomId, true)
    TriggerClientEvent("utk_motels:updateOwnedKeys-roommate", owner.source, motelId, roomId, true, target.identifier)
end)

RegisterServerEvent("utk_motels:removeRoommate")
AddEventHandler("utk_motels:removeRoommate", function(motelId, roomId)
    local result = MySQL.Sync.fetchAll("SELECT holder, roommate FROM utk_keys WHERE `key` = @key", {["@key"] = "key_"..motelId.."_"..roomId})

    MySQL.Async.execute("UPDATE utk_keys SET roommate = @roomate WHERE `key` = @key", {["@roommate"] = "", ["@key"] = "key_"..motelId.."_"..roomId})
    if result[1].holder ~= nil and result[1].holder:len() >= 4 then
        local xPlayer = ESX.GetPlayerFromIdentifier(result[1].holder)

        if xPlayer ~= nil then
            TriggerClientEvent("utk_motels:updateOwnedKeys-roommate", xPlayer.source, motelId, roomId, false)
        else
            MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                ["@identifier"] = result[1].holder,
                ["@text"] = "Rommate in Room-"..roomId.." in "..UTK[motelId].info.name.." has left the room."
            })
        end
    end
    if result[1].roommate ~= nil and result[1].roommate:len() >= 4 then
        local xPlayer = ESX.GetPlayerFromIdentifier(result[1].roommate)

        if xPlayer ~= nil then
            TriggerClientEvent("utk_motels:updateRoommates", xPlayer.source, motelId, roomId, false)
        else
            MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                ["@identifier"] = result[1].roommate,
                ["@text"] = "Your keys for Room-"..roomId.." in "..UTK[motelId].info.name.." no longer work."
            })
        end
    end
end)

RegisterServerEvent("utk_motels:rentNotify")
AddEventHandler("utk_motels:rentNotify", function(target, text)
    local xPlayer = ESX.GetPlayerFromIdentifier(target)

    if xPlayer.source ~= nil then
        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = text, lenght = 30000})
    end
end)

-- KEYS --

RegisterServerEvent("utk_motels:updateKeys")
AddEventHandler("utk_motels:updateKeys", function(motelId, roomId, target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tPlayer = ESX.GetPlayerFromId(target)
    local result = MySQL.Sync.fetchAll("SELECT roommate FROM utk_keys WHERE `key` = @key", {["@key"] = "key_"..motelId.."_"..roomId})

    MySQL.Async.execute("UPDATE utk_keys SET holder = @holder WHERE `key` = @key", {
        ["@holder"] = tPlayer.identifier,
        ["@key"] = "key_"..motelId.."_"..roomId
    })
    TriggerClientEvent("utk_motels:updateOwnedKeys", xPlayer.source, motelId, roomId, false)
    TriggerClientEvent("utk_motels:updateOwnedKeys", tPlayer.source, motelId, roomId, true, result[1].roommate)
end)

RegisterServerEvent("utk_motels:rentRoom")
AddEventHandler("utk_motels:rentRoom", function(motelId, roomId, target)
    local _source = source
    local xPlayer
    if target ~= nil then
        xPlayer = ESX.GetPlayerFromId(target)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    MySQL.Async.execute("UPDATE utk_keys SET holder = @holder, roommate = @roommate WHERE `key` = @key", {
        ["@holder"] = xPlayer.identifier,
        ["@roommate"] = "",
        ["@key"] = "key_"..motelId.."_"..roomId
    })
    TriggerClientEvent("utk_motels:updateOwnedKeys", xPlayer.source, motelId, roomId, true, "")
    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "success", text = "Oda anahtarını aldın"..roomId.." in "..UTK[motelId].info.name..".", lenght = 6000})
end)

RegisterServerEvent("utk_motels:clearKey")
AddEventHandler("utk_motels:clearKey", function(holder, motelId, roomId)
    local _source = source
    local xPlayer
    if holder ~= false then
        xPlayer = ESX.GetPlayerFromIdentifier(holder)
    else
        xPlayer = ESX.GetPlayerFromId(_source)
    end
    local result = MySQL.Sync.fetchAll("SELECT roommate FROM utk_keys WHERE holder = @oldholder", {["@oldholder"] = holder})

    if result[1].holder ~= nil and result[1].holder:len() >= 4 then
        local roomMate = ESX.GetPlayerFromIdentifier(result[1].holder)

        if roomMate ~= nil then
            TriggerClientEvent("utk_motels:updateRoomMateData", roomMate.source, motelId, roomId, false)
        else
            MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                ["@identifier"] = result[1].holder,
                ["@text"] = "Room-"..roomId.."'s keys in "..UTK[motelId].info.name.." have been changed, you no longer have access to it."
            })
        end
    end
    MySQL.Async.execute("UPDATE utk_keys SET holder = @newholder, roommate = @roommate WHERE `key` = @key", {
        ["@newholder"] = "",
        ["@roommate"] = "",
        ["@key"] = "key_"..motelId.."_"..roomId
    })
    if xPlayer ~= nil then
        TriggerClientEvent("utk_motels:updateOwnedKeys", xPlayer.source, motelId, roomId, false)
    elseif not holder == false then
        MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
            ["@identifier"] = holder,
            ["@text"] = "Room-"..roomId.."'s keys in "..UTK[motelId].info.name.." have been changed, you no longer have access to it."
        })
    end
    if Config.inventoryreset then
        TriggerEvent("utk_motels:emptyRoomInventory", motelId, roomId)
    end
    if not Config.ownership then
        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "success", text = "Odayı kiralamayı bıraktın-"..roomId.." in "..UTK[motelId].info.name..".", lenght = 6000})
    end
end)

ESX.RegisterServerCallback("utk_motels:payDebt", function(source, cb, motelId, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount("bank").money >= amount then
        MySQL.Async.execute("UPDATE utk_motels_expenses SET debt = @debt WHERE motelId = @id", {["@debt"] = UTK[motelId].info.debt - UTK[motelId].info.expense, ["@id"] = motelId})
        UTK[motelId].info.debt = UTK[motelId].info.debt - amount
        TriggerClientEvent("utk_motels:updateDebt", -1, motelId, UTK[motelId].info.debt)
        xPlayer.removeAccountMoney("bank", amount)
        cb(true)
    else
        cb(false)
    end
end)

function RentHandler()
    local result = MySQL.Sync.fetchAll("SELECT * FROM utk_keys")

    for i = 1, #result, 1 do
        if result[i].holder ~= nil and result[i].holder ~= "" then
            local xPlayer = ESX.GetPlayerFromIdentifier(result[i].holder)

            if xPlayer == nil then
                MySQL.Async.fetchAll("SELECT accounts FROM users WHERE identifier = @identifier", {
                    ["@identifier"] = result[i].holder
                }, function(r)
                    local accounts = json.decode(r[1].accounts)
                    if accounts.bank - Config.rentprice >= 0 then
                        accounts.bank = accounts.bank - Config.rentprice
                        MySQL.Async.execute("UPDATE users SET acounts = @accounts WHERE identifier = @identifier", {
                            ["@accounts"] = json.encode(accounts),
                            ["@identifier"] = result[i].holder
                        }, function(m)
                            if m == 0 then
                                print("^1[UTK_MOTELS] Check your users table, rent prices weren't been able to reduced for KEY: "..result[i].key.." OWNER: "..result[i].holder..".^0")
                            else
                                local l = keys[i].key:len()
                                local a = keys[i].key:sub(5, 5)
                                local b = keys[i].key:sub(7, l)

                                MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                                    ["@identifier"] = result[i].holder,
                                    ["@text"] = Config.rentprice.."$ tutarındaki kira tutarı hesanızdan düşmüştür. Room-"..b.." in "..UTK[tonumber(a)].info.name.."."
                                })
                            end
                        end)
                    else
                        MySQL.Async.execute("UPDATE utk_keys SET holder = @newholder WHERE holder = @oldholder", {
                            ["@newholder"] = "",
                            ["@oldholder"] = result[i].holder
                        })
                        Citizen.CreateThreadNow(function()
                            local l = result[i].key:len()
                            local a = result[i].key:sub(5, 5)
                            local b = result[i].key:sub(7, l)

                            MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                                ["@identifier"] = result[i].holder,
                                ["@text"] = "Oda kiranızı ödemediniz. Room-"..b.." in "..UTK[tonumber(a)].info.name..". Oda kilitleri değişti."
                            })
                        end)
                    end
                end)
            else
                if xPlayer.getAccount("bank").money - Config.rentprice >= 0 then
                    xPlayer.removeAccountMoney("bank", Config.rentprice)
                    local l = keys[i].key:len()
                    local a = keys[i].key:sub(5, 5)
                    local b = keys[i].key:sub(7, l)

                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "success", text = "Oda için ödediğiniz miktar "..Config.rentprice.."$ Oda-"..b.." in "..UTK[tonumber(a)].info.name..".", lenght = 6000})
                else
                    local l = keys[i].key:len()
                    local a = keys[i].key:sub(5, 5)
                    local b = keys[i].key:sub(7, l)
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "success", text = "Oda kiranızı ödemediniz Oda-"..b.." in "..UTK[tonumber(a)].info.name..". Oda kilitleri değiştirildi.", lenght = 6000})
                    TriggerEvent("utk_motels:clearKey", result[i].holder, tonumber(a), tonumber(b))
                end
            end
        end
    end
end

function CustomRentCycle(interval, callback) -- custom auto rent cycle
    Citizen.CreateThread(function()
        local a = false
        repeat
            Citizen.Wait(interval * 3600000)
            callback()
        until a == true
    end)
end

function MotelExpenses()
    for i = 1, #UTK, 1 do
        if UTK[i].info.owner ~= nil and UTK[i].info.owner ~= "" then
            if UTK[i].info.auto_pay then
                local xPlayer = ESX.GetPlayerFromIdentifier(UTK[i].info.owner)

                if xPlayer ~= nil then
                    if xPlayer.getAccount("bank").money - UTK[i].info.expense >= 0 then
                        xPlayer.removeAccountMoney("bank", UTK[i].info.expense)
                        MySQL.Async.execute("UPDATE utk_motels_expenses SET debt = @debt WHERE motelId = @id", {["@debt"] = UTK[i].info.debt - UTK[i].info.expense , ["@id"] = i})
                        UTK[i].info.debt = UTK[i].info.debt - UTK[i].info.expense
                        TriggerClientEvent("utk_motels:updateDebt", -1, i, UTK[i].info.debt)
                        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "success", text = "Ödenen miktar "..UTK[i].info.expense.."$ Motel giderleri için "..UTK[i].info.name..".", lenght = 6000})
                    else
                        MySQL.Async.execute("UPDATE utk_motels_expenses SET debt = @debt WHERE motelId = @id", {["@debt"] = UTK[i].info.expense + UTK[i].info.debt, ["@id"] = i})
                        UTK[i].info.debt = UTK[i].info.debt + UTK[i].info.expense
                        TriggerClientEvent("utk_motels:updateDebt", -1, i, UTK[i].info.debt)
                        TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Ödeme gerçekleşmedi "..UTK[i].info.expense.."$ Motel giderleri için "..UTK[i].info.name..". Artık borca girdiniz!", lenght = 6000})
                    end
                else
                    MySQL.Async.fetchAll("SELECT accounts FROM users WHERE identifier = @identifier", {
                        ["@identifier"] = UTK[i].info.owner
                    }, function(r)
                        local accounts = json.decode(r[1].accounts)

                        if accounts.bank - UTK[i].info.expense >= 0 then
                            accounts.bank = accounts.bank - UTK[i].info.expense
                            MySQL.Async.execute("UPDATE users SET acounts = @accounts WHERE identifier = @identifier", {
                                ["@accounts"] = json.encode(accounts),
                                ["@identifier"] = UTK[i].info.owner
                            })
                            MySQL.Async.execute("UPDATE utk_motels_expenses SET debt = @debt WHERE motelId = @id", {["@debt"] = UTK[i].info.debt - UTK[i].info.expense , ["@id"] = i})
                            UTK[i].info.debt = UTK[i].info.debt - UTK[i].info.expense
                            TriggerClientEvent("utk_motels:updateDebt", -1, i, UTK[i].info.debt)
                            MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                                ["@identifier"] = UTK[i].info.owner,
                                ["@text"] = UTK[i].info.expense.."$ otel giderleriniz banka hesabınızdan otomatik olarak alındı! "..UTK[i].info.name.."."
                            })
                        else
                            MySQL.Async.execute("UPDATE utk_motels_expenses SET debt = debt + @debt WHERE motelId = @id", {["@debt"] = UTK[i].info.expense, ["@id"] = i})
                            UTK[i].info.debt = UTK[i].info.debt + UTK[i].info.expense
                            TriggerClientEvent("utk_motels:updateDebt", -1, i, UTK[i].info.debt)
                            MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                                ["@identifier"] = UTK[i].info.owner,
                                ["@text"] = UTK[i].info.expense.."$ otel giderleri bankanızdan otomatik olarak alınamadı. "..UTK[i].info.name.." Yeterli paranız olmadığı için borca girdiniz!"
                            })
                        end
                    end)
                end
            elseif not UTK[i].info.auto_pay then
                local xPlayer = ESX.GetPlayerFromIdentifier(UTK[i].info.owner)

                if xPlayer ~= nil then
                    MySQL.Async.execute("UPDATE utk_motels_expenses SET debt = @debt WHERE motelId = @id", {["@debt"] = UTK[i].info.expense + UTK[i].info.debt, ["@id"] = i})
                    UTK[i].info.debt = UTK[i].info.debt + UTK[i].info.expense
                    TriggerClientEvent("utk_motels:updateDebt", -1, i, UTK[i].info.debt)
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Otelini için ödeme günü geldi "..UTK[i].info.name.." , "..UTK[i].info.expense.."$ borcunuza eklendi.", lenght = 6000})
                else
                    MySQL.Async.execute("UPDATE utk_motels_expenses SET debt = @debt WHERE motelId = @id", {["@debt"] = UTK[i].info.expense + UTK[i].info.debt, ["@id"] = i})
                    UTK[i].info.debt = UTK[i].info.debt + UTK[i].info.expense
                    MySQL.Async.execute("INSERT INTO utk_motels_notifies (identifier, text) VALUES (@identifier, @text)", {
                        ["@identifier"] = UTK[i].info.owner,
                        ["@text"] = "Otelini için ödeme günü geldi! "..UTK[i].info.name.." , "..UTK[i].info.expense.."$ borcunuza eklendi!."
                    })
                end
            end
        end
    end
end

-- WARDROBE --

ESX.RegisterServerCallback("utk_motels:getWardrobe", function(source, cb, motelId, roomId)
    if roomId == nil or motelId == nil then
        cb({})
    end
    cb(UTK[motelId].rooms[roomId].data.clothes)
end)

RegisterServerEvent("utk_motels:saveSkin")
AddEventHandler("utk_motels:saveSkin", function(motelId, roomId, label, skin)
    UTK[motelId].rooms[roomId].data.saveSkin(label, skin)
end)

RegisterServerEvent("utk_motels:removeSkin")
AddEventHandler("utk_motels:removeSkin", function(motelId, roomId, index)
    UTK[motelId].rooms[roomId].data.removeSkin(index)
end)

-- INVENTORY --

ESX.RegisterServerCallback("utk_motels:getRoomInventory", function(source, cb, motelId, roomId)
    if roomId == nil or motelId == nil then
        return
    end
    cb({
        blackMoney = UTK[motelId].rooms[roomId].data.blackmoney,
        items = UTK[motelId].rooms[roomId].data.inventory,
        weapons = UTK[motelId].rooms[roomId].data.weapons
    })
end)

RegisterServerEvent("utk_motes:setInventoryBusy")
AddEventHandler("utk_motes:setInventoryBusy", function(motelId, roomId, state)
    TriggerClientEvent("utk_motes:setInventoryBusy", -1, motelId, roomId, state)
end)

RegisterServerEvent("utk_motels:putItem")
AddEventHandler("utk_motels:putItem", function(motelId, roomId, name, count, type)
    local xPlayer = ESX.GetPlayerFromId(source)

    if type == "item_standard" then
        local item = xPlayer.getInventoryItem(name)

        if Config.itemsystem == "limit" then
            local motelitem = UTK[motelId].rooms[roomId].data.getItem(name)

            if item.count >= count then
                if motelitem.count + count <= item.limit + Config.motelitemlimit then
                    xPlayer.removeInventoryItem(name, count)
                    UTK[motelId].rooms[roomId].data.addItem(name, count)
                else
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Bundan daha fazlasını motelinize koyamassınız.", lenght = 6000})
                end
            else
                TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Bu eşyanın bu kadarına sahip değilsiniz!", lenght = 6000})
            end
        elseif Config.itemsystem == "weight" then
            local motelitem = UTK[motelId].rooms[roomId].data.getItem(name)

            if item.count >= count then
                if ((motelitem.weight * count) + UTK[motelId].rooms[roomId].data.currentweight) <= Config.motelweightlimit then
                    xPlayer.removeInventoryItem(name, count)
                    UTK[motelId].rooms[roomId].data.addItem(name, count)
                else
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Dolabınızda bu kadar eşyaya yer yok!.", lenght = 6000})
                end
            else
                TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Bu eşyanın bu kadarına sahip değilsiniz.", lenght = 6000})
            end
        end
    elseif type == "item_weapon" then
        local wep = xPlayer.hasWeapon(name)
        local motelweapon = UTK[motelId].rooms[roomId].data.getWeapon(name)

        if wep then
            if motelweapon.ammo == 0 then
                if (motelweapon.weight + UTK[motelId].rooms[roomId].data.currentweight) <= Config.motelweightlimit then
                    xPlayer.removeWeapon(name)
                    UTK[motelId].rooms[roomId].data.addWeapon(name, count)
                else
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Bu silahı koymak için dolapta yer yok!.", lenght = 6000})
                end
            else
                xPlayer.removeWeapon(name)
                UTK[motelId].rooms[roomId].data.addWeapon(name, count)
            end
        elseif not wep then
            TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Üstünüzde bu silah bulunamadı.", lenght = 6000})
        end
    elseif type == "item_account" then
        local black = xPlayer.getAccount("black_money").money

        if black >= count then
            xPlayer.removeAccountMoney("black_money", count)
            UTK[motelId].rooms[roomId].data.addBlack(count)
        else
            TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Üzerinizde bu kadar yok!.", lenght = 6000})
        end
    end
end)

RegisterServerEvent("utk_motels:pickItem")
AddEventHandler("utk_motels:pickItem", function(motelId, roomId, name, count, type)
    local xPlayer = ESX.GetPlayerFromId(source)

    if type == "item_standard" then
        local playeritem = xPlayer.getInventoryItem(name)

        if Config.itemsystem == "limit" then
            local motelitem = UTK[motelId].rooms[roomId].data.getItem(name)

            if motelitem.count >= count then
                if playeritem.count + count <= playeritem.limit or playeritem.limit == -1 then
                    xPlayer.addInventoryItem(name, count)
                    UTK[motelId].rooms[roomId].data.removeItem(name, count)
                else
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Bu eşyadan daha fazla taşıyamassınız.", lenght = 6000})
                end
            else
                TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Otel odanızda bu kadar eşya yok!.", lenght = 6000})
            end
        elseif Config.itemsystem == "weight" then
            local motelitem = UTK[motelId].rooms[roomId].data.getItem(name)

            if motelitem.count >= count then
                if xPlayer.canCarryItem(name, count) then
                    xPlayer.addInventoryItem(name, count)
                    UTK[motelId].rooms[roomId].data.removeItem(name, count)
                else
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Bu eşyadan daha fazla taşıyamassınız.", lenght = 6000})
                end
            else
                TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Otel odanızda bu kadar eşya yok!", lenght = 6000})
            end
        end
    elseif type == "item_weapon" then
        if Config.itemsystem == "limit" then
            local motelweapon = UTK[motelId].rooms[roomId].data.getWeapon(name)

            if motelweapon.ammo >= count then
                xPlayer.addWeapon(name, motelweapon.ammo)
                UTK[motelId].rooms[roomId].data.removeWeapon(name, motelweapon.ammo)
            else
                TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Otel odanızda bu kadar mühimmat yok!", lenght = 6000})
            end
        elseif Config.itemsystem == "weight" then
            local wep = xPlayer.hasWeapon(name)
            local motelweapon = UTK[motelId].rooms[roomId].data.getWeapon(name)

            if wep then
                if motelweapon.ammo >= count then
                    xPlayer.addWeapon(name, motelweapon.ammo)
                    UTK[motelId].rooms[roomId].data.removeWeapon(name, motelweapon.ammo)
                else
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Otel odanızda bu kadar mühimmat yok!", lenght = 6000})
                end
            elseif not wep then
                if xPlayer.canCarryItem(name, 1) then
                    xPlayer.addWeapon(name, motelweapon.ammo)
                    UTK[motelId].rooms[roomId].data.removeWeapon(name, motelweapon.ammo)
                else
                    TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Bu silahı taşıyamassınız", lenght = 6000})
                end
            end
        end
    elseif type == "item_account" then
        if UTK[motelId].rooms[roomId].data.blackmoney >= UTK[motelId].rooms[roomId].data.blackmoney - count then
            xPlayer.addAccountMoney("black_money", count)
            UTK[motelId].rooms[roomId].data.removeBlack(count)
        else
            TriggerClientEvent("mythic_notify:client:SendAlert", xPlayer.source, {type = "error", text = "Otel odanızda bu kadar eşya yok!", lenght = 6000})
        end
    end
end)

RegisterServerEvent("utk_motels:emptyRoomInventory")
AddEventHandler("utk_motels:emptyRoomInventory", function(motelId, roomId)
    UTK[motelId].rooms[roomId].data.clearInv()
    TriggerClientEvent("esx_inventoryhud:utkcheck", -1, motelId, roomId)
end)

function GetItemWeight(name)
    for i = 1, #ItemData, 1 do
        if name == ItemData[i].name then
            return ItemData[i].weight
        end
    end
end

function GetItemInfo(name)
    for i = 1, #ItemData, 1 do
        if name == ItemData[i].name then
            return ItemData[i]
        end
    end
end