Config = {}

Config.Locale = 'en'
Config.OpenControl = 289
Config.TrunkOpenControl = 47
Config.DeleteDropsOnStart = true
Config.HotKeyCooldown = 1000

--Durability Settings
Config.TimerQuality = 10 --(Minutes) How many minutes goes down durability

Config.DurabilityInvs = {
    [1] = {name = "motel"},
    [2] = {name = "trunk"},
}

Config.ItemDurabilityList = {
    ["WEAPON_PISTOL"] = {QualityUse = true, outdated = 1},
    ["phone"] = {QualityUse = true, outdated = 2},
    ["WEAPON_SNSPISTOL"] = {QualityUse = true, outdated = 1},
    ["WEAPON_APPISTOL"] = {QualityUse = true, outdated = 1},
}

Config.Shops = {
   

        ['liquor'] = {
            coords = {
                vector3(1136.03, -982.65, 40.5),
            },
            items = {
                {name = 'water', price = 5, count = 1},

            },
            markerType = 27,
            markerColour = { r = 48, g = 249, b = 189 },
            blipColour = 2,
            blipSprite = 52,
            msg = '~INPUT_PICKUP~ tuşuna basarak marketi aç',
            enableBlip = false,
            job = 'all'
            },  

            ['market'] = {
                coords = {
                    vector3(374.33, 327.94, 103.57),
                },
                items = {
					{name = 'water', price = 400, count = 1},
                },
                markerType = 27,
                markerColour = { r = 0, g = 0, b = 255 },
                blipColour = 2,
                blipSprite = 52,
                msg = ' ~INPUT_PICKUP~ tuşuna basarak marketi aç',
                enableBlip = false,
                job = 'all'
                }, 



                ['spor'] = {
                    coords = {
                        vector3(-52.6, -1289.07, 30.0),
                        vector3(-1195.46, -1577.58, 3.6),
                    },
                    items = {
                            {name = 'water', price = 5, count = 1},

     
                    },
                    markerType = 27,
                    markerColour = { r = 48, g = 249, b = 189 },
                    blipColour = 2,
                    blipSprite = 52,
                    msg = ' ~INPUT_PICKUP~ tuşuna basarak spor marketini aç',
                    enableBlip = false,
                    job = 'all'
                    }, 
    

                
            ['Balık Market'] = {
                coords = {
                    vector3(-1320.78, -1321.78, 3.8),

                },
                items = {
                    {name = 'water', price = 500, count = 1},
                    {name = 'water', price = 5, count = 1},
                    {name = 'water', price = 100, count = 1},
                },
                markerType = 27,
                markerColour = { r = 48, g = 249, b = 189 },
                blipColour = 2,
                blipSprite = 52,
                msg = '~INPUT_PICKUP~ tuşuna basarak marketi aç',
                enableBlip = false,
                job = 'all'
                }, 
                

                ['blackmarket'] = {
                    coords = {
                        vector3(622.67,-393.36,4.89),
                        
                    },
                    items = {               
                    },
                    markerType = 27,
                    markerColour = { r = 48, g = 249, b = 189 },
                    blipColour = 2,
                    blipSprite = 52,
                    msg = ' ~INPUT_PICKUP~ tuşuna basarak marketi aç',
                    enableBlip = false,
                    job = 'all'
                    }, 
   ['Silah'] = {
        coords = {
       	vector3(22.1,-1107.19,28.8),
		vector3(251.99,-49.82,68.94),
		vector3(-662.32,-935.23,20.83),
		vector3(842.36,-1033.37,27.19),
		vector3(810.05,-2156.93,28.62),
		vector3(2567.76,294.63,107.74),
		vector3(1693.83,3759.77,33.81),
        vector3(-1117.45,2698.58,17.55),
        vector3(-330.24,6083.88,30.55),
		
        },
        items = { 
            {name = "WEAPON_KNIFE", price = 1000, count = 1 },
		    {name = 'WEAPON_BAT', price = 1000, count = 1},
			{name = 'disc_ammo_pistol', price = 2000, count = 1},
            {name = 'disc_ammo_pistol_large', price = 20000, count = 1}
        },
        markerType = 27,
        markerColour = { r = 78, g = 0, b = 0 },
        blipColour = 2,
        blipSprite = 52,
        msg = ' ~INPUT_PICKUP~ tuşuna basarak silahçıyı aç',
        enableBlip = false,
        job = 'all'
        },    
    ['Hırdavat Dükkanı'] = {
        coords = {
            vector3(52.11874, -1736.67, 28.438),
        },
        items = {
            { name = "water", price = 1000, count = 1 }, 
            { name = "water", price = 1000, count = 1 }, 
            { name = "water", price = 1000, count = 1 }, 
        },
        markerType = 27,
        size = vector3(1.0, 1.0, 1.0),
        markerColour = { r = 48, g = 249, b = 189 },
        blipColour = 2,
        blipSprite = 80,
        msg = '~INPUT_PICKUP~ tuşuna basarak dükkana eriş!',
        enableBlip = false,
        job = 'all'
        }, 
        ['Teknoloji market'] = {
            coords = {
                vector3(-659.109, -857.937, 23.525),
                vector3(-102.925, -81.6159, 56.295),
                vector3(-925.876, -155.563, 45.310),
            },
            items = {
                {name = 'water', price = 1000, count = 1},
                {name = 'water', price = 8000, count = 1},
            },
            markerType = 27,
            size = vector3(1.0, 1.0, 1.0),
            markerColour = { r = 48, g = 249, b = 189 },
            blipColour = 2,
            blipSprite = 52,
            msg = 'Teknoloji Marketini açmak için ~INPUT_PICKUP~ tuşuna basınız',
            enableBlip = false,
            job = 'all'
            }, 

            ['Market2'] = {
                coords = {
                    vector3(438.5, -981.53, 15.7),
                },
                items = {
                    {name = 'water', price = 5, count = 1},
                    {name = 'water', price = 5, count = 1},

    
                },
                markerType = 27,
                markerColour = { r = 48, g = 249, b = 189 },
                blipColour = 2,
                blipSprite = 52,
                msg = '~INPUT_PICKUP~ tuşuna basarak marketi aç',
                enableBlip = false,
                job = 'all'
                }, 
                ['Bufe'] = {
                    coords = {
                        vector3(-901.935, -158.497, 45.260),

                    },
                    items = {
                        {name = 'water', price = 4, count = 1},
                        {name = 'water', price = 5, count = 1},
                        {name = 'water', price = 4, count = 1},
                        {name = 'water', price = 4, count = 1},
                    },
                    markerType = 27,
                    markerColour = { r = 0, g = 0, b = 255 },
                    blipColour = 2,
                    blipSprite = 52,
                    msg = '~INPUT_PICKUP~ tuşuna basarak restorant marketini aç',
                    enableBlip = false,
                    job = 'all'
                    }, 

                    ['Otomat'] = {
                        coords = {
                            vector3(313.7231, -588.264, 42.300),
                        },
                        items = {
                            {name = 'water', price = 4, count = 1},
                            {name = 'water', price = 5, count = 1},
                            {name = 'water', price = 5, count = 1},
                            {name = 'water', price = 5, count = 1},
                        },
                        markerType = 27,
                        size = vector3(1.0, 1.0, 1.0),
                        markerColour = { r = 0, g = 0, b = 255 },
                        blipColour = 2,
                        blipSprite = 52,
                        msg = '~INPUT_PICKUP~ tuşuna basarak kahve marketini aç',
                        enableBlip = false,
                        job = 'all'
                        }, 
                ['Los Santos Medical Department Dolap'] = {
                    coords = {
                        vector3(327.5998, -581.799, 42.325),
                    },
                    items = {
                        { name = "water", price = 0, count = 1 },
                        { name = "water", price = 0, count = 1 },
                        { name = "water", price = 0, count = 1 },
                        { name = "water", price = 0, count = 1 },	
                    },
                    markerType = 27,
                    size = vector3(1.0, 1.0, 1.0),
                    markerColour = { r = 255, g = 255, b = 255 },
                    blipColour = 2,
                    blipSprite = 52,
                    msg = '~INPUT_PICKUP~ tuşuna basarak Ems Dolabını aç',
                    enableBlip = false,
                    job = 'ambulance'
                    },  

                    ['Mekanik'] = {
                        coords = {
                            vector3(955.9, -966.64, 38.6),
                        },
                        items = {
                            { name = "water", price = 0, count = 1 },
        
                        },
                        markerType = 27,
                        markerColour = { r = 48, g = 249, b = 189 },
                        blipColour = 2,
                        blipSprite = 52,
                        msg = '~INPUT_PICKUP~ tuşuna basarak mekanik marketini aç',
                        enableBlip = false,
                        job = 'mechanic'
                        },
						
				    ['Teknoloji Marketi'] = {
					    coords = {
                            vector3(-629.11, -276.2, 34.65),
                            vector3(-914.282, -151.650, 45.280)
						},
                        items = {

                            { name = "water", price = 15000, count = 1 },

					    },
                        markerType = 27,
                        markerColour = { r = 48, g = 249, b = 189 },
						blipColour = 46,
                        blipSprite = 521,
						msg = '~INPUT_PICKUP~ tuşuna basarak Teknoloji Marketini aç',
						enableBlip = false,
                        job = 'all'
                        },
						
    ['Polis Malzemeleri'] = {
        coords = {
            vector3(-1086.71, -821.761, 10.062),
        },
        items = {

            { name = "WEAPON_COMBATPISTOL", price = 0, count = 1 },
            { name = "WEAPON_CARBINERIFLE", price = 0, count = 1 },
            { name = "disc_ammo_pistol", price = 0, count = 1 },
            { name = "disc_ammo_rifle", price = 0, count = 1 },   
        },
        markerType = 27,
        size = vector3(1.0, 1.0, 1.0),
        markerColour = { r = 78, g = 0, b = 0 },
        blipColour = 2,
        blipSprite = 52,
        msg = 'Menüyü Açmak İçin ~INPUT_PICKUP~ Tuşuna Basınız',
        enableBlip = false,
        job = 'police'
    }
}

Config.Stash = {
    ['Kanıt Deposu'] = {
        coords = vector3(456.64, -988.33, 29.0),
        size = vector3(1.0, 1.0, 1.0),
        job = 'police',
        markerType = 27,
        markerColour = { r = 78, g = 0, b = 0 },
        msg = '~INPUT_PICKUP~ tuşuna basarak kanıt deposunu aç'
    },
    ['Los Santos Medical Department Atık'] = {
        coords = vector3(327.5278, -581.709, 42.320),
        size = vector3(1.0, 1.0, 1.0),
        job = 'ambulance',
        markerType = 27,
        markerColour = { r = 78, g = 0, b = 0 },
        msg = '~INPUT_PICKUP~ tuşuna basarak depoyu aç'
    },
    ['Mekanik Depo'] = {
        coords = vector3(950.84, -969.12, 38.6),
        size = vector3(1.0, 1.0, 1.0),
        job = 'mechanic',
        markerType = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '~INPUT_PICKUP~ tuşuna basarak depoyu aç'
    },
    ['Polis Deposu'] = {
        coords = vector3(-1079.02, -815.606, 10.042),
        size = vector3(1.0, 1.0, 1.0),
        job = 'police',
        markerType = 27,
        markerColour = { r = 0, g = 0, b = 255 },
        msg = '~INPUT_PICKUP~ tuşuna basarak önemsiz eşyalar deposunu aç'
    }
}

Config.Steal = {
    black_money = true,
    cash = true
}

Config.Seize = {
    black_money = true,
    cash = true
}

Config.Map = {

}

Config.VehicleSlot = {
    [0] = 10, --Compact
    [1] = 15, --Sedan
    [2] = 20, --SUV
    [3] = 15, --Coupes
    [4] = 5, --Muscle
    [5] = 5, --Sports Classics
    [6] = 5, --Sports
    [7] = 0, --Super
    [8] = 5, --Motorcycles
    [9] = 10, --Off-road
    [10] = 20, --Industrial
    [11] = 20, --Utility
    [12] = 30, --Vans
    [13] = 0, --Cycles
    [14] = 0, --Boats
    [15] = 0, --Helicopters
    [16] = 0, --Planes
    [17] = 20, --Service
    [18] = 20, --Emergency
    [19] = 90, --Military
    [20] = 0, --Commercial
    [21] = 0 --Trains
}
Config.Throwables = {
    WEAPON_MOLOTOV = 615608432,
    WEAPON_GRENADE = -1813897027,
    WEAPON_STICKYBOMB = 741814745,
    WEAPON_PROXMINE = -1420407917,
    WEAPON_SMOKEGRENADE = -37975472,
    WEAPON_PIPEBOMB = -1169823560,
    WEAPON_SNOWBALL = 126349499
}

Config.FuelCan = 883325847