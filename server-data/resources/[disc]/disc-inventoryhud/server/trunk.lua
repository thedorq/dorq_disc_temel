Citizen.CreateThread(function()
    for k,v in pairs(Config.VehicleSlot) do
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = 'trunk-' .. k,
            label = 'Bagaj',
            slots = 5,
            weight = 10
        })
    end
end)