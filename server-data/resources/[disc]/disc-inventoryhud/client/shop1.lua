local shopSecondaryInventory = {
    type = 'shop',
    owner = ''
}

Citizen.CreateThread(function()
    for k, v in pairs(Config.Shops) do
        if v.enableBlip then
            for val, coords in pairs(v.coords) do
                local blip = {
                    name = k,
                    coords = coords,
                    colour = v.blipColour or 2,
                    sprite = v.blipSprite or 52
                }
                TriggerEvent('disc-base:registerBlip', blip)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end
    for k, v in pairs(Config.Shops) do
        for val, coords in pairs(v.coords) do
            local marker = {
                name = k .. val,
                coords = coords,
                type = v.markerType or 1,
                colour = v.markerColour or { r = 55, b = 255, g = 55 },
                size = v.size or vector3(1.0, 1.0, 1.0),
                action = function()
                    shopSecondaryInventory.owner = k
                    openInventory(shopSecondaryInventory)
                    TriggerScreenblurFadeIn(0)
                end,
                shouldDraw = function()
                    return ESX.PlayerData.job.name == v.job or v.job == 'all'
                end,
                msg = v.msg or _U('keyshop'),
            }
            TriggerEvent('disc-base:registerMarker', marker)
        end
    end
end)

Citizen.CreateThread(function()
    
    for i=1, #Config.Map, 1 do
        
        local blip = AddBlipForCoord(Config.Map[i].x, Config.Map[i].y, Config.Map[i].z)
        SetBlipSprite (blip, Config.Map[i].id)
        SetBlipScale  (blip, 0.7)
        SetBlipDisplay(blip, 4)
        SetBlipColour (blip, Config.Map[i].color)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Map[i].name)
        EndTextCommandSetBlipName(blip)
    end
end)
