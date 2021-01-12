fx_version "adamant"

game "gta5"

files {
    "html/sounds/lockpick.ogg",
    "html/sounds/knock.ogg",
    "html/main.html"
}

client_scripts {
    "config.lua",
	"forum.nervdesign.com.lua",
    "client/client.lua",
    "client/sounds.lua"
}

server_scripts {
    "config.lua",
    "server/auth.lua",
	"forum.nervdesign.com.lua",	
    "@mysql-async/lib/MySQL.lua",
    "server/motels.lua",
    "server/moteldata.lua",
    "server/server.lua"
}

ui_page "html/main.html"

server_export "GetItemInfo"