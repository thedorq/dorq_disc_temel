Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'stash',
        label = 'Depo',
        slots = 100
    })
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'motel',
        label = 'Dolap',
        slots = 80
    })
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'motelbed',
        label = 'Yatak Altı',
        slots = 80
    })
end)
Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'cekmece',
        label = "Dolap",
        slots = 40
    })
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'yatak',
        label = "Yatak Altı",
        slots = 40
    })
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'hope',
        label = 'Ev Deposu',
        slots = 80
    })
end)