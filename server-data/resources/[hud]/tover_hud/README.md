# Tover's HUD
By Tover , Tover's Services

**Do you want more of these high-quality scripts ? Feel free to join my discord https://discord.me/tover**
If you have questions, bugs or suggestions also feel free to join my discord !

# What to do ?
1) Be sure to have esx_status and esx_basicneeds installed!
2) In esx_basicneeds replace line 42 til 52 with
```lua
TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#CFAD0F', function(status)
		return false
	end, function(status)
		status.remove(100)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0C98F1', function(status)
		return false
	end, function(status)
		status.remove(75)
	end)
```

3) Or just simply replace `return true` to `return false` on line 43 and line 49

##### Optional
4) Go to es_extended/config.lua and set `Config.EnableHud` to false

#### Note
This script has a voice range module built in ! If you are using another script, please disable the feature through the `config.lua`

##### Another note
Feel free to edit this script to your liking, but when you reupload it please **give me the deserved credits!**


**Enjoy the HUD !**
