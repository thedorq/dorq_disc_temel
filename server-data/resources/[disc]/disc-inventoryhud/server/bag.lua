ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterUsableItem('bag', function(source)
	TriggerClientEvent('disc-inventoryhud:canta', source)
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'canta',
        label = 'Çanta',
        slots = 20,
		weight = 25
    })
end)

RegisterCommand('cantakullan', function(source)
    local _source = source
    TriggerClientEvent('disc-inventoryhud:baggiy', _source)
    TriggerClientEvent('disc-inventoryhud:refreshInventory', _source)
end)
