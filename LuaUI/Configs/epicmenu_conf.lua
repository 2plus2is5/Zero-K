local confdata = {}
confdata.title = 'Z.K.'
confdata.title_image = LUAUI_DIRNAME .. 'Images/ZK_logo.png'
confdata.default_source_file = 'zk_keys.lua' --the file in ZIP archive where default key is stored.
confdata.mission_keybinds_file = 'zk_keys.lua' --the filename to be used for Mission mod. set this to NIL if want to use mission's name as filename.
-- confdata.regular_keybind_file = LUAUI_DIRNAME .. 'Configs/zk_keys.lua' --for Multiplayer this is automatically set according to modName in epicmenu.lua
--FIXME: find modname instead of using hardcoded mission_keybinds_file name
confdata.description = 'Zero-K is a free real time strategy (RTS), that aims to be the best open source multi-platform strategy game available :-) \n\n www.zero-k.info'
local color = {
	white = {1,1,1,1},
	yellow = {1,1,0,1},
	gray = {0.5,.5,.5,1},
	darkgray = {0.3,.3,.3,1},
	cyan = {0,1,1,1},
	red = {1,0,0,1},
	darkred = {0.5,0,0,1},
	blue = {0,0,1,1},
	black = {0,0,0,1},
	darkgreen = {0,0.5,0,1},
	green = {0,1,0,1},
	postit = {1,0.9,0.5,1},
	
	grayred = {0.5,0.4,0.4,1},
	grayblue = {0.4,0.4,0.45,1},
	transblack = {0,0,0,0.3},
	transblack2 = {0,0,0,0.7},
	transGray = {0.1,0.1,0.1,0.8},
	
	empty = {0,0,0,0},
	null = {nil, nil, nil, 1},
	transnull = {nil, nil, nil, 0.3},
	transnull2 = {nil, nil, nil, 0.5},
	transnull3 = {nil, nil, nil, 0.8},
}

color.tooltip_bg = color.transnull3
color.tooltip_fg = color.null
color.tooltip_info = color.cyan
color.tooltip_help = color.green

color.main_bg = color.transnull3
color.main_fg = color.null

color.menu_bg = color.null
color.menu_fg = color.null

color.game_bg = color.null
color.game_fg = color.null

color.sub_bg	= color.transnull
color.sub_fg 	= color.null
color.sub_header = color.yellow

color.sub_button_bg = color.null
color.sub_button_fg = color.null

color.sub_back_bg = color.null
color.sub_back_fg = color.null

color.sub_close_bg = color.null
color.sub_close_fg = color.null

color.stats_bg = color.sub_bg
color.stats_fg = color.sub_fg
color.stats_header = color.sub_header

color.context_bg = color.transnull
color.context_fg = color.null
color.context_header = color.yellow

color.disabled_bg = color.transGray
color.disabled_fg = color.darkgray

confdata.color = color

local spSendCommands = Spring.SendCommands

confdata.eopt = {}

local function nullFunc()
end

local function AddOption(path, option)
	option.path = path or "Settings\Broken Paths"
	if not option.key then
		option.key = option.name
	end
	table.insert(confdata.eopt, option)
end

--ShortHand for adding a button
local function ShButton(path, caption, action2, tooltip, advanced, icon, DisableFunc)
	AddOption(path,
	{
		type='button',
		name=caption,
		desc = tooltip or '',
		action = (type(action2) == 'string' and action2 or nil),
		OnChange = (type(action2) ~= 'string' and action2 or nil),
		key=caption,
		advanced = advanced,
		icon = icon,
		DisableFunc = DisableFunc or nil, --function that trigger grey colour on buttons (not actually disable their functions, only coloured them grey)
	})
end


--ShortHand for adding radiobuttons
local function ShRadio(path, caption, items,defValue, action2, advanced, nhk) 
	AddOption(path,
	{
		type='radioButton', 
		name=caption,
		key=caption,
		items = items or {},
		value = defValue or '',
		action = (type(action2) == 'string' and action2 or nil),
		OnChange = (type(action2) ~= 'string' and action2 or nil),
		advanced = advanced,
		noHotkey = nhk,
	})
end

--ShortHand for adding a label
local function ShLabel(path, caption)
	AddOption(path,
	{
		type='label',
		name=caption,
		value = caption,
		key=caption,
	})
end


local imgPath = LUAUI_DIRNAME  .. 'images/'
confdata.subMenuIcons = {
	['Game'] = imgPath..'epicmenu/game.png',
	['Settings'] = imgPath..'epicmenu/settings.png',
	['Help'] = imgPath..'epicmenu/questionmark.png',
	
	['Game/Game Speed'] 			= imgPath..'epicmenu/speed-test-icon.png',
	['Game/New Unit States'] 		= imgPath..'epicmenu/robot2.png',
	['Game/Unit Behaviour'] 		= imgPath..'epicmenu/robot2.png',
	['Game/Transport AI'] 			= imgPath..'epicmenu/robot2.png',
	['Game/Worker AI'] 				= imgPath..'commands/Bold/build_light.png',
	['Game/Unit Marker'] 			= imgPath..'epicmenu/marker.png',
	['Game/Construction Hotkeys'] 	= imgPath..'epicmenu/keyboard.png',
	['Game/Selection Hotkeys'] 		= imgPath..'epicmenu/keyboard.png',
	['Game/Command Hotkeys'] 		= imgPath..'epicmenu/keyboard.png',
	
	['Settings/Reset Settings'] 	= imgPath..'epicmenu/undo.png',
	['Settings/Audio'] 				= imgPath..'epicmenu/vol.png',
	['Settings/Camera'] 			= imgPath..'epicmenu/video_camera.png',
	['Settings/Graphics'] 			= imgPath..'epicmenu/graphics.png',
	['Settings/HUD Panels'] 		= imgPath..'epicmenu/control_panel.png',
	['Settings/Interface'] 			= imgPath..'epicmenu/robotarm.png',
	['Settings/Misc'] 				= imgPath..'epicmenu/misc.png',
	
	['Settings/Interface/Mouse Cursor'] 		= imgPath..'epicmenu/input_mouse.png',
	['Settings/Interface/Map'] 					= imgPath..'epicmenu/map.png',
	['Settings/Interface/Healthbars'] 			= imgPath..'commands/Bold/health.png',
	['Settings/Interface/Retreat Zones'] 		= imgPath..'commands/Bold/retreat.png',
	['Settings/Interface/Spectating'] 			= imgPath..'epicmenu/popcorn.png',
	['Settings/Interface/Building Placement'] 	= imgPath..'factory.png',
	['Settings/Interface/Team Colors'] 	= imgPath..'map/minimap_colors_simple.png',
	['Settings/Interface/Common Team Colors'] 	= imgPath..'map/minimap_colors_simple.png',
	['Settings/Interface/Build ETA'] 			= imgPath..'epicmenu/stop_watch_icon.png',
	['Settings/Interface/Defense Ranges'] 		= imgPath..'epicmenu/target.png',
	['Settings/Interface/Command Visibility'] 	= imgPath..'epicmenu/fingertap.png',
	['Settings/Interface/Hovering Icons'] 		= imgPath..'epicmenu/halo.png',
	['Settings/Interface/Selection'] 			= imgPath..'epicmenu/selection.png',
	['Settings/Interface/Control Groups'] 		= imgPath..'epicmenu/addusergroup.png',
	
	
	['Settings/HUD Panels/Minimap'] 				= imgPath..'epicmenu/map.png',
	['Settings/HUD Panels/Economy Panel']	 		= imgPath..'cost.png',
	['Settings/HUD Panels/Commander Selector'] 		= imgPath..'epicmenu/corcommander.png',
	['Settings/HUD Panels/Tooltip'] 				= imgPath..'epicmenu/lightbulb.png',
	['Settings/HUD Panels/Chat'] 					= imgPath..'advplayerslist/chat.png',
	['Settings/HUD Panels/FactoryPanel'] 			= imgPath..'factory.png',
	['Settings/HUD Panels/Pause Screen'] 			= imgPath..'epicmenu/media_playback_pause.png',
	['Settings/HUD Panels/Replay Controls'] 		= imgPath..'epicmenu/key_play_pause.png',
	['Settings/HUD Panels/Unit Stats Help Window'] 	= imgPath..'advplayerslist/random.png',
	['Settings/HUD Panels/Player List'] 			= imgPath..'epicmenu/people.png',
	['Settings/HUD Panels/Extras/Docking'] 				= imgPath..'epicmenu/anchor.png',
	['Settings/HUD Panels/Selected Units Panel'] 	= imgPath..'epicmenu/grid.png',
}

-- SETUP MENU HERE

ShButton('', 'Save Game', (function() if WG.SaveGame then WG.SaveGame.CreateSaveWindow() end end), nil, nil, imgPath .. 'commands/Bold/unload.png')
ShButton('', 'Load Game', (function() if WG.SaveGame then WG.SaveGame.CreateLoadWindow() end end), nil, nil, imgPath .. 'commands/Bold/load.png')

--- GENERAL SETTINGS --- settings about settings
local generalPath = 'Settings/Reset Settings'
	ShLabel(generalPath, 'Reset graphic settings to minimum.')
	ShButton(generalPath, 'Reset graphic settings',function()
					spSendCommands{"water 0",
						"Shadows 0",
						"maxparticles 100",
						"advmodelshading 0",
						"grounddecals 0",
						'luaui disablewidget LupsManager',
						"luaui disablewidget Lups",
						"luaui disablewidget Display DPS",
						"luaui disablewidget Map Edge Extension",
						'mapborder 1',
						"luaui disablewidget SelectionHalo",
						"luaui disablewidget SelectionCircle",
					}
				end,
				'Use this if your performance is poor'
			)
	ShLabel(generalPath, 'Reset custom settings to default.')
	ShButton(generalPath, 'Reset custom settings', function() WG.crude.ResetSettings() end)
	ShLabel(generalPath, 'Reset hotkeys.')
	ShButton(generalPath, 'Reset hotkeys',function() WG.crude.ResetKeys() end)


local settingsPath = 'Settings'
	--[[
	AddOption(settingsPath,
	{
		name = 'Show Advanced Settings',
		type = 'bool',
		value = false,
	})
	--]]


--- GAME --- Stuff for gameplay only. Spectator would never need to open this
local gamePath = 'Game' 
local gameSpeedPath = 'Game/Game Speed'

	ShButton(gamePath, 'Pause/Unpause', 'pause', nil, nil, imgPath .. 'epicmenu/media_playback_pause.png')
		ShButton(gameSpeedPath, 'Increase Speed', 'speedup')
		ShButton(gameSpeedPath, 'Decrease Speed', 'slowdown')
		
	ShLabel(gamePath, '')
	ShButton(gamePath, 'Choose Commander Type', (function() spSendCommands{"luaui showstartupinfoselector"} end), nil, nil, imgPath..'epicmenu/corcommander.png' ) 
	
	--ShButton(gamePath, 'Constructor Auto Assist', function() spSendCommands{"luaui togglewidget Constructor Auto Assist"} end)

--- CAMERA ---
local cameraPath = 'Settings/Camera'
	--[[
		the problem is "radioButton" is not fully implemented to recognize the item "viewta" as an existing action,
		so the hotkey Ctrl+F2 doesn't show in the menu, and thus cannot be unbound. A proposed solution is to enable both "radioButton" 
		& old camera button, but put the later in saperate category.
	--]]

	local cofcDisable = "luaui disablewidget Combo Overhead/Free Camera (experimental)"
	ShRadio( cameraPath,
		'Camera Type', {
			{name = 'Total Annihilation',key='Total Annihilation', desc='TA camera', hotkey=nil},
			{name = 'FPS',key='FPS', desc='FPS camera', hotkey=nil},
			{name = 'Free',key='Free', desc='Freestyle camera', hotkey=nil},
			{name = 'Rotatable Overhead',key='Rotatable Overhead', desc='Rotatable Overhead camera', hotkey=nil},
			{name = 'Total War',key='Total War', desc='TW camera', hotkey=nil},
			{name = 'COFC',key='COFC', desc='Combo Overhead/Free Camera', hotkey=nil},
		},'Total Annihilation',
		function(self)
			local key = self.value
			if key == 'Total Annihilation' then
				spSendCommands{cofcDisable ,"viewta"}
			elseif key == 'FPS' then
				spSendCommands{cofcDisable ,"viewfps"}
			elseif key == 'Free' then
				spSendCommands{cofcDisable ,"viewfree"}
			elseif key == 'Rotatable Overhead' then
				spSendCommands{cofcDisable ,"viewrot"}
			elseif key == 'Total War' then
				spSendCommands{cofcDisable ,"viewtw"}
			elseif key == 'COFC' then
				spSendCommands{"luaui enablewidget Combo Overhead/Free Camera (experimental)",}
			end
		end
		)
	
	ShButton(cameraPath, 'Flip the TA Camera', 'viewtaflip')

local oldCameraPath = 'Settings/Camera/Old Camera Shortcuts'	
	ShButton(oldCameraPath, 'Total Annihilation', 'viewta')
	ShButton(oldCameraPath, 'FPS', 'viewfps')
	ShButton(oldCameraPath, 'Free', 'viewfree')
	ShButton(oldCameraPath, 'Rotatable Overhead', 'viewrot')
	ShButton(oldCameraPath, 'Total War', 'viewtw')
	ShLabel(oldCameraPath, '')
	ShButton(oldCameraPath, 'Move Forward', 'moveforward')	
	ShButton(oldCameraPath, 'Move Back', 'moveback')	
	ShButton(oldCameraPath, 'Move Left', 'moveleft')	
	ShButton(oldCameraPath, 'Move Right', 'moveright')
	ShLabel(oldCameraPath, ' ')
	ShButton(oldCameraPath, 'TA camera track unit', 'track')
	ShButton(oldCameraPath, 'Overview mode', 'toggleoverview')
	ShButton(oldCameraPath, 'Panning mode','mousestate', 'Note: must be bound to a key for use')
	
	
--- HUD Panels --- Only settings that pertain to windows/icons at the drawscreen level should go here.
local HUDPath = 'Settings/HUD Panels/Extras'
	ShButton(HUDPath, 'Tweak Mode (Esc to exit)', 'luaui tweakgui', 'Tweak Mode. Move and resize parts of the user interface. (Hit Esc to exit)')
	ShButton(HUDPath .. "/Display Keys", 'Toggle input visualizer', function() spSendCommands{"luaui togglewidget Display Keys"} end, "Shows pressed key combinations and mouse buttons.")

local HUDSkinPath = 'Settings/HUD Panels/Extras/HUD Skin'
	AddOption(HUDSkinPath,
	{
		name = 'Skin Sets (Requires LuaUI Reload)',
		type = 'list',
		OnChange = function (self)
			WG.crude.SetSkin( self.value );
		end,
		items = {
			{ key = 'Blueprint', name = 'Blueprint', },
			{ key = 'Carbon', name = 'Carbon', },
			{ key = 'Robocracy', name = 'Robocracy', },
			--{ key = 'DarkGlass', name = 'DarkGlass', }, -- Broken
			{ key = 'DarkHive', name = 'DarkHive', },
			{ key = 'DarkHiveSquare', name = 'DarkHive (square)', },
			{ key = 'Evolved', name = 'Evolved', },
			--{ key = 'Glass', name = 'Glass', }, -- Broken
			{ key = 'Twilight', name = 'Twilight', },
		},
	})
	ShButton(HUDSkinPath, 'Reload LuaUI', 'luaui reload', 'Reloads the entire UI. NOTE: This button will not work. You must bind a hotkey to this command and use the hotkey.')


--- Interface --- anything that's an interface but not a HUD Panel
local pathInterface = 'Settings/Interface'
local pathMouse = 'Settings/Interface/Mouse Cursor'
	AddOption(pathMouse,
	{ 	
		name = 'Hardware Cursor',
		type = 'bool',
		springsetting = 'HardwareCursor',
		noHotkey = true,
		OnChange=function(self) spSendCommands{"hardwarecursor " .. (self.value and 1 or 0) } end, 
	})	
	
local pathSelectionShapes = 'Settings/Interface/Selection/Selection Shapes'
local pathSelectionXrayHalo = 'Settings/Interface/Selection/Selection XRay&Halo'
local pathSelectionPlatters = 'Settings/Interface/Selection/Team Platters'
local pathSelectionBluryHalo = 'Settings/Interface/Selection/Blurry Halo Selections'
	ShButton(pathSelectionShapes, 'Toggle Selection Shapes', function() spSendCommands{"luaui togglewidget UnitShapes"} end, "Draws coloured shapes under selected units")
	ShButton(pathSelectionXrayHalo, 'Toggle Selection XRay&Halo', function() spSendCommands{"luaui togglewidget XrayHaloSelections"} end, "Highlights bodies of selected units")	
	ShButton(pathSelectionPlatters, 'Toggle Team Platters', function() spSendCommands{"luaui togglewidget TeamPlatter"} end, "Puts team-coloured disk below units")
	ShButton(pathSelectionBluryHalo, 'Toggle Blurry Halo Selections', function() spSendCommands{"luaui togglewidget Selection BlurryHalo"} end, "Places blurry halo around selected units")

  
--- MISC --- Ungrouped. If some of the settings here can be grouped together, make a new subsection or its own section.
local pathMisc = 'Settings/Misc'
	ShButton(pathMisc, 'Local Widget Config', function() spSendCommands{"luaui localwidgetsconfig"} end, '', true)
	ShButton(pathMisc, 'Game Info', "gameinfo", '', true)
	ShButton(pathMisc, 'Share Dialog...', 'sharedialog', '', true)
	ShButton(pathMisc, 'FPS Control', "controlunit", 'Control a unit directly in FPS mode.', true)
	--ShButton( 'Exit Game...', "exitwindow", '', false ) --this breaks the exitwindow, fixme
	AddOption(pathMisc,
	{
		name = 'Menu pauses in SP',
		desc = 'Does opening the menu pause the game (and closing unpause it) in single player?',
		type = 'bool',
		value = true,
		noHotkey = true,
	})
	AddOption(pathMisc,
	{
		name = 'Use uikeys.txt',
		desc = 'NOT RECOMMENDED! Enable this to use the engine\'s keybind file. This can break existing functionality. Requires restart.',
		type = 'bool',
		advanced = true,
		noHotkey = true,
		value = false,
	})
	AddOption(pathMisc,
	{
		name = 'Use Old Chili',
		desc = 'Enable this if menu element is missing or does not render properly in Spring 96+. '..
				'Do NOT enable if you see nothing wrong with the menu (it is slower).'..
				'\n(type "/luaui reload" to apply settings)',
		type = 'bool',
		value = false,
		noHotkey = true,
		OnChange = function (self)
			local value = (self.value and 1) or 0 --true = 1, false = 0
			if self.value then
				Spring.Echo("Will use old Chili")
			else
				Spring.Echo("Will use new Chili")
			end
			Spring.SetConfigInt("ZKuseOldChili", value); --store in Springsettings.txt because api_chili.lua must read it independent of gui_epicmenu.lua
		end,
	})	


local pathMiscScreenshots = 'Settings/Misc/Screenshots'	
	ShButton(pathMiscScreenshots, 'Save Screenshot (PNG)', 'screenshot png', 'Find your screenshots under Spring/screenshots') 
	ShButton(pathMiscScreenshots, 'Save Screenshot (JPG)', 'screenshot jpg', 'Find your screenshots under Spring/screenshots')
	ShButton(pathMiscScreenshots, 
			'Create Video (risky)', 'createvideo', 'Capture video directly from Spring without sound. Gets saved in the Spring folder. '
			..'Creates a smooth video framerate without ingame stutter. '
			..'Caution: It\'s safer to use this in windowed mode because the encoder pop-up menu appears in the foreground window, and could crash the game with a "Fatal Error" after a long recording. '
			..'\n\nRecommendation (especially for low-end PCs): After activating the video recording select the fastest encoder such as Microsoft Video and record the video in segments. '
			..' You can then use VirtualDub (opensource software) to do futher compression and editing. Note: there is other opensource video capture software like Taksi that you could try.') 
	
--- GRAPHICS --- We might define section as containing anything graphical that has a significant impact on performance and isn't necessary for gameplay
local pathGraphicsMap = 'Settings/Graphics/Map Detail'
	
	ShRadio( pathGraphicsMap,
		'Water rendering', {
			{name = 'Basic',key='0', desc='A simple plane.', icon=imgPath..'epicmenu/water.png'},
			{name = 'Reflective',key='1', desc='Reflects the world.', icon=imgPath..'epicmenu/water.png'},
			{name = 'Dynamic',key='2', desc='Has waves and wakes when units move and projectiles explode.', icon=imgPath..'epicmenu/water.png'},
			{name = 'Reflective / Refractive',key='3', desc='Reflects the world and has distortions.', icon=imgPath..'epicmenu/water.png'},
			{name = 'Bumpmapped',key='4', desc='Fast and good-looking.', icon=imgPath..'epicmenu/water.png'},
		},'4',
		function(self)
			spSendCommands{"water " .. self.value}
		end,
		false,
		true
	)

	ShRadio( pathGraphicsMap,
		'Shadows cast by', {
			{name = 'Nothing',key='0', desc='Shadows disabled.'},
			{name = 'Units',key='2', desc='Only units cast shadows.'},
			{name = 'Units and terrain',key='1', desc='Terrain can cast shadows onto lower terrain. Units also cast shadows.'},
		},'1',
		function(self)
			spSendCommands{"Shadows " .. self.value}
		end,
		false,
		true
	)
	AddOption(pathGraphicsMap, 
	{
		name = 'Shadow detail level',
		desc = 'How detailed shadows are.',
		type = 'number',
		valuelist = {512, 1024, 2048, 4096},
		springsetting = 'ShadowMapSize',
		OnChange=function(self)
			local curShadow = Spring.GetConfigInt("Shadows") or 0
			spSendCommands{"Shadows " .. curShadow .. ' ' .. self.value}
		end, 
	})

	ShLabel(pathGraphicsMap, 'Miscellaneous')
	AddOption(pathGraphicsMap, 
	{
		name = 'Map Brightness',
		desc = 'How bright the terrain appears.',
		type = 'number',
		min = 0, 
		max = 1, 
		step = 0.01,
		value = 1,
		icon = imgPath..'epicmenu/stock_brightness.png',
		OnChange = function(self) spSendCommands{"luaui enablewidget Darkening", "luaui darkening " .. 1-self.value} end, 
	} )

	AddOption(pathGraphicsMap, 
	{
		name = 'Terrain geometry detail',
		desc = 'How detailed the terrain geometry is.',
		type = 'number',
		min = 32, 
		max = 256, 
		step = 8,
		value = 128,
		OnChange = function(self) spSendCommands{"GroundDetail " .. self.value} end, 
	})

	AddOption(pathGraphicsMap, 
	{
		name = 'Ground Decals',
		desc = 'Whether explosions leave scars on the ground.',
		type = 'bool',
		springsetting = 'GroundDecals',
		OnChange=function(self) spSendCommands{"grounddecals " .. (self.value and 1 or 0) } end,
		noHotkey = true,
	} )
	
	--ShButton(pathGraphicsMap, 'Toggle ROAM Rendering', function() spSendCommands{"roam"} end, "Toggle between legacy map rendering and (the new) ROAM map rendering." )

local pathGraphicsExtras = 'Settings/Graphics/Effects'
	AddOption(pathGraphicsExtras, 
	{
		name = 'Particle density',
		desc = 'How many visual effects can exist at the same time.',
		type = 'number',
		min = 250, 
		max = 20000, 
		step = 250,
		value = 10000,
		springsetting = 'MaxParticles',
		OnChange=function(self) spSendCommands{"maxparticles " .. self.value } end, 
	} )
	ShButton(pathGraphicsExtras, 'Toggle Lups (Lua Particle System)', function() spSendCommands{'luaui togglewidget LupsManager','luaui togglewidget Lups'} end )
	ShButton(pathGraphicsExtras, 'Toggle Nightvision', function() spSendCommands{'luaui togglewidget Nightvision Shader'} end, 'Applies a nightvision filter to screen')
	ShButton(pathGraphicsExtras, 'Smoke Signal Markers', function() spSendCommands{'luaui togglewidget Smoke Signal'} end, 'Creates a smoke signal effect at map points' )
	ShButton(pathGraphicsExtras, 'Toggle Night View', function() spSendCommands{'luaui togglewidget Night'} end, 'Adds a day/night cycle effect' )

	
local pathUnitVisiblity = 'Settings/Graphics/Unit Visibility'
	ShLabel(pathUnitVisiblity, 'Unit Visibility Options')
	AddOption(pathUnitVisiblity,
	{
		name = 'Draw Distance',
		type = 'number',
		min = 1, 
		max = 10000,
		springsetting = 'UnitLodDist',
		OnChange = function(self) spSendCommands{"distdraw " .. self.value} end 
	} )
	AddOption(pathUnitVisiblity,
	{
	  name = 'Icon Distance',
	  type = 'number',
	  min = 1, 
	  max = 1000,
	  springsetting = 'UnitIconDist',
	  OnChange = function(self) spSendCommands{"disticon " .. self.value} end 
	  } )
	AddOption(pathUnitVisiblity,
	{
		name = 'Shiny Units',
		type = 'bool',
		springsetting = 'AdvUnitShading',
		OnChange=function(self) spSendCommands{"advmodelshading " .. (self.value and 1 or 0) } end, --needed as setconfigint doesn't apply change right away
		noHotkey = true,
	} )
	ShLabel(pathUnitVisiblity, 'Unit Visibility Widgets')
	ShButton(pathUnitVisiblity,'Toggle Unit Halos', function() spSendCommands{"luaui togglewidget Halo"} end, "Shows halo around units")
	
	local pathSpotter = 'Settings/Graphics/Unit Visibility/Spotter'
		ShButton(pathSpotter, 'Toggle Unit Spotter', function() spSendCommands{"luaui togglewidget Spotter"} end, "Puts team-coloured blob below units")
	local pathXrayShader = 'Settings/Graphics/Unit Visibility/XRay Shader'
		ShButton(pathXrayShader, 'Toggle XRay Shader', function() spSendCommands{"luaui togglewidget XrayShader"} end, "Highlights edges of units")
	local pathUnitOutline = 'Settings/Graphics/Unit Visibility/Outline'
		ShButton(pathUnitOutline, 'Toggle Unit Outline', function() spSendCommands{"luaui togglewidget Outline"} end, "Highlights edges of units")


local pathAudio = 'Settings/Audio'
	AddOption(pathAudio,{
		name = 'Master Volume',
		type = 'number',
		min = 0, 
		max = 100,
		springsetting = 'snd_volmaster',
		OnChange = function(self) spSendCommands{"set snd_volmaster " .. self.value} end
	})
	AddOption(pathAudio,{
		name = 'Music Volume',
		type = 'number',
		min = 0, 
		max = 1,
		step = 0.01,
		value = WG.music_volume or 0.5,
		OnChange = function(self)	
			if (WG.music_start_volume or 0 > 0) then 
				Spring.SetSoundStreamVolume(self.value / WG.music_start_volume) 
			else 
				Spring.SetSoundStreamVolume(self.value) 
			end
			local prevValue = WG.music_volume
			--settings.music_volume = self.value
			WG.music_volume = self.value
			if (prevValue > 0 and self.value <=0) then widgetHandler:DisableWidget("Music Player") end 
			if (prevValue <=0 and self.value > 0) then widgetHandler:EnableWidget("Music Player") end 
		end,
	})
		
--- HELP ---
local pathHelp = 'Help'
	AddOption(pathHelp,
	{
		type='text',
		name='Tips',
		value=[[Hold your meta-key (spacebar by default) while clicking on a unit or corpse for more info and options. 
			You can also space-click on menu elements to see context settings. 
			]]
	})
	ShButton(pathHelp,'Tutorial', function() spSendCommands{"luaui togglewidget Nubtron"} end )
	ShButton(pathHelp,'Tip Dispenser', function() spSendCommands{"luaui togglewidget Automatic Tip Dispenser"} end, 'An advisor which gives you tips as you play' )
local pathClippy = 'Help/Clippy Comments'
	ShButton(pathClippy, 'Toggle Clippy Comments', function() spSendCommands{"luaui togglewidget Clippy Comments"} end, "Units speak up if they see you're not playing optimally" )

--- MISC
--

return confdata
