fx_version 'adamant'

game 'gta5'

description 'Disc Property'

version '1.1.1'

client_scripts {
    '@es_extended/locale.lua',
    'config.lua',
    'client/cupboard.lua',
    'client/kitchen.lua',
    'client/garage.lua',
    'client/clothes.lua',
    'client/main.lua',
    'client/property.lua',
    'client/showers.lua',
    'locales/cs.lua',
    'locales/en.lua',
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    '@es_extended/locale.lua',
    'config.lua',
    'server/main.lua',
    'server/property.lua',
    'server/garage.lua',
    'server/clothes.lua',
    'server/inventory.lua',
    'server/showers.lua',
    'locales/cs.lua',
    'locales/en.lua',
}
