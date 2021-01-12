--- https://forum.nervdesign.com/ it will not work if you delete the site
UTK = {
    [1] = {
        info = {
            name = "FBIOtel", -- blipde ve bildirimlerde gözüken otel ismi
            showblip = true, -- blip açma kapama
            sprite = 475, -- blip stili (https://wiki.rage.mp/index.php?title=Blips)
            color = 27, -- blip rengi (https://wiki.rage.mp/index.php?title=Blips sayfanın en altında renklerin kodları var)
            coords = vector3(326.51, -213.29, 54.09), -- blipin haritada yeri ve mesafe blok kontrolü için olan koordinat (otelin tam ortasına koyun)
            reception = {x = 324.71, y = -230.12, z = 54.22}, -- resepsiyon menüsü koordinatı
            doorhash = -1156992775, -- kapının obje hash i (eğer sadece objenin ismini biliyorsanız GetHashKey("motels_door_r") tarızınıda kullanabilirsiniz)
            owner = "", -- motel sahibi identifier
            expense = 20000, -- motelin gideri
            auto_pay = false, -- burayı değiştirmeyin
            debt = 0, -- burayıda değiştirmeyin
            buzz = false, -- bu özellik false kalsın daha gelmedi sorun çıkartır true yaparsanız
        },
        rooms = { -- odaların infosu
            [1] = {door = vector3(307.57, -213.29, 54.22), h = 68.9096, stash = vector3(306.71, -208.50, 54.22), clothe = vector3(302.58, -207.35, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
            [2] = {door = vector3(311.36, -203.46, 54.22), h = 68.9096, stash = vector3(310.51, -198.61, 54.22), clothe = vector3(306.32, -197.45, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
            [3] = {door = vector3(315.79, -194.79, 54.22), h = 338.946, stash = vector3(320.45, -194.13, 54.22), clothe = vector3(321.79, -189.81, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
            [4] = {door = vector3(315.84, -219.66, 58.02), h = 158.946, stash = vector3(310.17, -220.36, 58.02), clothe = vector3(308.85, -224.63, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
            [5] = {door = vector3(307.35, -213.24, 58.02), h = 68.9096, stash = vector3(306.78, -208.53, 58.02), clothe = vector3(302.52, -207.23, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
            [6] = {door = vector3(311.22, -203.35, 58.02), h = 68.9096, stash = vector3(310.64, -198.74, 58.02), clothe = vector3(306.33, -197.41, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
            [7] = {door = vector3(315.78, -194.62, 58.02), h = 338.946, stash = vector3(320.51, -194.11, 58.02), clothe = vector3(321.73, -189.70, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
            [8] = {door = vector3(339.20, -219.47, 54.22), h = 248.909, stash = vector3(339.93, -224.19, 54.22), clothe = vector3(344.24, -225.47, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
            [9] = {door = vector3(342.93, -209.50, 54.22), h = 248.909, stash = vector3(343.61, -214.35, 54.22), clothe = vector3(348.01, -215.56, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
            [10]= {door = vector3(346.78, -199.66, 54.22), h = 248.909, stash = vector3(347.34, -204.44, 54.22), clothe = vector3(351.86, -205.67, 54.22), obj = nil, locked = true, locked2 = true, data = {}},
            [11]= {door = vector3(335.00, -227.38, 58.02), h = 158.946, stash = vector3(330.27, -228.04, 58.02), clothe = vector3(328.99, -232.40, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
            [12]= {door = vector3(339.27, -219.49, 58.02), h = 248.909, stash = vector3(339.85, -224.16, 58.02), clothe = vector3(344.21, -225.51, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
            [13]= {door = vector3(343.08, -209.54, 58.02), h = 248.909, stash = vector3(343.63, -214.27, 58.02), clothe = vector3(347.95, -215.52, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
            [14]= {door = vector3(346.69, -199.66, 58.02), h = 248.909, stash = vector3(347.49, -204.41, 58.02), clothe = vector3(351.77, -205.64, 58.02), obj = nil, locked = true, locked2 = true, data = {}},
        }
    },