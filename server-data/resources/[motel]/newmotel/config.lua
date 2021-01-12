Config = {
    performancemode = false, -- true yaparsanız markerlar gözümke ve performans artar, ancak false yaparsanız markerlar ve yazılar gözükür (false yapsanız bile performans çok iyidir)
    roommate = true, -- oda arkadaşı sistemi açma kapama
    itemsystem = "weight", -- "limit" veya "weight" | envnanter tipi
    inventorysystem = "disc", -- "esx" or "disc" | disc-inventoryhud HAZIR DEĞİLDİR!
    motelitemlimit = 100, -- Limit sistemi kullanıyorsanız odaya koyulacak bir itemin odalardaki max limitini artırır yani:  item limit + x şekilinde bir limiti olur oda envanterinde
    motelweightlimit = 5000, -- Ağırlık sistemi kullanıyorsanız odanın ağırlık kapasitesidir
    clothelimit = 100, -- odaya koyulabilecek max kıyafet sayısı
    discslot = 100, -- disc için oda slot sayısı
    inventoryreset = false, -- eğer true yaparsanız birisi oda bıraktığında veya odasının kirasını ödemeyip kaybettiğinde o odanın envateri otomatik silinir | false yaparsanız içindekiler kalır ve bir sonraki oda sahibi itemlere ulaşabilir

    ownership = false, -- eğer true yaparsanız "sahip" sistemi olur | false yaparsanız "oto" sistem olur
    rentprice = 500, -- eğer oto sistemi seçtiyseniz kira bedeli buradan belirleyin
    rentcycle = 12, -- kira ödeme sıklığı seçenekler: "daily" yaparsanız günlük kira öderler, veya 1, 2, 3 gibi rakamlar da koyabilirsiniz, her bir rakam saati temsil eder, yani her 1 saatte veya her 3 saatte gibi

    expensecycle = "168", -- motelin gider sıklığı, yukardaki seçeneklerin aynısı
    debtwarning = 100000, -- otel sahininin borç limiti, aşarsa polise bildirim gider

    enablekeytransfer = true, -- key transfer edebilmeyi kapatıp açma
    keyscommand = "anahtar", -- key menüsü için komut ismi
    doorlockcommand = "kapikilit", -- kapı açma/kapama için komut ismi
    stashlockcommand = "depokilit", -- oda envanteri açma/kapama için komut ismi
    stashcommand = "depo", -- envanteri açmak için komut ismi
    clothecommand = "dolap", -- kıyafet dolabını için komut ismi
    givecommand = "anahtarver", -- başkasına key verme için komut ismi
    knockcommand = "tıklat", -- kapı tıklatma için komut ismi
    --buzzcommand = "buzz", -- bu özellik daha hazır değil
    doorspam = 7, -- bir kez kapı çalınca bir kez daha çalması için beklemesi gereken süre (spam engellemek için)

    lockpick = { -- maymuncuk ile kapı açma ayarı | eğer böyle bir özellik istemiyorsanız burayı tamamen silip  lockpick = nil yapın
        item = "lockpick", -- maymuncuk item ismi
        breakchance = 0, -- maymuncuk kırılma şansı (yüzde)
    },

    elevators = { -- asansörler (bina sıralaması önemli değil ama katların sıralaması önemlidir)
        [1] = { -- Celtowa
            [1] = {x = -1009.12, y = -755.1, z = 19.84}, -- Giriş Katı
            [2] = {x = -1009.37, y = -752.83, z = 31.33}, -- 2. Kat ...
            [3] = {x = -1009.37, y = -752.83, z = 34.79},
            [4] = {x = -1009.37, y = -752.83, z = 38.20},
            [5] = {x = -1009.37, y = -752.83, z = 41.53},
            [6] = {x = -1009.37, y = -752.83, z = 44.85},
            [7] = {x = -1009.37, y = -752.83, z = 48.17},
            [8] = {x = -1009.37, y = -752.83, z = 51.57},
            [9] = {x = -1009.37, y = -752.83, z = 54.90},
            [10]= {x = -1009.37, y = -752.83, z = 58.21},
            [11]= {x = -1009.37, y = -752.83, z = 61.50},
            [12]= {x = -1009.37, y = -752.83, z = 64.81},
            [13]= {x = -1009.37, y = -752.83, z = 68.18},
            [14]= {x = -1009.37, y = -752.83, z = 71.66},
        },
        [2] = { -- Zurich
            [1] = {x = 185.61, y = -1078.41, z = 29.27},
            [2] = {x = 171.97, y = -1058.63, z = 48.41},
            [3] = {x = 171.97, y = -1058.63, z = 54.89},
            [4] = {x = 171.97, y = -1058.63, z = 60.98},
            [5] = {x = 171.97, y = -1058.63, z = 67.42},
        }
    }
}