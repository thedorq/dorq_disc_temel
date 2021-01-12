local impendingRemovals = {}
local impendingAdditions = {}
agirlik123 = 25


ESX.RegisterServerCallback('disc-inventoryhud:getPlayerInventory', function(source, cb)
    getPlayerDisplayInventory(ESX.GetPlayerFromId(source).identifier, cb)
end)
RegisterServerEvent('disc-inventoryhud:bag')
AddEventHandler('disc-inventoryhud:bag', function(_source)
	local source = _source
    agirlik123 = 30
	TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'player',
        label = _U('player'),
        slots = 50,
		weight = agirlik123,
        getInventory = function(identifier, cb)
            getInventory(identifier, 'player', cb)
        end,
        saveInventory = function(identifier, inventory)
            saveInventory(identifier, 'player', inventory)
        end
    })
end)

function getPlayerDisplayInventory(identifier, cb)
    local player = ESX.GetPlayerFromIdentifier(identifier)
	local envAgirlik = player.getWeight()
    getInventory(identifier, 'player', function(inventory)
        local itemsObject = {}

        for k, v in pairs(inventory) do
            local esxItem = player.getInventoryItem(v.name)
            local item = createDisplayItem(v, esxItem, tonumber(k))
            table.insert(itemsObject, item)
        end
		
		
        local inv = {
            invId = identifier,
            invTier = InvType['player'],
            inventory = itemsObject,
			agirlik = envAgirlik,
			LisansKon = LisansKontrol,
            cash = player.getMoney(),
            bank = player.getAccount('bank').money,
            black_money = player.getAccount('black_money').money,
        }
        cb(inv)
    end)
end

function ensurePlayerInventory(player)
    deleteInventory(player.identifier, 'player')
    Citizen.Wait(1000)
    loadInventory(player.identifier, 'player', function()
        applyToInventory(player.identifier, 'player', function(inventory)
            for _, esxItem in pairs(player.getInventory()) do
                if esxItem.count > 0 then
                    print('Adding ' .. esxItem.name .. ' ' .. esxItem.count)
                    local item = createItem(esxItem.name, esxItem.count)
                    addToInventory(item, 'player', inventory)
                end
            end
            TriggerClientEvent('disc-inventoryhud:refreshInventory', player.source)
        end)
    end)
end

RegisterServerEvent('disc-inventoryhud:notifyImpendingRemoval')
AddEventHandler('disc-inventoryhud:notifyImpendingRemoval', function(item, count, playerSource)
    local _source = playerSource or source
    if impendingRemovals[_source] == nil then
        impendingRemovals[_source] = {}
    end
    item.count = count
    local k = #impendingRemovals + 1
    impendingRemovals[_source][k] = item
    Citizen.CreateThread(function()
        Citizen.Wait(100)
        impendingRemovals[k] = nil
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    itemQlist = Config.ItemDurabilityList
end)


RegisterServerEvent('disc-inventoryhud:lowPercS')
AddEventHandler('disc-inventoryhud:lowPercS', function()
    for k, v in pairs(Config.DurabilityInvs) do
        local loopv2 = MySQL.Sync.fetchAll("SELECT * FROM disc_inventory WHERE disc_inventory.type = @type ", {
            ['@type'] = v.name
        })
        local loopv1 = MySQL.Sync.fetchAll("SELECT COUNT(*) AS ToplamDeger FROM disc_inventory WHERE disc_inventory.type = @type ", {
            ['@type'] = v.name
        })
        local maxl = loopv1[1].ToplamDeger
        for i2 = 1, maxl, 1 do
            local ow = loopv2[i2].owner
            local invt = loopv2[i2].type
            InvType[invt].getInventory(ow, function(inventory)
                for i = 1, 100, 1 do
                    local item = inventory[tostring(i)]
                    if item then
                        if itemQlist[item.name] ~= nil then
                            local originInvHandler = InvType[invt]
                            local itemQualty = inventory[tostring(i)].quality
                            if itemQualty > 0 then
                                originInvHandler.applyToInventory(ow, function(inventory2)
                                    inventory2[tostring(i)].quality = inventory2[tostring(i)].quality - itemQlist[item.name].outdated
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)


function getCustomD(itemn)
    local getitem = MySQL.Sync.fetchAll("SELECT * FROM items WHERE items.name =@name", {
        ['@name'] = itemn
    })
    return getitem[1].durability
end

RegisterServerEvent('disc-inventoryhud:notifyImpendingAddition')
AddEventHandler('disc-inventoryhud:notifyImpendingAddition', function(item, count, playerSource)
    local _source = playerSource or source
    if impendingAdditions[_source] == nil then
        impendingAdditions[_source] = {}
    end
    item.count = count
    local k = #impendingAdditions + 1
    impendingAdditions[_source][k] = item
    Citizen.CreateThread(function()
        Citizen.Wait(100)
        impendingAdditions[k] = nil
    end)
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
    local player = ESX.GetPlayerFromId(source)
    TriggerClientEvent('disc-inventoryhud:showItemUse', source, {
        { id = item.name, label = item.label, qty = count, msg = _U('removed') }
    })
    applyToInventory(player.identifier, 'player', function(inventory)
        if impendingRemovals[source] then
            for k, removingItem in pairs(impendingRemovals[source]) do
                if removingItem.id == item.name and removingItem.count == count then
                    if removingItem.block then
                        impendingRemovals[source][k] = nil
                    else
                        removeItemFromSlot(inventory, removingItem.slot, count)
                        impendingRemovals[source][k] = nil
                        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
                    end
                    return
                end
            end
        end
        removeItemFromInventory(item, count, inventory)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
    end)
end)

AddEventHandler('esx:onAddInventoryItem', function(source, esxItem, count)
    local player = ESX.GetPlayerFromId(source)
    TriggerClientEvent('disc-inventoryhud:showItemUse', source, {
        { id = esxItem.name, label = esxItem.label, qty = count, msg = _U('added') }
    })
    applyToInventory(player.identifier, 'player', function(inventory)
        if impendingAdditions[source] then
            for k, addingItem in pairs(impendingAdditions[source]) do
                if addingItem.id == esxItem.name and addingItem.count == count then
                    if addingItem.block then
                        impendingAdditions[source][k] = nil
                        return
                    end
                end
            end
        end
        local item = createItem(esxItem.name, count)
        addToInventory(item, 'player', inventory, esxItem.limit)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
    end)
end)