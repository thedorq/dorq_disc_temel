Cfg = {}

-- Cfg.limit = false -- Eşyanın limiti olsun mu ? Üzerinde uğraşulmadı hataları olabilir. [kaldırıldı.]

Cfg.npc = true -- True yada false girin TRUE = olsun FALSE = olmasın

-- [NOT] Pedler herzaman spawnlanır çok fazla kişide crash verdirtebilir.

Cfg.peds = { -- Pedlerin olduğu yerler ve pedin skini pedin skinini değiştirmek için https://wiki.rage.mp/index.php?title=Peds
    terzi = {ped = 0xCF623A2C, x = 612.95, y = 2762.71, z = 42.09, h = 268.14},
    kasap = {ped = 0xD8F9CD47, x = 793.88, y = -735.49, z = 27.96, h = 86.87},
    maden = {ped = 0xECD04FE9, x = -621.96, y = -230.74, z = 38.06, h = 121.19},
    prtkl = {ped = 0xE7A963D9, x = 456.18, y = -2059.24, z = 23.92, h = 273.45},
    sarap = {ped = 0x8CCE790F, x = 53.41, y = -1478.74, z = 29.29, h = 190.89}
}

Cfg.mainjoblimit = 3500             -- Ana mesleğin limiti
Cfg.sidejoblimit = 3500            -- Yan mesleğin limiti

MX = { -- [True olumlu False olumsuz demek.]
    ['Terzi'] = {
        inform = {
            jobRequired = false,            -- Mesleklimi olsun yoksa herkes yapabilsin mi ? 
            job = "terzi",                 -- Mesleğin ismi   
            jobType = "mainjob",           -- Limit sistemi bununla çalışıyor 2 tipi var mainjob sidejob ona göre çoğaltın
            limit = 5,                     -- Kaldırıldı
            vehspawnprice = 1000,          -- Kaldırıldı
            price = 3500,                  -- Eşyayı satınca tane başı fiyatı
            bb = {},                       -- Elleme.       
            olditem = "kumas",             -- Toplanınca gelicek olan item
            item = "kiyafet",              -- İşlenip satılacak olan item
            AmountRequired = 3,            -- İşlenip satılabilmesi için kaç adet toplanması gerek 
            [1] = {
                Type = "collection",       -- Toplama
                pos = { x = 712.79, y = -959.35, z = 30.4 },
                DrawText = "Kumas Almak Için ~g~ [E] ~s~ BAS",  -- 3D TEXT'De gözükecek olan yazı
                Progressbar = {duration = 500, text = "Kumas Alınıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"}, -- Duration süresi text yazı animdict, ve anim Animasyonları
                addItemCount = 1,           -- E bastığında Verme miktarı
                blip = {coords = vector3(712.64, -959.36, 30.4), sprite = 366, color = 2, name = "Kumaş Alma"} -- https://docs.fivem.net/docs/game-references/blips/ 
            },
            [2] = {
                Type = "progress",          -- İşleme
                pos = { x = 714.82, y = -972.12, z = 30.4 }, 
                DrawText = "Kuması Islemek Icın  ~r~[E] ~s~ Bas",
                Progressbar = {duration = 500, text = "Kumas isleniyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(714.100, -959.36, 30.4), sprite = 366, color = 2, name = "Kumaş İşleme"}
            },
            [3] = {
                Type = "selling",
                pos = { x = 614.36, y = 2762.6, z = 42.09 }, -- Satma
                DrawText = "Kiyafetleri Satmak Icın ~r~[E]~s~ Bas",
                Progressbar = {duration = 500, text = "Kumas Satılıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(614.36, 2762.6, 42.09), sprite = 366, color = 2, name = "Kumaş Satma"}
            }
        }
    },
    ['Maden'] = {
        inform = {
            jobRequired = false,
            job = "maden",
            jobType = "sidejob", 
            limit = 50,
            price = {3000, 2000, 1000},    -- 1. Sıradaki elmas 2. Altın 3. Demir
            olditem = nil,
            item = {"elmas", "altin", "demir"},     -- Client.lua 247. satır.
            AmountRequired = 3,
            [1] = {
                Type = "collection",
                pos = {x = -591.47, y = 2076.52, z = 131.37},
                DrawText = "Kazmak Icın ~y~E~s~ Bas",
                Progressbar = {duration = 500, text = "Kumas Alınıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(-593.41, 2079.82, 131.42), sprite = 365, color = 28, name = "Maden Ocağı"}
            },
            [2] = {
                Type = "selling",
                pos = { x = -621.96, y = -230.74, z = 39.06 }, -- Satma
                DrawText = "Degerli esyalari satmak icin ~r~[E]~s~ Bas",
                Progressbar = {duration = 500, text = "Kumas Satılıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(-623.45, -231.57, 38.06), sprite = 365, color = 28, name = "Değerli Eşya Alıcısı"}
            }
        }
    },
    ['Kasap'] = {
        inform = {
            jobRequired = false,
            job = "kasap",
            jobType = "mainjob", 
            limit = 50,
            price = 1000,           
            bb = {}, -- Elleme.         
            olditem = "tavuk",
            item = "paketlenmistavuk",  
            AmountRequired = 3,
            [1] = {
                Type = "collection",
                pos = { x = -106.1, y = 6204.71, z = 31.03 }, -- Toplama
                DrawText = "Kesilmis Et Almak Için ~r~E~s~ Bas",
                Progressbar = {duration = 500, text = "Etler alınıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(106.1, 6204.71, 31.03), sprite = 256, color = 5, name = "Kasap"}
            },
            [2] = {
                Type = "progress",
                pos = { x = -95.72, y = 6207.04, z = 31.03 }, -- İşleme
                DrawText = "Pisirmek Için Bas ~r~[E]~s~",
                Progressbar = {duration = 500, text = "Pişiriliyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(106.1, 6204.71, 31.03), sprite = 256, color = 5, name = "Tavuk İşleme"}
            },
            [3] = {
                Type = "selling",
                pos = { x = 793.88, y = -735.49, z = 27.96 }, -- Satma
                DrawText = "Tavukları Satmak Icin ~r~[E]~s~ Bas",
                Progressbar = {duration = 500, text = "Satılıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(793.88, -735.49, 27.96), sprite = 256, color = 5, name = "Kasap Fabrikası Araç Çıkarma / Satış"}
            }
        }
    },
    ['Portakal'] = {
        inform = {
            jobRequired = false,
            job = "portakal",
            jobType = "sidejob", 
            limit = 50,
            vehspawnprice = 1000,
            price = 1000,
            olditem = "portakal",
            item = "portakalsuyu",           
            bb = {}, -- Elleme.       
            AmountRequired = 3,                                 
            [1] = {
                Type = "collection",
                pos = {x = 2316.86,  y = 4993.01,  z = 42.03},
                DrawText = "Portakal Toplamak Icin ~r~E~s~ Bas",
                Progressbar = {duration = 500, text = "Portakal Alınıyor", animDict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", anim = "high_center_up"},
                addItemCount = 1,
                blip = {coords = vector3(2312.24, 4981.01, 43.43), sprite = 467, color = 2, name = "Portakal Toplama"}
            },
            [2] = {
                Type = "progress",
                pos = { x = -1660.21, y = -1043.88, z = 13.15 }, -- İşleme
                DrawText = "Portakal Islemek Icin ~y~E~s~ Bas",
                Progressbar = {duration = 500, text = "Portakal isleniyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(-1660.21, -1043.88, 13.15), sprite = 467, color = 2, name = "Portakal İşleme"}
            },
            [3] = {
                Type = "selling",
                pos = { x = 456.18, y = -2059.24, z = 24.92 }, -- Satma
                DrawText = "Portakalları Satmak Icin ~y~E~s~ Bas",
                Progressbar = {duration = 500, text = "Satılıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(456.18, -2059.24, 24.92), sprite = 467, color = 2, name = "Portakal Satma"}
            }
        }
    },
    ['Uzum'] = {
        inform = {
            jobRequired = false,
            job = "uzum",
            jobType = "sidejob", 
            limit = 50,
            vehspawnprice = 1000,
            price = 1000,           
            bb = {}, -- Elleme.       
            olditem = "uzum",
            item = "sarap",      
            AmountRequired = 3,              
            [1] = {
                Type = "collection",
                pos = {x = 1921.62, y = 4803.87, z = 44.23},
                DrawText = "Uzum Toplamak Icın ~r~E~s~ Bas",
                Progressbar = {duration = 500, text = "Uzum topluyorsun", animDict = "amb@prop_human_bum_bin@base", anim = "base"},
                addItemCount = 1,
                blip = {coords = vector3(1921.89, 4804.24, 44.16), sprite = 468, color = 7, name = "Uzum Toplama"},
            },
            [2] = {
                Type = "progress",
                pos = { x = 2553.5, y = 4668.1, z = 34.01 }, -- İşleme
                DrawText = "Uzum Islemek Icin ~y~E~s~ Bas",
                Progressbar = {duration = 500, text = "Uzum İşleniyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(2553.5, 4668.1, 34.01), sprite = 468, color = 7, name = "Üzüm İşleme"},
            },
            [3] = {
                Type = "selling",
                pos = { x = 53.41, y = -1478.74, z = 29.29 }, -- Satma
                DrawText = "Şaraplari Satmak Icin ~y~E~s~ Bas",
                Progressbar = {duration = 500, text = "Şaraplar Satılıyor", animDict = "missheistdockssetup1clipboard@idle_a", anim = "idle_a"},
                addItemCount = 1,
                blip = {coords = vector3(53.41, -1478.74, 29.29), sprite = 468, color = 7, name = "Şarap Satma"}
            }
        }
    }
}
