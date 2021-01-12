if Config.inventorysystem == "disc" then
    function BuildMotelData(...)
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = 'utk',
            label = "Room",
            slots = Config.discslot,

            getInventory = function(d, cb)
                local result = MySQL.Sync.fetchAll("SELECT inventory FROM utk_motels_"..d:sub(1,1).." WHERE id = @id", {
                    ["@id"] = d:sub(3, d:len())
                })
                if #result ~= 0 then
                    --label = UTK[d:sub(1,1)].info.name.." | Room-"..d:sub(3, d:len())
                    inventory = json.decode(result[1].inventory)
                    loadedInventories["utk"][d] = inventory
                    cb(inventory)
                end
            end,

            --[[applyToInventory = function(d, type, f)
                f(loadedInventories["utk"][d:sub(1,1).."_"..d:sub(3, b:len())])
            end,]]

            saveInventory = function(d, toSave)
                if table.length(toSave) > 0 then
                    MySQL.Async.execute("UPDATE utk_motels_"..d:sub(1,1).." SET inventory = @inventory WHERE id = @id", {
                        ["@inventory"] = json.encode(toSave),
                        ["@id"] = d:sub(3, d:len())
                    })
                end
            end,

            getDisplayInventory = function(d, cb, source)
                local p = ESX.GetPlayerFromId(source)
                InvType["utk"].getInventory(d, function(inventory)
                    local itemsObject = {}

                    for k, v in pairs(inventory) do
                        if k ~= "cash" and k ~= "black_money" then
                            local esxItem = p.getInventoryItem(v.name)
                            local item = createDisplayItem(v, esxItem, tonumber(k))
                            item.usable = false
                            item.giveable = false
                            item.canRemove = false
                            table.insert(itemsObject, item)
                        end
                    end
                    local inv = {
                        invId = d,
                        invTier = InvType["utk"],
                        inventory = itemsObject,
                        inventory['cash'] or 0,
                        black_money = inventory['black_money'] or 0
                    }
                    cb(inv)
                end)
            end
        })
    end
elseif Config.inventorysystem == "esx" then
    if Config.itemsystem == "weight" then
        function BuildMotelData(motelId, roomId, invdata, blackmoney, wepdata, clothes)
            local self = {}
            local inv = json.decode(invdata)
            local wep = json.decode(wepdata)

            self.motel = motelId
            self.id = roomId
            self.inventory = {}
            self.weapons = {}
            self.clothes = json.decode(clothes)
            self.blackmoney = blackmoney or 0
            self.currentweight = 0
            for i = 1, #inv, 1 do
                local itemweight = GetItemWeight(inv[i].name)
                table.insert(self.inventory, {name = inv[i].name, count = inv[i].count, label = inv[i].label, weight = itemweight})
                self.currentweight = self.currentweight + (itemweight * inv[i].count)
            end
            for j = 1, #wep, 1 do
                local itemweight = GetItemWeight(wep[j].name)
                table.insert(self.weapons, {name = wep[j].name, ammo = wep[j].ammo, weight = itemweight})
                if wep[j].ammo > 0 then
                    self.currentweight = self.currentweight + itemweight
                end
            end

            self.getItem = function(name)
                for i = 1, #self.inventory, 1 do
                    if self.inventory[i].name == name then
                        return self.inventory[i], i
                    end
                end
                local it = MySQL.Sync.fetchAll("SELECT label, weight FROM items WHERE name = @name", {["@name"] = name})

                if it[1].label == nil then
                    return nil
                end
                local item = {name = name, count = 0, label = it[1].label, weight = GetItemWeight(name)}

                table.insert(self.inventory, item)
                return item, #self.inventory
            end

            self.addItem = function(name, count)
                local item, index = self.getItem(name)

                item.count = item.count + count
                self.currentweight = self.currentweight + (item.weight * count)
                self.updateInv(index, item)
            end

            self.removeItem = function(name, count)
                local item, index = self.getItem(name)

                item.count = item.count - count
                self.currentweight = self.currentweight - (item.weight * count)
                self.updateInv(index, item)
            end

            self.updateInv = function(pos, item)
                self.inventory[pos] = item
                local lastinv = json.encode(self.inventory)

                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET inventory = @inventory WHERE id = @id", {["@inventory"] = lastinv, ["@id"] = self.id})
            end

            self.getWeapon = function(name)
                for i = 1, #self.weapons, 1 do
                    if self.weapons[i].name == name then
                        return self.weapons[i], i
                    end
                end
                local weapon = {name = name, ammo = 0, weight = GetItemWeight(name)}
                table.insert(self.weapons, weapon)
                return weapon, #self.weapons
            end

            self.addWeapon = function(name, count)
                local weapon, index = self.getWeapon(name)

                if weapon.ammo == 0 then
                    self.currentweight = self.currentweight + weapon.weight
                end
                weapon.ammo = weapon.ammo + count
                self.updateWep(index, weapon)
            end

            self.removeWeapon = function(name, count)
                local weapon, index = self.getWeapon(name)

                weapon.ammo = weapon.ammo - count
                if weapon.ammo == 0 then
                    table.remove(self.weapons, index)
                    self.currentweight = self.currentweight - weapon.weight
                    self.updateWep(index, weapon, 2)
                else
                    self.updateWep(index, weapon, 1)
                end
            end

            self.updateWep = function(pos, weapon, type)
                if type == 1 then
                    self.weapons[pos] = weapon
                    local lastwep = json.encode(self.weapons)

                    MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET weapons = @weapons WHERE id = @id", {["@weapons"] = lastwep, ["@id"] = self.id})
                elseif type == 2 then
                    local lastwep = json.encode(self.weapons)

                    MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET weapons = @weapons WHERE id = @id", {["@weapons"] = lastwep, ["@id"] = self.id})
                end
            end

            self.addBlack = function(amount)
                self.blackmoney = self.blackmoney + amount
                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET blackmoney = @blackmoney WHERE id = @id", {["@blackmoney"] = self.blackmoney, ["@id"] = self.id})
            end

            self.removeBlack = function(amount)
                self.blackmoney = self.blackmoney - amount
                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET blackmoney = @blackmoney WHERE id = @id", {["@blackmoney"] = self.blackmoney, ["@id"] = self.id})
            end

            self.clearInv = function()
                self.inventory = {}
                self.weapons = {}
                self.blackmoney = 0
                self.clothes = {}
                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET inventory = @inventory, weapons = @weapons, blackmoney = @blackmoney, clothes = @clothes WHERE id = @id", {
                    ["@inventory"] = json.encode(self.inventory),
                    ["@weapons"] = json.encode(self.weapons),
                    ["@blackmoney"] = 0,
                    ["@clothes"] = json.encode(self.clothes),
                    ["@id"] = self.id
                })
            end

            self.saveSkin = function(label, skin)
                table.insert(self.clothes, {label = label, skin = json.encode(skin)})
                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET clothes = @clothes WHERE `id` = @id", {
                    ["@clothes"] = json.encode(self.clothes),
                    ["@id"] = self.id
                })
            end

            self.removeSkin = function(index)
                if index ~= nil then
                    table.remove(self.clothes, index)
                    MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET clothes = @clothes WHERE `id` = @id", {
                        ["@clothes"] = json.encode(self.clothes),
                        ["@id"] = self.id
                    })
                end
            end

            return self
        end
    else
        function BuildMotelData(motelId, roomId, invdata, blackmoney, wepdata)
            local self = {}
            local inv = json.decode(invdata)
            local wep = json.decode(wepdata)

            self.motel = motelId
            self.id = roomId
            self.inventory = {}
            self.weapons = {}
            self.blackmoney = blackmoney or 0
            for i = 1, #inv, 1 do
                table.insert(self.inventory, {name = inv[i].name, count = inv[i].count, label = inv[i].label})
            end
            for j = 1, #wep, 1 do
                table.insert(self.weapons, {name = wep[j].name, count = wep[j].count})
            end

            self.getItem = function(name)
                for i = 1, #self.inventory, 1 do
                    if self.inventory[i].name == name then
                        return self.inventory[i], i
                    end
                end
                local it = MySQL.Sync.fetchAll("SELECT label FROM items WHERE name = @name", {["@name"] = name})

                if it[1].label == nil then
                    return nil
                end
                local item = {name = name, count = 0, label = it[1].label}

                table.insert(self.inventory, item)
                return item, #self.inventory
            end

            self.addItem = function(name, count)
                local item, index = self.getItem(name)

                item.count = item.count + count
                self.updateInv(index, item)
            end

            self.removeItem = function(name, count)
                local item, index = self.getItem(name)

                item.count = item.count - count
                self.updateInv(index, item)
            end

            self.updateInv = function(pos, item)
                self.inventory[pos] = item
                local lastinv = json.encode(self.inventory)

                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET inventory = @inventory WHERE id = @id", {["@inventory"] = lastinv, ["@id"] = self.id})
            end

            self.getWeapon = function(name)
                for i = 1, #self.weapons, 1 do
                    if self.weapons[i].name == name then
                        return self.weapons[i], i
                    end
                end
                local weapon = {name = name, count = 0}

                table.insert(self.weapons, weapon)
                return weapon, #self.weapons
            end

            self.addWeapon = function(name, count)
                local weapon, index = self.getWeapon(name)

                weapon.count = weapon.count + count
                self.updateWep(index, weapon)
            end

            self.removeWeapon = function(name, count)
                local weapon, index = self.getWeapon(name)

                weapon.count = weapon.count - count
                self.updateWep(index, weapon)
            end

            self.updateWep = function(pos, weapon)
                self.weapons[pos] = weapon
                local lastwep = json.encode(self.weapons)

                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET weapons = @weapons WHERE id = @id", {["@weapons"] = lastwep, ["@id"] = self.id})
            end

            self.addBlack = function(amount)
                self.blackmoney = self.blackmoney + amount
                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET blackmoney = @blackmoney WHERE id = @id", {["@blackmoney"] = self.blackmoney, ["@id"] = self.id})
            end

            self.removeBlack = function(amount)
                self.blackmoney = self.blackmoney - amount
                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET blackmoney = @blackmoney WHERE id = @id", {["@blackmoney"] = self.blackmoney, ["@id"] = self.id})
            end

            self.clearInv = function()
                self.inventory = {}
                self.weapons = {}
                self.blackmoney = 0

                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET inventory = @inventory, weapons = @weapons, blackmoney = @blackmoney, clothes = @clothes WHERE id = @id", {
                    ["@inventory"] = json.encode(self.inventory),
                    ["@weapons"] = json.encode(self.weapons),
                    ["@blackmoney"] = 0,
                    ["@clothes"] = json.encode(self.clothes),
                    ["@id"] = self.id
                })
            end

            self.saveSkin = function(label, skin)
                table.insert(self.clothes, {label = label, skin = json.encode(skin)})
                MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET clothes = @clothes WHERE `id` = @id", {
                    ["@clothes"] = json.encode(self.clothes),
                    ["@id"] = self.id
                })
            end

            self.removeSkin = function(index)
                if index ~= nil then
                    table.remove(self.clothes, index)
                    MySQL.Async.execute("UPDATE utk_motels_"..self.motel.." SET clothes = @clothes WHERE `id` = @id", {
                        ["@clothes"] = json.encode(self.clothes),
                        ["@id"] = self.id
                    })
                end
            end

            return self
        end
    end
end