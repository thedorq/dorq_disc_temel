UTK = nil
ESX = nil
OwnedKeys = nil
RoomMateData = nil
PlayerData = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local receptionOpen = false
local currentfloor = nil

RegisterNetEvent("utk_motels:sendUTK")
AddEventHandler("utk_motels:sendUTK", function(data, player)
    UTK = data
    PlayerData = player
end)

RegisterNetEvent("utk_motels:sendData")
AddEventHandler("utk_motels:sendData", function(utk, keys, roomMate, player)
    UTK = utk
    OwnedKeys = keys
    RoomMateData = roomMate
    PlayerData = player
end)

RegisterNetEvent("utk_motels:updateDebt")
AddEventHandler("utk_motels:updateDebt", function(motelId, amount)
    UTK[motelId].info.debt = amount
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    PlayerData.job = job
end)

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100)
    end
    while UTK == nil or PlayerData == nil do
        Citizen.Wait(1000)
    end
    StartBlocksChecks()
    BuildBlips()
    if Config.ownership then
        StartOwnerChecks()
        Citizen.CreateThread(function()
            while PlayerData.job == nil do
                PlayerData.job = ESX.GetPlayerData().job
                Citizen.Wait(100)
            end
            if PlayerData.job.name == "police" then
                StartDebtCheck()
            end
        end)
    elseif not Config.ownership then
        StartMenuChecks()
    end
    if not Config.performancemode then
        StartMarkersCheck()
    end
    if #Config.elevators > 0 then
        StartElevatorsCheck()
    end
end)

function StartBlocksChecks()
    Citizen.CreateThread(function()
        while true do
            for i = 1, #UTK, 1 do
                local playercoords = GetEntityCoords(PlayerPedId())

                if GetDistanceBetweenCoords(playercoords, UTK[i].info.coords, false) <= 95.0 then
                    for j = 1, #UTK[i].rooms, 1 do
                        if UTK[i].rooms[j].obj == nil or not DoesEntityExist(UTK[i].rooms[j].obj) then
                            UTK[i].rooms[j].obj = GetClosestObjectOfType(UTK[i].rooms[j].door, 1.2, UTK[i].info.doorhash, false, false, false)
                            FreezeEntityPosition(UTK[i].rooms[j].obj, UTK[i].rooms[j].locked)
                        else
                            FreezeEntityPosition(UTK[i].rooms[j].obj, UTK[i].rooms[j].locked)
                            if UTK[i].rooms[j].locked then
                                SetEntityHeading(UTK[i].rooms[j].obj, UTK[i].rooms[j].h)
                            end
                        end
                        Citizen.Wait(1)
                    end
                end
                Citizen.Wait(100)
            end
        end
    end)
end

function BuildBlips()
    for i = 1, #UTK, 1 do
        if UTK[i].info.showblip then
            local b = AddBlipForCoord(UTK[i].info.coords)
            SetBlipSprite(b, UTK[i].info.sprite)
            SetBlipColour(b, UTK[i].info.color)
            SetBlipScale(b,0.75)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(UTK[i].info.name)
            EndTextCommandSetBlipName(b)
            SetBlipAsShortRange(b, true)
        end
    end
end

function StartOwnerChecks()
    for i = 1, #UTK, 1 do
        if UTK[i].info.owner == PlayerData.identifier then
            Citizen.CreateThread(function()
                local motelId = i

                while true do
                    local pedcoords = GetEntityCoords(PlayerPedId())
                    local dst = GetDistanceBetweenCoords(pedcoords, UTK[motelId].info.reception.x, UTK[motelId].info.reception.y, UTK[motelId].info.reception.z, true)

                    if  dst <= 10.0 and not receptionOpen then
                        DrawText3D(UTK[motelId].info.reception.x, UTK[motelId].info.reception.y, UTK[motelId].info.reception.z, "[~r~E~w~] Resepsiyon", 0.40)
                        DrawMarker(1, UTK[motelId].info.reception.x, UTK[motelId].info.reception.y, UTK[motelId].info.reception.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 236, 236, 80, 155, false, false, 2, false, 0, 0, 0, 0)
                        if dst <= 1.0 and IsControlJustReleased(0, 38) then
                            OpenReception(motelId)
                        end
                        Citizen.Wait(1)
                    else
                        Citizen.Wait(1000)
                    end
                end
            end)
            return
        end
    end
end

function StartMenuChecks()
    Citizen.CreateThread(function()
        while true do
            if not receptionOpen then
                local pedcoords = GetEntityCoords(PlayerPedId())

                for i = 1, #UTK, 1 do
                    if GetDistanceBetweenCoords(UTK[i].info.reception.x, UTK[i].info.reception.y, UTK[i].info.reception.z, pedcoords, true) <= 10.0 then
                        DrawText3D(UTK[i].info.reception.x, UTK[i].info.reception.y, UTK[i].info.reception.z, "[~r~E~w~] Resepsiyon", 0.40)
                        DrawMarker(1, UTK[i].info.reception.x, UTK[i].info.reception.y, UTK[i].info.reception.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 236, 236, 80, 155, false, false, 2, false, 0, 0, 0, 0)
                        if GetDistanceBetweenCoords(UTK[i].info.reception.x, UTK[i].info.reception.y, UTK[i].info.reception.z, pedcoords, true) <= 1.0 and IsControlJustReleased(0, 38) then
                            OpenAutonomous(i)
                        end
                    end
                end
                Citizen.Wait(1)
            else
                Citizen.Wait(1000)
            end
        end
    end)
end

function StartMarkersCheck()
    Citizen.CreateThread(function()
        while true do
            local pedcoords = GetEntityCoords(PlayerPedId())

            for i = 1, #OwnedKeys, 1 do
                if GetDistanceBetweenCoords(pedcoords, UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash, true) <= 4.5 then
                    DrawText3D(UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash[1], UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash[2], UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].stash[3], "~r~Esya Dolabı", 0.40)
                    DrawText3D(UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].clothe[1], UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].clothe[2], UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].clothe[3], "~r~Kıyafet Dolabı", 0.40)
                elseif GetDistanceBetweenCoords(pedcoords, UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].door, true) <= 6.5 then
                    DrawMarker(2, UTK[OwnedKeys[i].motelId].rooms[OwnedKeys[i].roomId].door, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 236, 80, 80, 155, false, true, 2, false, 0, 0, 0, 0)
                end
            end
            Citizen.Wait(1)
        end
    end)
    if Config.roommate then
        Citizen.CreateThread(function()
            while true do
                if #RoomMateData ~= 0 then
                    local pedcoords = GetEntityCoords(PlayerPedId())

                    for i = 1, #RoomMateData, 1 do
                        if GetDistanceBetweenCoords(pedcoords, UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].stash, true) <= 4.5 then
                            DrawText3D(UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].stash[1], UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].stash[2], UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].stash[3], "~r~Esya Dolabı", 0.40)
                            DrawText3D(UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].clothe[1], UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].clothe[2], UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].clothe[3], "~r~Kıyafet Dolabı", 0.40)
                        elseif GetDistanceBetweenCoords(pedcoords, UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].door, true) <= 6.5 then
                            DrawMarker(2, UTK[RoomMateData[i].motelId].rooms[RoomMateData[i].roomId].door, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 236, 80, 80, 155, false, true, 2, false, 0, 0, 0, 0)
                        end
                    end
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1000)
                end
            end
        end)
    end
end

function StartElevatorsCheck()
    Citizen.CreateThread(function()
        while true do
            local pedcoords = GetEntityCoords(PlayerPedId())

            for i = 1, #Config.elevators, 1 do
                if GetDistanceBetweenCoords(Config.elevators[i][1].x, Config.elevators[i][1].y, Config.elevators[i][1].z, pedcoords, false) <= 50.0 then
                    if currentfloor == nil then
                        for f = 1, #Config.elevators[i], 1 do
                            if GetDistanceBetweenCoords(Config.elevators[i][f].x, Config.elevators[i][f].y, Config.elevators[i][f].z, pedcoords, true) <= 3.0 then
                                DrawText3D(Config.elevators[i][f].x, Config.elevators[i][f].y, Config.elevators[i][f].z, "[~r~E~w~] Elevator-"..f, 0.40)
                                DrawMarker(1, Config.elevators[i][f].x, Config.elevators[i][f].y, Config.elevators[i][f].z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 236, 236, 80, 155, false, false, 2, false, 0, 0, 0, 0)
                                if GetDistanceBetweenCoords(Config.elevators[i][f].x, Config.elevators[i][f].y, Config.elevators[i][f].z, pedcoords, true) <= 1.0 and IsControlJustReleased(0, 38) then
                                    OpenElevator(i, f)
                                end
                            end
                        end
                    else
                        if GetDistanceBetweenCoords(Config.elevators[i][currentfloor].x, Config.elevators[i][currentfloor].y, Config.elevators[i][currentfloor].z, pedcoords, true) <= 3.0 then
                            DrawText3D(Config.elevators[i][currentfloor].x, Config.elevators[i][currentfloor].y, Config.elevators[i][currentfloor].z, "[~r~E~w~] Asansor-"..currentfloor, 0.40)
                            DrawMarker(1, Config.elevators[i][currentfloor].x, Config.elevators[i][currentfloor].y, Config.elevators[i][currentfloor].z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 236, 236, 80, 155, false, false, 2, false, 0, 0, 0, 0)
                            if GetDistanceBetweenCoords(Config.elevators[i][currentfloor].x, Config.elevators[i][currentfloor].y, Config.elevators[i][currentfloor].z, pedcoords, true) <= 1.0 and IsControlJustReleased(0, 38) then
                                OpenElevator(i, currentfloor)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(1)
        end
    end)
end

function StartDebtCheck()
    Citizen.CreateThread(function()
        while PlayerData.job.name == "police" do
            Citizen.Wait(1800000) -- 30 mins
            for i = 1, #UTK, 1 do
                if UTK[i].info.debt >= Config.debtwarning then
                    exports.mythic_notify:SendAlert("error", UTK[i].info.name.." has "..UTK[i].info.debt.."$ debt to pay!", 8000)
                    Citizen.Wait(500)
                end
            end
        end
    end)
end

function F_02537(arg1, arg2, arg3)
    AddTextEntry('FMMC_KEY_TIP1', arg1)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", arg2, "", "", "", arg3)
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		return result
	else
		Citizen.Wait(500)
		return nil
	end
end

function OpenReception(motelId)
    receptionOpen = true
    Citizen.CreateThread(function()
        while receptionOpen do
            DisableControl()
            Citizen.Wait(1)
        end
    end)
    ESX.TriggerServerCallback("utk_motels:getReceptionInfos", function(cdata)
        ESX.UI.Menu.CloseAll()
        local firstel =  {
            {label = "Toplam oda: "..#UTK[motelId].rooms, value = "aa"},
            {label = "Yönet", value = "manage"},
            {label = "Oda kirala", value = "rent"},
            {label = "Boş oda envanteri", value = "emptyRoom"},
        }

        if Config.ownership then
            table.insert(firstel, {label = "Current Debt: "..UTK[motelId].info.debt, value = "debt"})
        end

        ESX.UI.Menu.Open("default", "utk_motels", "reception", {
            title = UTK[motelId].info.name.."'s Reception",
            align = "top-left",
            elements = firstel
        }, function(data, menu)
            if data.current.value == "manage" then
                local el = {}
                for i = 1, #cdata.full, 1 do
                    table.insert(el, {label = "Oda-"..cdata.full[i].roomId.." | Kiracı: "..cdata.full[i].holdername, id = cdata.full[i].roomId, holder = cdata.full[i].holder, phone = cdata.full[i].phone})
                end
                ESX.UI.Menu.Open("default", "utk_motels", "manage-motel", {
                    title = "Toplam oda: "..#cdata.full,
                    align = "top-left",
                    elements = el
                }, function(data2, menu2)
                    local selection = data2.current
                    if selection.id ~= nil then
                        ESX.UI.Menu.Open("default", "utk_motels", "room-info", {
                            title = "Kiracı Yönetimi",
                            align = "top-left",
                            elements = {
                                {label = "Telefon numarası: "..selection.phone, value = "info"},
                                {label = "Anahtar değiştir", value = "change"},
                                {label = "Mesaj yolla", value = "notify"}
                            }
                        }, function(data3, menu3)
                            if data3.current.value == "change" then
                                TriggerServerEvent("utk_motels:clearKey", selection.holder, motelId, selection.id)
                                OpenReception(motelId)
                            elseif data3.current.value == "notify" then
                                local text = F_02537("Message:", "", 100)

                                if text == nil or text:len() <= 10 then
                                    exports.mythic_notify:SendAlert("error", "Bu kadar kısa mesaj yollayamazsın!", 6000)
                                    menu3.close()
                                    return
                                end
                                text = text.." -"..UTK[motelId].info.name
                                TriggerServerEvent("utk_motels:rentNotify", selection.holder, text)
                                menu3.close()
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            elseif data.current.value == "rent" then
                local el = {}
                for i = 1, #cdata.empty, 1 do
                    table.insert(el, {label = "Oda-"..cdata.empty[i].roomId, value = cdata.empty[i].roomId})
                end
                ESX.UI.Menu.Open("default", "utk_motels", "rent-menu", {
                    title = "Toplam boş oda: "..#cdata.empty,
                    align = "top-left",
                    elements = el
                }, function(data2, menu2)
                    local selection = data2.current

                    if selection.value ~= nil then
                        local nearbyplayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 4.0)
                        local players = {}
                        for p = 1, #nearbyplayers, 1 do
                            if nearbyplayers[p] ~= PlayerId() then
                                table.insert(players, {id = GetPlayerServerId(nearbyplayers[p])})
                            end
                        end
                        if #players >= 1 then
                            ESX.TriggerServerCallback("utk_motels:nearbyNames", function(result)
                                ESX.UI.Menu.Open("default", "utk_motels", "rent-players", {
                                    title = "Yakındaki oyuncular",
                                    align = "top-left",
                                    elements = result
                                }, function(data3, menu3)
                                    if data3.current.id ~= nil then
                                        ESX.UI.Menu.Open("default", "utk_motels", "rent-sure", {
                                            title = "Emin misin?",
                                            align = "top-left",
                                            elements = {{label = "Evet", value = true}, {label = "Hayır", value = false}}
                                        }, function(data4, menu4)
                                            if data4.current.value then
                                                TriggerServerEvent("utk_motels:rentRoom", motelId, selection.value, data3.current.id)
                                                receptionOpen = false
                                                ESX.UI.Menu.CloseAll()
                                            elseif not data4.current.value then
                                                menu4.close()
                                                menu3.close()
                                            end
                                        end, function(data4, menu4)
                                            menu4.close()
                                        end)
                                    end
                                end, function(data3, menu3)
                                    menu3.close()
                                end)
                            end, players)
                        else
                            exports.mythic_notify:SendAlert("error", "Yakınında kimse yok.", 6000)
                        end
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            elseif data.current.value == "emptyRoom" then
                local el = {}
                for i = 1, #cdata.empty, 1 do
                    table.insert(el, {label = "Oda-"..cdata.empty[i].roomId, value = cdata.empty[i].roomId})
                end
                ESX.UI.Menu.Open("default", "utk_motels", "rent-menu", {
                    title = "Toplam boş oda: "..#cdata.empty,
                    align = "top-left",
                    elements = el
                }, function(data2, menu2)
                    if data2.current.value ~= nil then
                        ESX.UI.Menu.Open("default", "utk_motels", "rent-sure", {
                            title = "Emin misin?",
                            align = "top-left",
                            elements = {{label = "Evet", value = true}, {label = "Hayır", value = false}}
                        }, function(data3, menu3)
                            if data3.current.value then
                                TriggerServerEvent("utk_motels:emptyRoomInventory", motelId, data2.current.value)
                                menu3.close()
                            elseif not data3.current.value then
                                menu3.close()
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            elseif data.current.value == "debt" then
                local el = {}
                if UTK[motelId].info.auto_pay then
                    table.insert(el, {label = "Otomatik ödeme: açık", value = "toggle-auto"})
                else
                    table.insert(el, {label = "Otomatik ödeme: kapalı", value = "toggle-auto"})
                end
                if UTK[motelId].info.debt >= 0 then
                    table.insert(el, {label = "Borç mde", value = "pay-debt"})
                end
                ESX.UI.Menu.Open("default", "utk_motels", "debt-menu", {
                    title = "Toplam borç: "..UTK[motelId].info.debt,
                    align = "top-left",
                    elements = el
                }, function(data2, menu2)
                    if data2.current.value == "toggle-auto" then
                        menu2.close()
                        UTK[motelId].info.auto_pay = not UTK[motelId].info.auto_pay
                        TriggerServerEvent("utk_motels:toggleAutoPay", motelId, UTK[motelId].info.auto_pay)
                    elseif data2.current.value == "pay-debt" then
                        local amount = F_02537("Amount", "", 10)

                        if tonumber(amount) ~= nil then
                            if tonumber(amount) <= UTK[motelId].info.debt then
                                ESX.TriggerServerCallback("utk_motels:payDebt", function(result)
                                    if result == true then
                                        ESX.UI.Menu.CloseAll()
                                        exports.mythic_notify:SendAlert("success", "Otel ödemesi gerçekleşti "..amount.."$ ücret çekildi!", 5000)
                                        Citizen.Wait(1000)
                                        OpenReception(motelId)
                                    else
                                        menu2.close()
                                        exports.mythic_notify:SendAlert("error", "Yeterince paran yok!", 5000)
                                    end
                                end, motelId, tonumber(amount))
                            else
                                menu2.close()
                                exports.mythic_notify:SendAlert("error", "Daha fazla ödeme yapamazsın!", 5000)
                            end
                        else
                            menu2.close()
                            exports.mythic_notify:SendAlert("error", "Geçersiz tip!", 5000)
                        end
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end
        end, function(data, menu)
            menu.close()
            receptionOpen = false
        end)
    end, motelId)
end

function OpenAutonomous(motelId)
    receptionOpen = true
    Citizen.CreateThread(function()
        while receptionOpen do
            DisableControl()
            Citizen.Wait(1)
        end
    end)
    local elements = {}
    local hasRoom = false
    for i = 1, #OwnedKeys, 1 do
        if OwnedKeys[i].motelId == motelId then
            hasRoom = true
            break
        end
    end

    if not hasRoom then
        elements = {{label = "Oda kirala", value = 1}}
    elseif hasRoom then
        elements = {{label = "Kiralamayı bırak", value = 2}}
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open("default", "utk_motels", "motel-menu", {
        title = "Motel Menu",
        align = "top-left",
        elements = elements
    }, function(data, menu)
        if data.current.value == 1 then
            RentRoom(motelId)
        elseif data.current.value == 2 then
            UnRentRoom(motelId)
        end
    end, function(data, menu)
        receptionOpen = false
        menu.close()
    end)
end

function RentRoom(motelId)
    ESX.TriggerServerCallback("utk_motels:getEmptyRoom", function(result)
        if result ~= false then
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open("default", "utk_motels", "rent-unrent", {
                title = "Boş oda",
                align = "top-left",
                elements = result
            }, function(data, menu)
                local s = data.current
                if s.roomId ~= nil then
                    ESX.UI.Menu.Open("default", "utk_motels", "rent-sure", {
                        title = "Emin misin?",
                        align = "top-left",
                        elements = {{label = "Evet", value = true}, {label = "Hayır", value = false}}
                    }, function(data2, menu2)
                        if data2.current.value == true then
                            ESX.UI.Menu.CloseAll()
                            receptionOpen = false
                            TriggerServerEvent("utk_motels:rentRoom", s.motelId, s.roomId)
                        else
                            menu2.close()
                        end
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end
            end, function(data, menu)
                receptionOpen = false
                menu.close()
            end)
        elseif not result then
            exports.mythic_notify:SendAlert("error", "Bu oda boş değil "..UTK[motelId].info.name..".", 6000)
        end
    end, motelId)
end

function UnRentRoom(motelId)
    local el = {}
    for i = 1, #OwnedKeys, 1 do
        if OwnedKeys[i].motelId == motelId then
            table.insert(el, {label = "Oda-"..OwnedKeys[i].roomId, motelId = motelId, roomId = OwnedKeys[i].roomId})
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open("default", "utk_motels", "unrent-room", {
        title = "Senin odaların",
        align = "top-left",
        elements = el
    }, function(data, menu)
        local s = data.current
        if s.roomId ~= nil then
            ESX.UI.Menu.Open("default", "utk_motels", "unrent-sure", {
                title = "Emin misin ?",
                align = "top-left",
                elements = {{label = "Evet", value = true}, {label = "Hayır", value = false}}
            }, function(data2, menu2)
                if data2.current.value == true then
                    ESX.UI.Menu.CloseAll()
                    receptionOpen = false
                    TriggerServerEvent("utk_motels:clearKey", false, s.motelId, s.roomId)
                else
                    menu2.close()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end
    end, function(data, menu)
        receptionOpen = false
        menu.close()
    end)
end

function ToggleDoor(motelId, roomId)
    RequestAnimDict("anim@heists@keycard@")
    while not HasAnimDictLoaded("anim@heists@keycard@") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()

    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
    Citizen.Wait(1000)
    ClearPedTasks(ped)
    TriggerServerEvent("utk_motels:toggleDoor", motelId, roomId, not UTK[motelId].rooms[roomId].locked)
end

function ToggleStash(motelId, roomId)
    RequestAnimDict("anim@heists@keycard@")
    while not HasAnimDictLoaded("anim@heists@keycard@") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()

    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
    Citizen.Wait(1000)
    ClearPedTasks(ped)
    TriggerServerEvent("utk_motels:toggleStash", motelId, roomId, not UTK[motelId].rooms[roomId].locked2)
end

function OpenStash(motelId, roomId)
    local roomOwner = ESX.GetPlayerData().identifier
    TriggerServerEvent("utk_motes:setInventoryBusy", motelId, roomId)
    if Config.inventorysystem == "esx" then
        ESX.TriggerServerCallback("utk_motels:getRoomInventory", function(data)
            TriggerEvent("esx_inventoryhud:openMotelsInventory", data, motelId, roomId)
        end, motelId, roomId)
    elseif Config.inventorysystem == "disc" then
        TriggerEvent('disc-inventoryhud:openInventory', {
            type = 'yatak',
            owner = roomOwner, -- olmassa playerIdent deneyin.
            slots = 50,
            })
    end
end

function OpenWardrobe(motelId, roomId)
    receptionOpen = true
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback("utk_motels:getWardrobe", function(result)
        local el = {}
        for i = 1, #result, 1 do
            table.insert(el, {label = result[i].label, value = json.decode(result[i].skin), index = i})
        end
        ESX.UI.Menu.Open("default", "utk_motels", "wardrobe", {
            title = "Oda-"..roomId.." Wardrobe",
            align = "top-left",
            elements = {
                {label = "Kayıtlı Kıyafetler", value = 1},
                {label = "Şuanki kıyafeti kaydet", value = 2}
            }
        }, function(data, menu)
            if data.current.value == 1 then
                if #el == 0 then
                    exports.mythic_notify:SendAlert("error", "Wardorbe is empty!", 4000)
                else
                    ESX.UI.Menu.Open("default", "utk_motels", "owned_outfits", {
                        title = "Outfits",
                        align = "top-left",
                        elements = el
                    }, function(data2, menu2)
                        if data2.current.value ~= nil then
                            ESX.UI.Menu.Open("default", "utk_motels", "outfit", {
                                title = "Outfit: "..data2.current.label,
                                align = "top-left",
                                elements = {
                                    {label = "Wear outfit", value = 1},
                                    {label = "Kıyafeti At/Sil", value = 2}
                                }
                            }, function(data3, menu3)
                                if data3.current.value == 1 then
                                    TriggerEvent('skinchanger:loadSkin', data2.current.value)
                                    ESX.UI.Menu.CloseAll()
                                    receptionOpen = false
                                elseif data3.current.value == 2 then
                                    ESX.UI.Menu.Open("default", "utk_motels", "delete-outfit", {
                                        title = "Eminmisin?",
                                        align = "top-left",
                                        elements = {{label = "Evet", value = true}, {label = "Hayır", value = false}}
                                    }, function(data4, menu4)
                                        if data4.current.value == true then
                                            TriggerServerEvent("utk_motels:removeSkin", motelId, roomId, data2.current.index)
                                            ESX.UI.Menu.CloseAll()
                                            receptionOpen = false
                                        elseif not data4.current.value then
                                            menu4.close()
                                        end
                                    end, function(data4, menu4)
                                        menu4.close()
                                    end)
                                end
                            end, function(data3, menu3)
                                menu3.close()
                            end)
                        end
                    end, function(data2, menu2)
                        menu2.close()
                    end)
                end
            elseif data.current.value == 2 then
                if #el < Config.clothelimit then
                    local text = F_02537("Takım İsmi:", "", 30)
                    if text ~= nil then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent("utk_motels:saveSkin", motelId, roomId, text, skin)
                        end)
                    ESX.UI.Menu.CloseAll()
                    receptionOpen = false
                    else
                        exports.mythic_notify:SendAlert("error", "Takımına bir isim belirlemen gerekiyor!", 5000)
                    end
                else
                    exports.mythic_notify:SendAlert("error", "Dolabın ağzına kadar dolu!!", 5000)
                end
            end
        end, function(data, menu)
            menu.close()
            receptionOpen = false
        end)
    end, motelId, roomId)
end

function OpenElevator(i, f)
    local el = {}
    for a = 1, #Config.elevators[i], 1 do
        if a ~= f then
            table.insert(el, {label = "Floor-"..a, floor = a})
        end
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open("default", "utk_motels", "elevator", {
        title = "Elevator-"..f,
        align = "top-left",
        elements = el
    }, function(data, menu)
        if data.current.floor ~= nil then
            ESX.UI.Menu.CloseAll()
            Teleport(i, data.current.floor)
        end
    end, function(data, menu)
        menu.close()
    end)
end

function Teleport(i, f)
    currentfloor = f
    DoScreenFadeOut(500)
    Citizen.Wait(600)
    PlaySoundFrontend(-1, "OPENING", "MP_PROPERTIES_ELEVATOR_DOORS" , 1)
    SetEntityCoords(PlayerPedId(), Config.elevators[i][f].x, Config.elevators[i][f].y, Config.elevators[i][f].z, 1, 0, 0, 0)
    Citizen.Wait(200)
    DoScreenFadeIn(500)
end

function Lockpick(motelId, roomId)
    if Config.lockpick ~= nil then
        RequestAnimDict("mp_arresting")

        while not HasAnimDictLoaded("mp_arresting") do
            Citizen.Wait(10)
        end
        if LockpickChance() then
            TriggerServerEvent("utk_motels:useLockpick")
        end
        TriggerServerEvent("utk_motels:soundRequest", UTK[motelId].rooms[roomId].door, "lockpick")
        TaskPlayAnim(PlayerPedId(), "mp_arresting", "a_uncuff", 8.0, 8.0, 6000, 1, 1, 0, 0, 0)
        Citizen.Wait(6000)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent("utk_motels:toggleDoor", motelId, roomId, false)
    end
end

function LockpickChance()
    local rnd = math.random(100)

    if rnd >= Config.lockpick.breakchance then
        return true
    end
    return false
end

RegisterNetEvent("utk_motels:toggleDoor")
AddEventHandler("utk_motels:toggleDoor", function(motelId, roomId, state)
    UTK[motelId].rooms[roomId].locked = state
end)

RegisterNetEvent("utk_motels:toggleStash")
AddEventHandler("utk_motels:toggleStash", function(motelId, roomId, state)
    UTK[motelId].rooms[roomId].locked2 = state
end)

RegisterNetEvent("utk_motels:updateOwnedKeys")
AddEventHandler("utk_motels:updateOwnedKeys", function(motelId, roomId, action, roommate)
    if not action then
        for i = 1, #OwnedKeys, 1 do
            if OwnedKeys[i].motelId == motelId and OwnedKeys[i].roomId == roomId then
                table.remove(OwnedKeys, i)
                exports.mythic_notify:SendAlert("error", "Anahtarını teslim ettin.", 5000)
                break
            end
        end
    elseif action then
        table.insert(OwnedKeys, {motelId = motelId, roomId = roomId, roommate = roommate})
        exports.mythic_notify:SendAlert("success", UTK[motelId].info.name.." Oda-"..roomId.."'numaralı odanın anahtarını aldın.", 6500)
    end
end)

RegisterNetEvent("utk_motels:updateOwnedKeys-roommate")
AddEventHandler("utk_motels:updateOwnedKeys-roommate", function(motelId, roomId, action, roommate)
    if not action then
        for i = 1, #OwnedKeys, 1 do
            if OwnedKeys[i].motelId == motelId and OwnedKeys[i].roomId == roomId then
                OwnedKeys[i].roommate = nil
                exports.mythic_notify:SendAlert("error", "Artık oda arkadaşı değilsin-"..roomId.." in "..UTK[motelId].info.name..".", 5000)
                break
            end
        end
    elseif action then
        for i = 1, #OwnedKeys, 1 do
            if OwnedKeys[i].motelId == motelId and OwnedKeys[i].roomId == roomId then
                OwnedKeys[i].roommate = roommate
                exports.mythic_notify:SendAlert("success", "Artık oda arkadaşısın-"..roomId.." in "..UTK[motelId].info.name..".", 5000)
                break
            end
        end
    end
end)

RegisterNetEvent("utk_motels:updateRoommates")
AddEventHandler("utk_motels:updateRoommates", function(motelId, roomId, action)
    if not action then
        for i = 1, #RoomMateData, 1 do
            if RoomMateData[i].motelId == motelId then
                if RoomMateData[i].roomId == roomId then
                    table.remove(RoomMateData, i)
                    exports.mythic_notify:SendAlert("error", "Odadan atıldın-"..roomId.." in "..UTK[motelId].info.name..".", 8000)
                    break
                end
            end
        end
    elseif action then
        table.insert(RoomMateData, {motelId = motelId, roomId = roomId})
        exports.mythic_notify:SendAlert("success", "Artık senin oda arkadaşın-"..roomId.." in "..UTK[motelId].info.name..".", 6500)
    end
end)

RegisterNetEvent("utk_motels:useLockpick")
AddEventHandler("utk_motels:useLockpick", function()
    local pedcoords = GetEntityCoords(PlayerPedId())

    for motelId = 1, #UTK, 1 do
        if GetDistanceBetweenCoords(pedcoords, UTK[motelId].info.coords, true) <= 100.0 then
            for roomId = 1, #UTK[motelId].rooms, 1 do
                if GetDistanceBetweenCoords(pedcoords, UTK[motelId].rooms[roomId].door, true) <= 1.0 then
                    Lockpick(motelId, roomId)
                    return
                end
            end
        end
    end
end)

RegisterCommand(Config.keyscommand, function()
    if #OwnedKeys ~= 0 or #RoomMateData ~= 0 then
        local el = {}
        for i = 1, #OwnedKeys, 1 do
            table.insert(el, {label = UTK[OwnedKeys[i].motelId].info.name.." | Oda-"..OwnedKeys[i].roomId, owned = true, value = {m = OwnedKeys[i].motelId, r = OwnedKeys[i].roomId, mate = OwnedKeys[i].roommate}})
        end
        for m = 1, #RoomMateData, 1 do
            table.insert(el, {label = UTK[RoomMateData[m].motelId].info.name.." | Oda-"..RoomMateData[m].roomId, owned = false, value = {m = RoomMateData[m].motelId, r = RoomMateData[m].roomId, mate = nil}})
        end
        receptionOpen = false
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open("default", "utk_motels", "o-keys", {
            title = "Owned Keys",
            align = "top-left",
            elements = el
        }, function(data, menu)
            local firstel = {{label = "Mark location on GPS", value = "gps"}}

            if data.current.value ~= nil then
                if Config.roommate then
                    if data.current.owned == true then
                        table.insert(firstel, {label = "Oda arkadaşı ayarı", value = "roommate"})
                    else
                        table.insert(firstel, {label = "Anahtarları at", value = "throw"})
                    end
                end
                ESX.UI.Menu.Open("default", "utk_motels", "o-keys-2", {
                    title = UTK[data.current.value.m].info.name.." | Oda-"..data.current.value.r,
                    align = "top-left",
                    elements = firstel
                }, function(data2, menu2)
                    if data2.current.value == "gps" then
                        ESX.UI.Menu.CloseAll()
                        SetNewWaypoint(UTK[data.current.value.m].rooms[data.current.value.r].door[1], UTK[data.current.value.m].rooms[data.current.value.r].door[2])
                    elseif data2.current.value == "roommate" then
                        local el2

                        if data.current.value.mate ~= nil and data.current.value.mate ~= "" then
                            el2 = {{label = "Oda arkadaşını at", value = "kick"}}
                        else
                            el2 = {{label = "Yeni oda arkadaşı ayarla", value = "set"}}
                        end
                        ESX.UI.Menu.Open("default", "utk_motels", "manage-mate", {
                            title = "Manage Roommate",
                            align = "top-left",
                            elements = el2
                        }, function(data3, menu3)
                            if data3.current.value == "set" then
                                local nearbyplayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 4.0)

                                if #nearbyplayers >= 1 then
                                    local players = {}

                                    for p = 1, #nearbyplayers, 1 do
                                        if nearbyplayers[p] ~= PlayerId() then
                                            table.insert(players, {id = GetPlayerServerId(nearbyplayers[p])})
                                        end
                                    end
                                    ESX.TriggerServerCallback("utk_motels:nearbyNames", function(result)
                                        ESX.UI.Menu.Open("default", "utk_motels", "nearby-roommates", {
                                            title = "Yakındaki oyuncular",
                                            align = "top-left",
                                            elements = result
                                        }, function(data4, menu4)
                                            local player = data4.current

                                            if player.id ~= nil then
                                                ESX.UI.Menu.Open("default", "utk_motels", "set-sure", {
                                                    title = "Emin misin?",
                                                    align = "top-left",
                                                    elements = {{label = "Evet", value = true}, {label = "Hayır", value = false}}
                                                }, function(data5, menu5)
                                                    if data5.current.value == true then
                                                        ESX.UI.Menu.CloseAll()
                                                        TriggerServerEvent("utk_motels:setRoommate", data.current.value.m, data.current.value.r, player.id)
                                                    elseif data5.current.value == false then
                                                        menu4.close()
                                                        menu5.close()
                                                    end
                                                end, function(data5, menu5)
                                                    menu5.close()
                                                end)
                                            end
                                        end, function(data4, menu4)
                                            menu4.close()
                                        end)
                                    end, players)
                                else
                                    mythic_notify:SendAlert("error", "Yakında oyuncu yok.", 5000)
                                end
                            elseif data3.current.value == "kick" then
                                ESX.UI.Menu.Open("default", "utk_motels", "areyousure-kick", {
                                    title = "Are you sure?",
                                    align = "top-left",
                                    elements = {{label = "Yes", value = true}, {label = "No", value = false}}
                                }, function(data4, menu4)
                                    if data4.current.value == true then
                                        ESX.UI.Menu.CloseAll()
                                        TriggerServerEvent("utk_motels:removeRoommate", data.current.value.m, data.current.value.r)
                                    elseif not data4.current.value then
                                        menu4.close()
                                    end
                                end, function(data4, menu4)
                                    menu4.close()
                                end)
                            end
                        end, function(data3, menu3)
                            menu3.close()
                        end)
                    elseif data2.current.value == "throw" then
                        ESX.UI.Menu.CloseAll()
                        TriggerServerEvent("utk_motels:removeRoommate", data.current.value.m, data.current.value.r)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end
        end, function(data, menu)
            menu.close()
        end)
    else
        exports.mythic_notify:SendAlert("error", "Anahtarın yok.", 5000)
    end
end)

RegisterCommand(Config.doorlockcommand, function()
    if #OwnedKeys == 0 and #RoomMateData == 0 then
        exports.mythic_notify:SendAlert("error", "Anahtarın yok.", 4000)
        return
    end
    if #OwnedKeys > 0  then
        local pedcoords = GetEntityCoords(PlayerPedId())

        for i = 1, #OwnedKeys, 1 do
            local motelId, roomId = OwnedKeys[i].motelId, OwnedKeys[i].roomId

            if GetDistanceBetweenCoords(pedcoords, UTK[motelId].rooms[roomId].door, true) <= 1.2 then
                ToggleDoor(motelId, roomId)
                return
            end
        end
    end
    if Config.roommate then
        if #RoomMateData > 0 then
            local pedcoords = GetEntityCoords(PlayerPedId())

            for n = 1, #RoomMateData, 1 do
                local motelId, roomId = RoomMateData[n].motelId, RoomMateData[n].roomId

                if GetDistanceBetweenCoords(pedcoords, UTK[motelId].rooms[roomId].door, true) <= 1.2 then
                    ToggleDoor(motelId, roomId)
                    return
                end
            end
        end
    end
end)

RegisterCommand(Config.stashlockcommand, function()
    if #OwnedKeys == 0 and #RoomMateData == 0 then
        return
    end
    local pedcoords = GetEntityCoords(PlayerPedId())

    for i = 1, #OwnedKeys, 1 do
        local motelId, roomId = OwnedKeys[i].motelId, OwnedKeys[i].roomId
        if GetDistanceBetweenCoords(pedcoords, UTK[motelId].rooms[roomId].stash, true) <= 1.2 then
            ToggleStash(motelId, roomId)
            return
        end
    end
    if Config.roommate then
        for n = 1, #RoomMateData, 1 do
            local motelId, roomId = RoomMateData[n].motelId, RoomMateData[n].roomId
            if GetDistanceBetweenCoords(pedcoords, UTK[motelId].rooms[roomId].stash, true) <= 1.2 then
                ToggleStash(motelId, roomId)
                return
            end
        end
    end
end)

RegisterCommand(Config.givecommand, function()
    if #OwnedKeys >= 1 then
        local nearbyplayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 4.0)

        if #nearbyplayers >= 1 then
            local keys = {}
            local players = {}

            for i = 1, #OwnedKeys, 1 do
                table.insert(keys, {label = "Motel: "..UTK[OwnedKeys[i].motelId].info.name..", Key: "..OwnedKeys[i].roomId, motelId = OwnedKeys[i].motelId, roomId = OwnedKeys[i].roomId})
            end
            for p = 1, #nearbyplayers, 1 do
                if nearbyplayers[p] ~= PlayerId() then
                    table.insert(players, {id = GetPlayerServerId(nearbyplayers[p])})
                end
            end

            ESX.UI.Menu.CloseAll()

            ESX.TriggerServerCallback("utk_motels:nearbyNames", function(result)
                ESX.UI.Menu.Open("default", "utk_motels", "give-keys", {
                    title = "Owned Keys",
                    align = "top-left",
                    elements = keys
                }, function(data, menu)
                    local selection = data.current

                    if selection ~= nil then
                        ESX.UI.Menu.Open("default", "utk_motels", "n-players", {
                            title = "Nearby Players",
                            align = "top-left",
                            elements = result
                        }, function(data2, menu2)
                            local player = data2.current

                            if player.id ~= nil then
                                ESX.UI.Menu.Open("default", "utk_motels", "key-sure", {
                                    title = "Confirm ?",
                                    align = "top-left",
                                    elements = {{label = "Yes", value = true}, {label = "No", value = false}}
                                }, function(data3, menu3)
                                    if data3.current.value == true then
                                        TriggerServerEvent("utk_motels:updateKeys", selection.motelId, selection.roomId, player.id)
                                        ESX.UI.Menu.CloseAll()
                                    elseif data3.current.value == false then
                                        ESX.UI.Menu.CloseAll()
                                    end
                                end, function(data3, menu3)
                                    menu3.close()
                                end)
                            end
                        end, function(data2, menu2)
                            menu2.close()
                        end)
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end, players)
        else
            exports.mythic_notify:SendAlert("error", "No players nearby.", 5000)
        end
    else
        exports.mythic_notify:SendAlert("error", "You don't have a key.", 5000)
    end
end)

RegisterCommand(Config.stashcommand, function()
    local pedcoords = GetEntityCoords(PlayerPedId())

    for i = 1, #UTK, 1 do
        for j = 1, #UTK[i].rooms, 1 do
            if GetDistanceBetweenCoords(pedcoords, UTK[i].rooms[j].stash, true) <= 1.2 then
                if not UTK[i].rooms[j].locked2 then
                    OpenStash(i, j)
                    return
                end
            end
        end
    end
end)

RegisterCommand(Config.clothecommand, function()
    local pedcoords = GetEntityCoords(PlayerPedId())

    for i = 1, #UTK, 1 do
        for j = 1, #UTK[i].rooms, 1 do
            if GetDistanceBetweenCoords(pedcoords, UTK[i].rooms[j].clothe, true) <= 1.2 then
                OpenWardrobe(i, j)
                return
            end
        end
    end
end)

function DisableControl() DisableControlAction(0, 73, false) DisableControlAction(0, 24, true) DisableControlAction(0, 257, true) DisableControlAction(0, 25, true) DisableControlAction(0, 263, true) DisableControlAction(0, 32, true) DisableControlAction(0, 34, true) DisableControlAction(0, 31, true) DisableControlAction(0, 30, true) DisableControlAction(0, 45, true) DisableControlAction(0, 22, true) DisableControlAction(0, 44, true) DisableControlAction(0, 37, true) DisableControlAction(0, 23, true) DisableControlAction(0, 288, true) DisableControlAction(0, 289, true) DisableControlAction(0, 170, true) DisableControlAction(0, 167, true) DisableControlAction(0, 73, true) DisableControlAction(2, 199, true) DisableControlAction(0, 47, true) DisableControlAction(0, 264, true) DisableControlAction(0, 257, true) DisableControlAction(0, 140, true) DisableControlAction(0, 141, true) DisableControlAction(0, 142, true) DisableControlAction(0, 143, true) end
function DrawText3D(x, y, z, text, scale) local onScreen, _x, _y = World3dToScreen2d(x, y, z) local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) SetTextScale(scale, scale) SetTextFont(4) SetTextProportional(1) SetTextEntry("STRING") SetTextCentre(true) SetTextColour(255, 255, 255, 215) AddTextComponentString(text) DrawText(_x, _y) end