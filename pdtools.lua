script_name("PD Tools")
script_authors("junior")
script_version("0.3")

local limgui, imgui = pcall(require, 'imgui')
local lrkeys, rkeys = pcall(require, 'rkeys')
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local hook = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local key = require 'vkeys'
local keys = require 'game.keys'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local fonthud = renderCreateFont('Arial', 10, 4)

local autoBP = 1
local checkstat = false
local canupdate = false
local suz = {}
local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
local tCarsTypeName = {"Автомобиль", "Мотоицикл", "Вертолёт", "Самолёт", "Прицеп", "Лодка", "Другое", "Поезд", "Велосипед"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}

local hudtazer = "Деактивирован"
local hudposedit = false

local mainIni = inicfg.load({
config =
{
color = false,
colorid = 0,
tag = false,
tagtext = '',
doklad = false,
dokladkey = 'R',
meg = false,
megkey = 'B',
tazer = false,
tazerkey = 'Z',
takeme = false,
ticketme = false,
cejectme = false,
arrestme = false,
dejectme = false,
cuffme = false,
uncuffme = false,
followme = false,
deagle = false,
deaglept = false,
shot = false,
shotpt = false,
smg = false,
smgpt = false,
M4A1 = false,
M4A1pt = false,
rifle = false,
riflept = false,
armour = false,
specgun = false,
hudwindow = false,
hposx = 100,
hposy = 650
}
}, "pdtools")

local color = imgui.ImBool(mainIni.config.color)
local colorid = imgui.ImInt(mainIni.config.colorid)
local tag = imgui.ImBool(mainIni.config.tag)
local tagtext = imgui.ImBuffer(u8(mainIni.config.tagtext), 256)
local doklad = imgui.ImBool(mainIni.config.doklad)
local dokladkey = imgui.ImBuffer(mainIni.config.dokladkey, 256)
local meg = imgui.ImBool(mainIni.config.meg)
local megkey = imgui.ImBuffer(mainIni.config.megkey, 256)
local tazer = imgui.ImBool(mainIni.config.tazer)
local tazerkey = imgui.ImBuffer(mainIni.config.tazerkey, 256)

local takeme = imgui.ImBool(mainIni.config.takeme)
local ticketme = imgui.ImBool(mainIni.config.ticketme)
local cejectme = imgui.ImBool(mainIni.config.cejectme)
local arrestme = imgui.ImBool(mainIni.config.arrestme)
local dejectme = imgui.ImBool(mainIni.config.dejectme)
local cuffme = imgui.ImBool(mainIni.config.cuffme)
local uncuffme = imgui.ImBool(mainIni.config.uncuffme)
local followme = imgui.ImBool(mainIni.config.followme)

local deagle = imgui.ImBool(mainIni.config.deagle)
local deaglept = imgui.ImBool(mainIni.config.deaglept)
local shot = imgui.ImBool(mainIni.config.shot)
local shotpt = imgui.ImBool(mainIni.config.shotpt)
local smg = imgui.ImBool(mainIni.config.smg)
local smgpt = imgui.ImBool(mainIni.config.smgpt)
local M4A1 = imgui.ImBool(mainIni.config.M4A1)
local M4A1pt = imgui.ImBool(mainIni.config.M4A1pt)
local rifle = imgui.ImBool(mainIni.config.rifle)
local riflept = imgui.ImBool(mainIni.config.riflept)
local armour = imgui.ImBool(mainIni.config.armour)
local specgun = imgui.ImBool(mainIni.config.specgun)
local hudwindow = imgui.ImBool(mainIni.config.hudwindow)
local hposx = mainIni.config.hposx
local hposy = mainIni.config.hposy
local status = inicfg.load(mainIni, 'pdtools.ini')
if not doesFileExist('moonloader/config/pdtools.ini') then inicfg.save(mainIni, 'pdtools.ini') end

local main_window_state = imgui.ImBool(false)
local main_window_stats = imgui.ImBool(false)
local imegaf = imgui.ImBool(false)
local akwindow = imgui.ImBool(false)
local ykwindow = imgui.ImBool(false)
local kshwindow = imgui.ImBool(false)
local fpwindow = imgui.ImBool(false)
local fastmenu = imgui.ImBool(false)
local updatewindow = imgui.ImBool(false)
function imgui.OnDrawFrame()
	if main_window_state.v then
		imgui.ShowCursor = true
		imgui.SetNextWindowSize(imgui.ImVec2(655, 450), imgui.Cond.FirstUseEver)
		imgui.Begin(script.this.name..' | ver.'..script.this.version, main_window_state, imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoCollapse)
		imgui.BeginChild('##set', imgui.ImVec2(140, 400), true)
		if imgui.Selectable(u8'Основное', show == 1) then show = 1 end
		if imgui.Selectable(u8'Отыгровки', show == 2) then show = 2 end
		if imgui.Selectable(u8'Авто-БП', show == 3) then show = 3 end
		if imgui.Selectable(u8'Помощь', show == 4) then show = 4 end
		if canupdate then if imgui.Selectable(u8'Обновление', show == 5) then  updatewindow.v = true end end
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild('##set1', imgui.ImVec2(475, 400), true)
			if show == 1 then
				if imgui.Checkbox(u8"Авто клист", color) then mainIni.config.color = color.v inicfg.save(mainIni, 'pdtools.ini') end
				if color.v then
					imgui.SameLine(150)
					if imgui.InputInt(u8' ', colorid, 1, 10) then
						if colorid.v < 0 then colorid.v = 0 end
						if colorid.v > 32 then colorid.v = 32 end mainIni.config.colorid = colorid.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Авто тег", tag) then mainIni.config.tag = color.v inicfg.save(mainIni, 'pdtools.ini') end
				if tag.v then
					imgui.SameLine(150)
					if imgui.InputText(u8'  ', tagtext) then mainIni.config.tagtext = u8:decode(tagtext.v) inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Доклад", doklad) then mainIni.config.doklad = doklad.v inicfg.save(mainIni, 'pdtools.ini') end
				if doklad.v then
					imgui.SameLine(150)
					if imgui.InputText(u8'##set3', dokladkey) then mainIni.config.dokladkey = dokladkey.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Мегафон", meg) then mainIni.config.meg = meg.v inicfg.save(mainIni, 'pdtools.ini') end
				if meg.v then
					imgui.SameLine(150)
					if imgui.InputText(u8'##set4', megkey) then mainIni.config.megkey = megkey.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Тазер", tazer) then mainIni.config.tazer = tazer.v inicfg.save(mainIni, 'pdtools.ini') end
				if tazer.v then
					imgui.SameLine(150)
					if imgui.InputText(u8'##set4', tazerkey) then mainIni.config.tazerkey = tazerkey.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Худ", hudwindow) then mainIni.config.hudwindow = hudwindow.v inicfg.save(mainIni, 'pdtools.ini') end
				if hudwindow.v then
					imgui.SameLine(150)
					if imgui.Button(u8'Изменить позицию') then hudposedit = not hudposedit end
				end
			end
			if show == 2 then
				if imgui.Checkbox(u8"take", takeme) then mainIni.config.takeme = takeme.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"ticket", ticketme) then mainIni.config.ticketme = ticketme.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"ceject", cejectme) then mainIni.config.cejectme = cejectme.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"arrest", arrestme) then mainIni.config.arrestme = arrestme.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"follow", followme) then mainIni.config.followme = followme.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"deject", dejectme) then mainIni.config.dejectme = dejectme.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"cuff", cuffme) then mainIni.config.cuffme = cuffme.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"uncuff", uncuffme) then mainIni.config.uncuffme = uncuffme.v inicfg.save(mainIni, 'pdtools.ini') end
			end
			if show == 3 then
				if imgui.Checkbox(u8"Desert Eagle", deagle) then mainIni.config.deagle = deagle.v inicfg.save(mainIni, 'pdtools.ini') end
				if deagle.v then
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Два комплекта##1", deaglept) then mainIni.config.deaglept = deaglept.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Shotgun", shot) then mainIni.config.shot = shot.v inicfg.save(mainIni, 'pdtools.ini') end
				if shot.v then
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Два комплекта##2", shotpt) then mainIni.config.shotpt = shotpt.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"SMG", smg) then mainIni.config.smg = smg.v inicfg.save(mainIni, 'pdtools.ini') end
				if smg.v then
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Два комплекта##3", smgpt) then mainIni.config.smgpt = smgpt.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"M4A1", M4A1) then mainIni.config.M4A1 = M4A1.v inicfg.save(mainIni, 'pdtools.ini') end
				if M4A1.v then
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Два комплекта##4", M4A1pt) then mainIni.config.M4A1pt = M4A1pt.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Rifle", rifle) then mainIni.config.rifle = rifle.v inicfg.save(mainIni, 'pdtools.ini') end
				if rifle.v then
					imgui.SameLine(150)
					if imgui.Checkbox(u8"Два комплекта##5", riflept) then mainIni.config.riflept = riflept.v inicfg.save(mainIni, 'pdtools.ini') end
				end
				if imgui.Checkbox(u8"Броня", armour) then mainIni.config.armour = armour.v inicfg.save(mainIni, 'pdtools.ini') end
				if imgui.Checkbox(u8"Спец оружие", specgun) then mainIni.config.specgun = specgun.v inicfg.save(mainIni, 'pdtools.ini') end
			end
			if show == 4 then
				imgui.Text(u8'/fkv - Поставить метку на квадрат')
				imgui.Text(u8'/su - Выдать звёзды через диалог')
				imgui.Text(u8'/ak - Административный Кодекс')
				imgui.Text(u8'/yk - Уголовный Кодекс')
				imgui.Text(u8'/fp - Федеральное постановление')
				imgui.Text(u8'/ksh - Конституция штата')
				imgui.Separator()
				imgui.Text(u8'Клавиша \"F2\" - Быстрое меню')
			end
			imgui.EndChild()
		imgui.End()
	end
	if main_window_stats.v then
		imgui.ShowCursor = true
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.SetNextWindowSize(imgui.ImVec2(300, 265), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'PD Tools | Доклад', main_window_stats, imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoCollapse)
		imgui.Text(u8'Выберите состояние:')
		if imgui.Button(u8 'Спокойное', btn_size) then
			r('Состояние: Спокойное.'..' '..naparnik())
			main_window_stats.v = false
			imgui.ShowCursor = false
		end
		if imgui.Button(u8 'Нападение', btn_size) then
			r('Состояние: Нападение.'..' '..naparnik())
			main_window_stats.v = false
			imgui.ShowCursor = false
		end
		if imgui.Button(u8 'Перестрелка', btn_size) then
			r('Состояние: Перестрелка.'..' '..naparnik())
			main_window_stats.v = false
			imgui.ShowCursor = false
		end
		if imgui.Button(u8 'Погоня', btn_size) then
			r('Состояние: Погоня.'..' '..naparnik())
			main_window_stats.v = false
			imgui.ShowCursor = false
		end
		imgui.End()
	end
	if imegaf.v then
		imgui.ShowCursor = true
		local x, y = getScreenResolution()
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(x/2+300, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8(script.this.name..' | Мегафон'), imegaf, imgui.WindowFlags.NoResize)
		for k, v in ipairs(incar) do
			local mx, my, mz = getCharCoordinates(PLAYER_PED)
			if sampIsPlayerConnected(v) then
				local result, ped = sampGetCharHandleBySampPlayerId(v)
				if result then
					local px, py, pz = getCharCoordinates(ped)
					local dist = math.floor(getDistanceBetweenCoords3d(mx, my, mz, px, py, pz))
					if isCharInAnyCar(ped) then
						local carh = storeCarCharIsInNoSave(ped)
						local carhm = getCarModel(carh)
						if imgui.Button(("%s [EVL%sX] | Distance: %s m.##%s"):format(tCarsName[carhm-399], v, dist, k), btn_size) then
							lua_thread.create(function()
								imegaf.v = false
								gmegafid = v
								gmegaflvl = sampGetPlayerScore(v)
								gmegaffrak = sampGetFraktionBySkin(v)
								gmegafcar = tCarsName[carhm-399]
								sampSendChat(("/m Водитель а/м %s [EVL%sX]"):format(tCarsName[carhm-399], v))
								wait(1400)
								sampSendChat("/m Прижмитесь к обочине или мы откроем огонь по колёсам!")
							end)
						end
					end
				end
			end
		end
		imgui.End()
	end
	if akwindow.v then
		if doesFileExist('moonloader/pdtools/ak.txt') then
			imgui.ShowCursor = true
			local iScreenWidth, iScreenHeight = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
			imgui.Begin(u8(script.this.name..' | Административный кодекс'), akwindow)
			for line in io.lines('moonloader\\pdtools\\ak.txt') do
				imgui.TextWrapped(u8(line))
			end
			imgui.End()
		else
			local file = io.open("moonloader/pdtools/ak.txt", "w")
      file:write("Шпора АК")
      file:close()
			akwindow.v = false
			imgui.ShowCursor = false
		end
	end
	if ykwindow.v then
		if doesFileExist('moonloader/pdtools/yk.txt') then
			imgui.ShowCursor = true
			local iScreenWidth, iScreenHeight = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
			imgui.Begin(u8(script.this.name..' | Уголовный кодекс'), ykwindow)
			for line in io.lines('moonloader\\pdtools\\yk.txt') do
				imgui.TextWrapped(u8(line))
			end
			imgui.End()
		else
      local file = io.open("moonloader/pdtools/yk.txt", "w")
      file:write("Шпора УК")
      file:close()
			ykwindow.v = false
			imgui.ShowCursor = false
		end
	end
	if kshwindow.v then
		if doesFileExist('moonloader/pdtools/ksh.txt') then
			imgui.ShowCursor = true
			local iScreenWidth, iScreenHeight = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
			imgui.Begin(u8(script.this.name..' | Конституция штата'), kshwindow)
			for line in io.lines('moonloader\\pdtools\\ksh.txt') do
				imgui.TextWrapped(u8(line))
			end
			imgui.End()
		else
			local file = io.open("moonloader/pdtools/ksh.txt", "w")
      file:write("Шпора КШ")
      file:close()
			kshwindow.v = false
			imgui.ShowCursor = false
		end
	end
	if fpwindow.v then
		if doesFileExist('moonloader/pdtools/fp.txt') then
			imgui.ShowCursor = true
			local iScreenWidth, iScreenHeight = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(iScreenWidth/2, iScreenHeight / 2), imgui.Cond.FirstUseEver)
			imgui.Begin(u8(script.this.name..' | Федеральное постановление'), fpwindow)
			for line in io.lines('moonloader\\pdtools\\fp.txt') do
				imgui.TextWrapped(u8(line))
			end
			imgui.End()
		else
			local file = io.open("moonloader/pdtools/fp.txt", "w")
      file:write("Шпора ФП")
      file:close()
			fpwindow.v = false
			imgui.ShowCursor = false
		end
	end
	if fastmenu.v then
		imgui.ShowCursor = true
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.SetNextWindowSize(imgui.ImVec2(300, 165), imgui.Cond.FirstUseEver)
		imgui.Begin(u8(script.this.name..' | Быстрое действие'), fastmenu, imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoCollapse)
		imgui.Text(u8'Выберите действие:')
		if imgui.Button(u8 'Представится', btn_size) then
			if frang == nil and ffrak == nil then
				lua_thread.create(checkStats)
			else
				lua_thread.create(function()
					sampSendChat(string.format('Здравствуйте, Я %s %s.', frang, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' ')))
					wait(1400)
					sampSendChat(string.format('/do Слева на груди жетон \"%s\" №000%s', ffrak, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
				end)
			end
			fastmenu.v = false
			imgui.ShowCursor = false
		end
		if imgui.Button(u8 'Попросить паспорт', btn_size) then
			sampSendChat(string.format('Предъявите ваши документы, для удовстверения личности. (( /showpass %s ))', select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
			fastmenu.v = false
			imgui.ShowCursor = false
		end
		if imgui.Button(u8 'Сообщить о задержании', btn_size) then
			lua_thread.create(function()
				sampSendChat('Вы арестованы!')
				wait(1400)
				sampSendChat('Вы имеете право хранить молчание, всё что вы скажите будет использовано против вас в суде.')
				wait(1400)
				sampSendChat('У вас есть один звонок адвокату.')
			end)
			fastmenu.v = false
			imgui.ShowCursor = false
		end
		imgui.End()
	end
	if updatewindow.v then
		imgui.ShowCursor = true
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.SetNextWindowSize(imgui.ImVec2(300, 110), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'PD Tools | Обновление', updatewindow, imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoCollapse)
		if imgui.Button(u8("Обновить"), btn_size) then
			lua_thread.create(goupdate)
		end
		if imgui.Button(u8("Отложить обновление"), btn_size) then
			ftext("Если вы захотите установить обновление введите команду {de7171}/pdtools")
			updatewindow.v = false
			imgui.ShowCursor = false
		end
		imgui.End()
	end
end

function main()
	while not isSampAvailable() do wait(0) end
		ftext("Автор: junior")
		ftext("Источник: vk.com/junior.soft")
		ftext("Открыть меню: /pdtools")
		sampRegisterChatCommand('oop', oop) --oop
		sampRegisterChatCommand('su', su) --розыск
		sampRegisterChatCommand('ar', ar) --запрос на въезд на тер армии
		sampRegisterChatCommand('gr', gr) --запрос на въезд в юресдикцию
		sampRegisterChatCommand('take', take) --Обыск
		sampRegisterChatCommand('ticket', ticket) --Выдача штрафа
		sampRegisterChatCommand('ceject', ceject) --Выкинуть с транспорта
		sampRegisterChatCommand('deject', deject) --Выкинуть из траспорта
		sampRegisterChatCommand('cput', cput) --Запихать в транспорт
		sampRegisterChatCommand('cuff', cuff) --Надеть наручники
		sampRegisterChatCommand('uncuff', uncuff) --Снять наручники
		sampRegisterChatCommand('arrest', arrest) --Посадить игрока
		sampRegisterChatCommand('follow', follow)
		sampRegisterChatCommand('fkv', fkv) --Поставить метку по квадрату
		sampRegisterChatCommand('r', r) --Авто тег
		sampRegisterChatCommand('ak', function()
			akwindow.v = not akwindow.v
			imgui.ShowCursor = akwindow.v
		end)
		sampRegisterChatCommand('yk', function()
			ykwindow.v = not ykwindow.v
			imgui.ShowCursor = ykwindow.v
		end)
		sampRegisterChatCommand('ksh', function()
			kshwindow.v = not kshwindow.v
			imgui.ShowCursor = kshwindow.v
		end)
		sampRegisterChatCommand('fp', function()
			fpwindow.v = not fpwindow.v
			imgui.ShowCursor = fpwindow.v
		end)
		sampRegisterChatCommand("pdtools", function()
			 main_window_state.v = not main_window_state.v
			 imgui.ShowCursor = main_window_state.v
		end)
		imgui.ShowCursor = false
		libs()
		update()
	while true do
		wait(0)
		imgui.Process = main_window_state.v or main_window_stats.v or imegaf.v or akwindow.v or ykwindow.v or kshwindow.v or fpwindow.v or fastmenu.v or updatewindow.v
		if hudwindow.v then
			renderBoxRounded(hposx, hposy, 250, 149, 6, 0xFF000000)
			renderFontDrawText(fonthud, 'Ник: '..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_', ' ')..'\nПинг: '..sampGetPlayerPing(sampGetPlayerIdByCharHandle(PLAYER_PED))..'\nЗдоровье: '..getCharHealth(PLAYER_PED)..'\nБроня: '..getCharArmour(PLAYER_PED)..'\n'..naparnik1()..'\nРайон: '..calculateZone(getCharCoordinates(PLAYER_PED))..'\nСектор: '..kvadrat()..'\nTAZER: '..hudtazer, hposx + 4, hposy + 8, 0xFFFFFFFF)
		end
		if sampIsDialogActive() == false and not isPauseMenuActive() and isPlayerPlaying(playerHandle) and sampIsChatInputActive() == false then
			if doklad.v then
				nkeyy = string.upper(tostring(dokladkey.v))
				if isKeyJustPressed(_G['VK_'..nkeyy]) and isKeyCheckAvailable() then
					r('Патрулирую сектор: '..kvadrat()..'. Район: '..calculateZone(getCharCoordinates(PLAYER_PED))..'.')
					main_window_stats.v = true
					imgui.ShowCursor = true
				end
			end
			if meg.v then
				nkeyy = string.upper(tostring(megkey.v))
				if isKeyJustPressed(_G['VK_'..nkeyy]) and isKeyCheckAvailable() then
					megaf()
				end
			end
			if tazer.v then
				nkeyy = string.upper(tostring(tazerkey.v))
				if isKeyJustPressed(_G['VK_'..nkeyy]) and isKeyCheckAvailable() then
					sampSendChat('/tazer')
				end
			end
			if hudposedit then
				sampSetCursorMode(1)
	      curX, curY = getCursorPos()
				hposx = curX
				hposy = curY
				if isKeyJustPressed(1) then
	        mainIni.config.hposx = curX
	        mainIni.config.hposy = curY
	        inicfg.save(mainIni, 'pdtools.ini')
	        sampSetCursorMode(0)
	        hudposedit = false
	      end
			end
			if wasKeyPressed(113) then fastmenu.v = not fastmenu.v end
			if coordX ~= nil and coordY ~= nil then
				cX, cY, cZ = getCharCoordinates(playerPed)
				cX = math.ceil(cX)
				cY = math.ceil(cY)
				cZ = math.ceil(cZ)
				ftext('Метка установлена на '..kvadY..'-'..kvadX)
				placeWaypoint(coordX, coordY, 0)
				coordX = nil
				coordY = nil
			end
		end
		local result17, button, list, input = sampHasDialogRespond(1765)
		if result17 then
			if button == 1 then
				if #input ~= 0 and tonumber(input) ~= nil then
					for k, v in pairs(suz) do
						if tonumber(input) == k then
							local reas, reas1, zzv = v:match('(.+): (.+) %- (%d+) .+')
							sampSendChat(string.format('/su %s %s %s', zid, zzv, reas))
							zid = nil
						end
					end
				else
					ftext('Вы не выбрали номер статьи')
				end
			end
		end
	end
end

function isKeyCheckAvailable()
  if not isSampfuncsLoaded() then
    return not isPauseMenuActive()
  end
  local result = not isSampfuncsConsoleActive() and not isPauseMenuActive()
  if isSampLoaded() and isSampAvailable() then
    result = result and not sampIsChatInputActive() and not sampIsDialogActive()
  end
  return result
end

function renderBoxRounded(x, y, w, h, r, color)
  renderDrawBox(x + r, y, w - r, h - 1, color)
  renderCircle(x + r, y, r * 4, math.pi, 3 * math.pi / 2, color)
  renderDrawBox(x - r + 1, y + r * 2 - 1, r * 2 - 1, h - r * 4, color)
  renderRound(x + r, y + h - r * 4, r * 4, math.pi / 2, math.pi, color)
  renderCircle(x + w, y, r * 4, 3 * math.pi / 2, 2 * math.pi, color)
  renderDrawBox(x + w, y + r * 2 - 1, r * 2, h - r * 4, color)
  renderCircle(x + w, y + h - r * 4, r * 4, 0, math.pi / 2, color)
end

function renderCircle(x, y, d, s, e, color)
  local r = math.ceil( d / 2 )
  y = y - 1.0
  renderBegin(6)
  local step = math.abs(((e < 0) and (2 * math.pi + e) or e) - ((s < 0) and (2 * math.pi + s) or s)) / r
  renderColor(color)
  renderVertex(x, y + r)
  for i = s, e, step do
  	renderVertex(x + r * math.cos( i ), y + r * math.sin( i ) + r)
  end
  renderVertex(x + r * math.cos( e ), y + r * math.sin( e ) + r)
  renderEnd()
end

function renderRound(x, y, d, s, e, color)
  local r = math.ceil( d / 2 )
  y = y - 1.0
  renderBegin(6)
  local step = e / (d - 1)
  renderColor(color)
  renderVertex(x, y + r)
  for i = s, e, step do
  	renderVertex(x + r * math.cos( i ), y + r * math.sin( i ) + r)
  end
  r = r - 1
  renderVertex(x + r * math.cos( e ), y + r * math.sin( e ) + r)
  renderEnd()
end


function megaf()
	lua_thread.create(function()
    if isCharInAnyCar(PLAYER_PED) then
      incar = {}
      local stream = sampGetStreamedPlayers()
      local _, myvodil = sampGetPlayerIdByCharHandle(getDriverOfCar(storeCarCharIsInNoSave(PLAYER_PED)))
      for k, v in pairs(stream) do
        local result, ped = sampGetCharHandleBySampPlayerId(v)
        if result then
          if isCharInAnyCar(ped) then
            local car = storeCarCharIsInNoSave(ped)
            local myposx, myposy, myposz = getCharCoordinates(PLAYER_PED)
            local pposx, pposy, pposz = getCharCoordinates(ped)
            local dist = getDistanceBetweenCoords3d(myposx, myposy, myposz, pposx, pposy, pposz)
            if dist <=65 then
              if getDriverOfCar(car) == ped then
                if sampGetFraktionBySkin(v) ~= 'Полиция' then
                  if storeCarCharIsInNoSave(ped) ~= storeCarCharIsInNoSave(PLAYER_PED) then
                    if v ~= myvodil then
                      	table.insert(incar, v)
                    end
                  end
                end
              end
            end
          end
      	end
      end
			if #incar ~= 0 then
		    if #incar == 1 then
	        local result, ped = sampGetCharHandleBySampPlayerId(incar[1])
	        if doesCharExist(ped) then
            if isCharInAnyCar(ped) then
              local carh = storeCarCharIsInNoSave(ped)
              local carhm = getCarModel(carh)
              sampSendChat(("/m Водитель а/м %s [EVL%sX]"):format(tCarsName[carhm-399], incar[1]))
              wait(1400)
              sampSendChat("/m Прижмитесь к обочине или мы откроем огонь по колёсам!")
              gmegafid = incar[1]
              gmegaflvl = sampGetPlayerScore(incar[1])
              gmegaffrak = sampGetFraktionBySkin(incar[1])
              gmegafcar = tCarsName[carhm-399]
            end
	        end
		    else
		    	if not imegaf.v then imegaf.v = true end
		    end
			end
		else
			ftext("Вам необходимо сидеть в транспорте")
		end
	end)
end

function sampGetStreamedPlayers()
	local t = {}
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local result, sped = sampGetCharHandleBySampPlayerId(i)
			if result then
				if doesCharExist(sped) then
					table.insert(t, i)
	    	end
			end
		end
	end
	return t
end

function naparnik1()
  local v = {}
  if isCharInAnyCar(PLAYER_PED) then
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    for i = 0, 999 do
      if sampIsPlayerConnected(i) then
        local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
        if doesCharExist(ichar) then
          if isCharInAnyCar(ichar) then
            local iveh = storeCarCharIsInNoSave(ichar)
            if veh == iveh then
              if sampGetFraktionBySkin(i) == 'Полиция' then
                local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
                if inick and ifam then
                	table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
                end
              end
            end
          end
        end
      end
    end
  else
    local myposx, myposy, myposz = getCharCoordinates(PLAYER_PED)
    for i = 0, 999 do
      if sampIsPlayerConnected(i) then
        local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
        if doesCharExist(ichar) then
          local ix, iy, iz = getCharCoordinates(ichar)
          if getDistanceBetweenCoords3d(myposx, myposy, myposz, ix, iy, iz) <= 30 then
            if sampGetFraktionBySkin(i) == 'Полиция' then
              local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
              if inick and ifam then
              	table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
              end
            end
          end
        end
      end
    end
  end
  if #v == 0 then
    return 'Напарников нет'
  elseif #v == 1 then
    return 'Напарник: '..table.concat(v, ', ').. '.'
  elseif #v >=2 then
  	return 'Напарники: '..table.concat(v, ', ').. '.'
  end
end

function naparnik()
  local v = {}
  if isCharInAnyCar(PLAYER_PED) then
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    for i = 0, 999 do
      if sampIsPlayerConnected(i) then
        local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
        if doesCharExist(ichar) then
          if isCharInAnyCar(ichar) then
            local iveh = storeCarCharIsInNoSave(ichar)
            if veh == iveh then
              if sampGetFraktionBySkin(i) == 'Полиция' then
                local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
                if inick and ifam then
                	table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
                end
              end
            end
          end
        end
      end
    end
  else
    local myposx, myposy, myposz = getCharCoordinates(PLAYER_PED)
    for i = 0, 999 do
      if sampIsPlayerConnected(i) then
        local ichar = select(2, sampGetCharHandleBySampPlayerId(i))
        if doesCharExist(ichar) then
          local ix, iy, iz = getCharCoordinates(ichar)
          if getDistanceBetweenCoords3d(myposx, myposy, myposz, ix, iy, iz) <= 30 then
            if sampGetFraktionBySkin(i) == 'Полиция' then
              local inick, ifam = sampGetPlayerNickname(i):match('(.+)_(.+)')
              if inick and ifam then
              	table.insert(v, string.format('%s.%s', inick:sub(1,1), ifam))
              end
            end
          end
        end
      end
    end
  end
  if #v == 0 then
    return 'Напарников нет.'
  elseif #v == 1 then
    return 'Напарник: '..table.concat(v, ', ').. '.'
  elseif #v >=2 then
  	return 'Напарники: '..table.concat(v, ', ').. '.'
  end
end

function sampGetFraktionBySkin(id)
    local skin = 0
    local t = 'Гражданский'
    --if sampIsPlayerConnected(id) then
        local result, ped = sampGetCharHandleBySampPlayerId(id)
        if result then
            skin = getCharModel(ped)
        else
            skin = getCharModel(PLAYER_PED)
        end
        if skin == 102 or skin == 103 or skin == 104 or skin == 195 or skin == 21 then t = 'Ballas Gang' end
        if skin == 105 or skin == 106 or skin == 107 or skin == 269 or skin == 270 or skin == 271 or skin == 86 or skin == 149 or skin == 297 then t = 'Grove Gang' end
        if skin == 108 or skin == 109 or skin == 110 or skin == 190 or skin == 47 then t = 'Vagos Gang' end
        if skin == 114 or skin == 115 or skin == 116 or skin == 48 or skin == 44 or skin == 41 or skin == 292 then t = 'Aztec Gang' end
        if skin == 173 or skin == 174 or skin == 175 or skin == 193 or skin == 226 or skin == 30 or skin == 119 then t = 'Rifa Gang' end
        if skin == 191 or skin == 252 or skin == 287 or skin == 61 or skin == 179 or skin == 255 then t = 'Army' end
        if skin == 57 or skin == 98 or skin == 147 or skin == 150 or skin == 187 or skin == 216 then t = 'Мэрия' end
        if skin == 59 or skin == 172 or skin == 189 or skin == 240 then t = 'Автошкола' end
        if skin == 201 or skin == 247 or skin == 248 or skin == 254 or skin == 248 or skin == 298 then t = 'Байкеры' end
        if skin == 272 or skin == 112 or skin == 125 or skin == 214 or skin == 111  or skin == 126 then t = 'Русская мафия' end
        if skin == 113 or skin == 124 or skin == 214 or skin == 223 then t = 'La Cosa Nostra' end
        if skin == 120 or skin == 123 or skin == 169 or skin == 186 then t = 'Yakuza' end
        if skin == 211 or skin == 217 or skin == 250 or skin == 261 then t = 'News' end
        if skin == 70 or skin == 219 or skin == 274 or skin == 275 or skin == 276 or skin == 70 then t = 'Медики' end
        if skin == 286 or skin == 141 or skin == 163 or skin == 164 or skin == 165 or skin == 166 then t = 'FBI' end
        if skin == 280 or skin == 265 or skin == 266 or skin == 267 or skin == 281 or skin == 282 or skin == 288 or skin == 284 or skin == 285 or skin == 304 or skin == 305 or skin == 306 or skin == 307 or skin == 309 or skin == 283 or skin == 303 then t = 'Полиция' end
    --end
    return t
end

function ftext(text)
	sampAddChatMessage(('[PD Tools] {ffffff}%s'):format(text), 0xde7171)
end

function update()
	local fpath = os.getenv('TEMP') .. '\\pdtools.json'
	downloadUrlToFile('https://raw.githubusercontent.com/junior196/pdtools/master/pdtools.json', fpath, function(id, status, p1, p2)
  if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r')
    if f then
      local info = decodeJson(f:read('*a'))
      updatelink = info.updateurl
      updlist1 = info.updlist
      ttt = updlist1
	    if info and info.latest then
	    	if tonumber(thisScript().version) < tonumber(info.latest) then
        	ftext('Обнаружено обновление!')
	        canupdate = true
					updatewindow.v = true
	    	else
	        print('Обновлений скрипта не обнаружено. Приятной игры.')
	        update = false
				end
	    end
    else
    	print("Проверка обновления прошка неуспешно. Запускаю старую версию.")
    end
    elseif status == 64 then
      print("Проверка обновления прошка неуспешно. Запускаю старую версию.")
      update = false
    end
  end)
end

function libs()
    if not limgui or not lrkeys  then
      ftext('Начата загрузка недостающих библиотек')
      ftext('По окончанию загрузки скрипт будет перезагружен')
      if limgui == false then
        imgui_download_status = 'proccess'
        downloadUrlToFile('https://raw.githubusercontent.com/junior196/pdtools/master/lib/imgui.lua', 'moonloader/lib/imgui.lua', function(id, status, p1, p2)
          if status == dlstatus.STATUS_DOWNLOADINGDATA then
            imgui_download_status = 'proccess'
            print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
          elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
            imgui_download_status = 'succ'
          elseif status == 64 then
            imgui_download_status = 'failed'
          end
        end)
        while imgui_download_status == 'proccess' do wait(0) end
        if imgui_download_status == 'failed' then
          print('Не удалось загрузить: imgui.lua')
          thisScript():unload()
        else
          print('Файл: imgui.lua успешно загружен')
          if doesFileExist('moonloader/lib/MoonImGui.dll') then
            print('Imgui был загружен')
          else
            imgui_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/junior196/pdtools/master/lib/MoonImGui.dll', 'moonloader/lib/MoonImGui.dll', function(id, status, p1, p2)
              if status == dlstatus.STATUS_DOWNLOADINGDATA then
                imgui_download_status = 'proccess'
                print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
              elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                imgui_download_status = 'succ'
              elseif status == 64 then
                imgui_download_status = 'failed'
              end
            end)
            while imgui_download_status == 'proccess' do wait(0) end
            if imgui_download_status == 'failed' then
              print('Не удалось загрузить Imgui')
              thisScript():unload()
            else
              print('Imgui был загружен')
            end
          end
        end
      end
      if not lrkeys then
        rkeys_download_status = 'proccess'
        downloadUrlToFile('https://raw.githubusercontent.com/junior196/pdtools/master/lib/rkeys.lua', 'moonloader/lib/rkeys.lua', function(id, status, p1, p2)
        if status == dlstatus.STATUS_DOWNLOADINGDATA then
          rkeys_download_status = 'proccess'
          print(string.format('Загружено %d килобайт из %d килобайт.', p1, p2))
        elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
          rkeys_download_status = 'succ'
        elseif status == 64 then
          rkeys_download_status = 'failed'
        end
      end)
      while rkeys_download_status == 'proccess' do wait(0) end
      if rkeys_download_status == 'failed' then
        print('Не удалось загрузить rkeys.lua')
        thisScript():unload()
      else
        print('rkeys.lua был загружен')
      end
    end
    ftext('Все необходимые библиотеки были загружены')
    reloadScripts()
  else
  	print('Все необходиме библиотеки были найдены и загружены')
  end
end

function goupdate()
	ftext('Началось скачивание обновления. Скрипт перезагрузится через пару секунд.', -1)
	wait(300)
	downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
    	thisScript():reload()
    elseif status1 == 64 then
    	ftext("Скачивание обновления прошло не успешно. Запускаю старую версию")
    end
	end)
end

function su(pam)
  suz = {}
  local dsuz = {}
  for line in io.lines('moonloader\\pdtools\\su.txt') do
  	table.insert(suz, line)
  end
  for k, v in pairs(suz) do
  	table.insert(dsuz, string.format('{de7171}%s. {ffffff}%s', k, v))
  end
  if pam:match('(%d+) (%d+)') then
    zid, zsu = pam:match('(%d+) (%d+)')
    if sampIsPlayerConnected(tonumber(zid)) then
      for k, v in pairs(suz) do
        if tonumber(zsu) == k then
          local reas, zzv = v:match('(.+) %- (%d+) .+')
          sampSendChat(string.format('/su %s %s %s', zid, zzv, reas))
          zid = nil
        end
      end
    end
  elseif pam:match('(%d+)') then
    zid = pam:match('(%d+)')
    if sampIsPlayerConnected(tonumber(zid)) then
      sampShowDialog(1765, '{ffffff}Выдача розыска игроку {de7171}'..sampGetPlayerNickname(tonumber(zid)).. '[' ..zid.. ']', table.concat(dsuz, '\n').. '\n\n{de7171}Выберите номер для объявления в розыск. Пример: 15', 'Выдать', 'Отмена', 1)
    end
  elseif #pam == 0 then
    ftext('Используйте: /su [id] [номер]')
  end
end

function oop(pam)
	local id, pric = pam:match('(%d+) (.+)')
	if id and pric and sampIsPlayerConnected(id) then
    if sampIsPlayerConnected(id) then
      sampSendChat("/dep Mayor, ООП "..sampGetPlayerNickname(id):gsub('_', ' ').." по "..pric.." УК SA")
    else
    	ftext("Игрок с ID: "..pID.." не подключен к серверу")
    end
  else
  	ftext("Используйте: /oop [id] [причина]")
  end
end

function ar(pam)
	local id, pric = pam:match('(%d+) (.+)')
  if id and pric then
		if tonumber(id) > 0 and tonumber(id) < 3 then
			if id == "1" then
				sampSendChat("/dep LVa, разрешите въезд на вашу территорию, "..pric)
			elseif id == "2" then
				sampSendChat("/dep SFa, разрешите въезд на вашу территорию, "..pric)
			end
		else
			ftext("Используйте: /ar [1-2] [причина]", -1)
	    ftext("1 - LVa | 2 - SFa", -1)
		end
	else
		ftext("Используйте: /ar [1-2] [причина]", -1)
    ftext("1 - LVa | 2 - SFa", -1)
	end
end

function gr(pam)
  local dep, reason = pam:match('(%d+) (.+)')
  if dep == nil or reason == nil then
  	ftext("Используйте: /gr [1-3] [Причина]")
  	ftext("1 - LSPD | 2 - SFPD | 3 - LVPD")
  end
  if dep ~= nil then
    if dep == "" or dep < "1" or dep > "3" then
      ftext("Используйте: /gr [1-3] [Причина]")
      ftext("1 - LSPD | 2 - SFPD | 3 - LVPD")
    elseif dep == "1" then
    	sampSendChat("/dep LSPD, пересекаю вашу юрисдикцию, "..reason)
    elseif dep == "2" then
    	sampSendChat("/dep SFPD, пересекаю вашу юрисдикцию, "..reason)
    elseif dep == "3" then
    	sampSendChat("/dep LVPD, пересекаю вашу юрисдикцию, "..reason)
    end
  end
end

function ticket(pam)
  lua_thread.create(function()
    local id, summa, reason = pam:match('(%d+) (%d+) (.+)')
    if id and summa and reason then
			if ticketme.v then
	      sampSendChat(string.format("/me достал бланк и ручку"))
	      wait(1400)
	      sampSendChat("/do Бланк и ручка в руках.")
	      wait(1400)
	      sampSendChat("/me начинает заполнять бланк")
	      wait(1400)
	      sampSendChat("/do Бланк заполнен.")
	      wait(1400)
	      sampSendChat(string.format("/me передал бланк нарушителю"))
	      wait(1400)
	      sampSendChat(string.format('/ticket %s %s %s', id, summa, reason))
			else
				sampSendChat(string.format('/ticket %s %s %s', id, summa, reason))
			end
    else
      ftext('Используйте: /ticket [id] [сумма] [причина]')
    end
  end)
end

function ceject(pam)
  lua_thread.create(function()
    local id = tonumber(pam)
    if id ~= nil then
      if sampIsPlayerConnected(id) then
				if cejectme.v then
	        if isCharOnAnyBike(PLAYER_PED) then
	          sampSendChat(("/me высадил %s с мотоцикла"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	          wait(1400)
	          sampSendChat(("/ceject %s"):format(id))
	        else
	          sampSendChat(("/me открыл дверь автомобиля и высадил %s"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	          wait(1400)
	          sampSendChat(("/ceject %s"):format(id))
	        end
				else
					sampSendChat(("/ceject %s"):format(id))
				end
      else
        ftext('Игрок оффлайн')
      end
    else
    	ftext('Используйте: /ceject [id]')
    end
  end)
end

function cput(pam)
  lua_thread.create(function()
    if pam:match("^(%d+)$") then
      local id = tonumber(pam:match("^(%d+)$"))
      if sampIsPlayerConnected(id) then
        if isCharInAnyCar(PLAYER_PED) then
          if isCharOnAnyBike(PLAYER_PED) then
	          sampSendChat(("/me посадил %s на сиденье мотоцикла"):format(sampGetPlayerNickname(id):gsub("_", ' ')))
	          wait(1400)
	          sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
	      	else
	          sampSendChat(("/me открыл дверь автомобиля и затолкнул туда %s"):format(sampGetPlayerNickname(id):gsub("_", ' ')))
	          wait(1400)
	          sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
          end
        else
          sampSendChat(("/me открыл дверь автомобиля и затолкнул туда %s"):format(sampGetPlayerNickname(id):gsub("_", ' ')))
          while not isCharInAnyCar(PLAYER_PED) do wait(0) end
          sampSendChat(("/cput %s %s"):format(id, getFreeSeat()))
        end
      else
      	ftext("Игрок оффлайн")
      end
    elseif pam:match("^(%d+) (%d+)$") then
        local id, seat = pam:match("^(%d+) (%d+)$")
        local id, seat = tonumber(id), tonumber(seat)
        if sampIsPlayerConnected(id) then
          if seat >=1 and seat <=3 then
            if isCharInAnyCar(PLAYER_PED) then
              if isCharOnAnyBike(PLAYER_PED) then
                sampSendChat(("/me посадил %s на сиденье мотоцикла"):format(sampGetPlayerNickname(id):gsub("_", ' ')))
                wait(1400)
                sampSendChat(("/cput %s %s"):format(id, seat))
              else
                sampSendChat(("/me открыл дверь автомобиля и затолкнул туда %s"):format(sampGetPlayerNickname(id):gsub("_", ' ')))
                wait(1400)
                sampSendChat(("/cput %s %s"):format(id, seat))
              end
            else
              sampSendChat(("/me открыл дверь автомобиля и затолкнул туда %s"):format(sampGetPlayerNickname(id):gsub("_", ' ')))
              while not isCharInAnyCar(PLAYER_PED) do wait(0) end
              sampSendChat(("/cput %s %s"):format(id, seat))
            end
          else
            ftext('Значение не должно быть меньше 1 и больше 3!')
          end
      else
        ftext('Игрок оффлайн')
      end
    elseif #pam == 0 or not pam:match("^(%d+)$") or not pam:match("^(%d+) (%d+)$") then
      ftext('Используйте: /cput [id] [место]')
    end
  end)
end

function arrest(pam)
	local id = tonumber(pam)
	if id ~= nil then
		if arrestme.v then
	    lua_thread.create(function()
	      sampSendChat("/do Ключи от камеры висят на поясе.")
	      wait(1400)
	      sampSendChat("/me снял ключи с пояса и открыл камеру, после затолкал туда преступника")
	      wait(1400)
	      sampSendChat('/arrest '..id)
	      wait(1400)
	      sampSendChat("/me закрыл дверь камеры и повесил ключи на пояс")
	    end)
		else
			sampSendChat('/arrest '..id)
		end
	else
		ftext('Используйте: /arrest [id]')
  end
end

function deject(pam)
  lua_thread.create(function()
    local id = tonumber(pam)
    if id ~= nil then
      if sampIsPlayerConnected(id) then
        local result, ped = sampGetCharHandleBySampPlayerId(id)
        if result then
					if dejectme.v then
	          if isCharInFlyingVehicle(ped) then
	            sampSendChat(("/me открыл дверь вертолёта ивытащил %s"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	          elseif isCharInModel(ped, 481) or isCharInModel(ped, 510) then
	            sampSendChat(("/me скинул %s с велосипеда"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	          elseif isCharInModel(ped, 462) then
	            sampSendChat(("/me скинул %s со скутера"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	          elseif isCharOnAnyBike(ped) then
	            sampSendChat(("/me скинул %s с мотоцикла"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	          elseif isCharInAnyCar(ped) then
	            sampSendChat(("/me разбил окно и вытащил %s из машины"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	          end
	          wait(1400)
	          sampSendChat(("/deject %s"):format(id))
					else
						sampSendChat(("/deject %s"):format(id))
					end
        end
      else
        ftext('Игрок оффлайн')
      end
    else
      ftext("Используйте: /deject [id]")
    end
  end)
end

function cuff(pam)
	local id = tonumber(pam)
	if id ~= nil then
		if cuffme.v then
	    lua_thread.create(function()
	      sampSendChat("/me снял наручники с пояса")
	      wait(1400)
	      sampSendChat('/cuff '..id)
	    end)
		else
			sampSendChat('/cuff'..id)
		end
	else
		ftext('Используйте: /cuff [id]')
  end
end

function uncuff(pam)
	local id = tonumber(pam)
	if id ~= nil then
		if uncuffme.v then
	    lua_thread.create(function()
	      sampSendChat('/uncuff '..id)
				wait(1400)
				sampSendChat("/me повесил наручники на пояс")
	    end)
		else
			sampSendChat('/uncuff'..id)
		end
	else
		ftext('Используйте: /uncuff [id]')
  end
end

function take(pam)
	local id = tonumber(pam)
	if id ~= nil then
		if takeme.v then
	    lua_thread.create(function()
	      sampSendChat("/me достал из мешочка на поясе резиновые перчатки")
	      wait(1400)
	      sampSendChat("/me надел на руки резиновые перчатки")
	      wait(1400)
	      sampSendChat('/take '..id)
	    end)
		else
			sampSendChat('/take '..id)
		end
	else
		ftext('Используйте: /take [id]')
  end
end

function follow(pam)
	local id = tonumber(pam)
	if id ~= nil then
		if followme.v then
	    lua_thread.create(function()
	      sampSendChat(("/me пристегнул %s наручником к своей руке"):format(sampGetPlayerNickname(id):gsub('_', ' ')))
	      wait(1400)
	      sampSendChat('/follow '..id)
	    end)
		else
			sampSendChat('/follow '..id)
		end
	else
		ftext('Используйте: /follow [id]')
  end
end

function r(pam)
	if #pam ~= 0 then
    if tag.v then
    	sampSendChat(string.format('/r [%s]: %s', mainIni.config.tagtext, pam))
    else
    	sampSendChat(string.format('/r %s', pam))
    end
	else
		ftext('Используйте: /r [текст]')
	end
end

function fkv(pam)
	if #pam ~= 0 then
    kvadY, kvadX = string.match(pam, "(%A)-(%d+)")
    if kvadrat(kvadY) ~= nil and kvadX ~= nil and kvadY ~= nil and tonumber(kvadX) < 25 and tonumber(kvadX) > 0 then
        last = lcs
        coordX = kvadX * 250 - 3125
        coordY = (kvadrat1(kvadY) * 250 - 3125) * - 1
    end
	else
	  ftext('Используйте: /fkv [квадрат]')
	  ftext('Пример: /fkv Л-6')
	end
end

function kvadrat()
	local KV = {
	  [1] = "А",
	  [2] = "Б",
	  [3] = "В",
	  [4] = "Г",
	  [5] = "Д",
	  [6] = "Ж",
	  [7] = "З",
	  [8] = "И",
	  [9] = "К",
	  [10] = "Л",
	  [11] = "М",
	  [12] = "Н",
	  [13] = "О",
	  [14] = "П",
	  [15] = "Р",
	  [16] = "С",
	  [17] = "Т",
	  [18] = "У",
	  [19] = "Ф",
	  [20] = "Х",
	  [21] = "Ц",
	  [22] = "Ч",
	  [23] = "Ш",
	  [24] = "Я",
	}
	local X, Y, Z = getCharCoordinates(playerPed)
	X = math.ceil((X + 3000) / 250)
	Y = math.ceil((Y * - 1 + 3000) / 250)
	Y = KV[Y]
	local KVX = (Y.."-"..X)
	return KVX
end

function calculateZone(x, y, z)
    local streets = {{"Avispa Country Club", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
    {"Easter Bay Airport", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
    {"Avispa Country Club", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
    {"Easter Bay Airport", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
    {"Garcia", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
    {"Shady Cabin", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
    {"East Los Santos", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
    {"LVA Freight Depot", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
    {"Blackfield Intersection", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
    {"Avispa Country Club", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
    {"Temple", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
    {"Unity Station", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
    {"LVA Freight Depot", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
    {"Los Flores", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
    {"Starfish Casino", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
    {"Easter Bay Chemicals", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
    {"Downtown Los Santos", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
    {"Esplanade East", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
    {"Market Station", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
    {"Linden Station", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
    {"Montgomery Intersection", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
    {"Frederick Bridge", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
    {"Yellow Bell Station", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
    {"Downtown Los Santos", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
    {"Jefferson", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
    {"Mulholland", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
    {"Avispa Country Club", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
    {"Jefferson", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
    {"Julius Thruway West", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
    {"Jefferson", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
    {"Julius Thruway North", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
    {"Rodeo", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
    {"Cranberry Station", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
    {"Downtown Los Santos", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
    {"Redsands West", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
    {"Little Mexico", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
    {"Blackfield Intersection", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
    {"Los Santos International", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
    {"Beacon Hill", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
    {"Rodeo", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
    {"Richman", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
    {"Downtown Los Santos", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
    {"The Strip", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
    {"Downtown Los Santos", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
    {"Blackfield Intersection", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
    {"Conference Center", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
    {"Montgomery", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
    {"Foster Valley", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
    {"Blackfield Chapel", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
    {"Los Santos International", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
    {"Mulholland", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
    {"Yellow Bell Gol Course", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
    {"The Strip", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
    {"Jefferson", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
    {"Mulholland", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
    {"Aldea Malvada", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
    {"Las Colinas", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
    {"Las Colinas", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
    {"Richman", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
    {"LVA Freight Depot", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
    {"Julius Thruway North", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
    {"Willowfield", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
    {"Julius Thruway North", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
    {"Temple", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
    {"Little Mexico", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
    {"Queens", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
    {"Las Venturas Airport", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
    {"Richman", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
    {"Temple", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
    {"East Los Santos", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
    {"Julius Thruway East", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
    {"Willowfield", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
    {"Las Colinas", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
    {"Julius Thruway East", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
    {"Rodeo", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
    {"Las Brujas", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
    {"Julius Thruway East", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
    {"Rodeo", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
    {"Vinewood", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
    {"Rodeo", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
    {"Julius Thruway North", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
    {"Downtown Los Santos", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
    {"Rodeo", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
    {"Jefferson", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
    {"Hampton Barns", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
    {"Temple", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
    {"Kincaid Bridge", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
    {"Verona Beach", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
    {"Commerce", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
    {"Mulholland", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
    {"Rodeo", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
    {"Mulholland", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
    {"Mulholland", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
    {"Julius Thruway South", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
    {"Idlewood", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
    {"Ocean Docks", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
    {"Commerce", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
    {"Julius Thruway North", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
    {"Temple", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
    {"Glen Park", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
    {"Easter Bay Airport", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
    {"Martin Bridge", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
    {"The Strip", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
    {"Willowfield", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
    {"Marina", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
    {"Las Venturas Airport", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
    {"Idlewood", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
    {"Esplanade East", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
    {"Downtown Los Santos", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
    {"The Mako Span", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
    {"Rodeo", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
    {"Pershing Square", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
    {"Mulholland", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
    {"Gant Bridge", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
    {"Las Colinas", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
    {"Mulholland", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
    {"Julius Thruway North", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
    {"Commerce", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
    {"Rodeo", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
    {"Roca Escalante", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
    {"Rodeo", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
    {"Market", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
    {"Las Colinas", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
    {"Mulholland", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
    {"King's", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
    {"Redsands East", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
    {"Downtown", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
    {"Conference Center", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
    {"Richman", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
    {"Ocean Flats", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
    {"Greenglass College", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
    {"Glen Park", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
    {"LVA Freight Depot", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
    {"Regular Tom", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
    {"Verona Beach", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
    {"East Los Santos", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
    {"Caligula's Palace", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
    {"Idlewood", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
    {"Pilgrim", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
    {"Idlewood", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
    {"Queens", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
    {"Downtown", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
    {"Commerce", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
    {"East Los Santos", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
    {"Marina", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
    {"Richman", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
    {"Vinewood", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
    {"East Los Santos", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
    {"Rodeo", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
    {"Easter Tunnel", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
    {"Rodeo", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
    {"Redsands East", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
    {"The Clown's Pocket", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
    {"Idlewood", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
    {"Montgomery Intersection", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
    {"Willowfield", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
    {"Temple", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
    {"Prickle Pine", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
    {"Los Santos International", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
    {"Garver Bridge", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
    {"Garver Bridge", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
    {"Kincaid Bridge", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
    {"Kincaid Bridge", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
    {"Verona Beach", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
    {"Verdant Bluffs", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
    {"Vinewood", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
    {"Vinewood", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
    {"Commerce", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
    {"Market", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
    {"Rockshore West", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
    {"Julius Thruway North", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
    {"East Beach", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
    {"Fallow Bridge", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
    {"Willowfield", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
    {"Chinatown", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
    {"El Castillo del Diablo", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
    {"Ocean Docks", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
    {"Easter Bay Chemicals", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
    {"The Visage", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
    {"Ocean Flats", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
    {"Richman", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
    {"Green Palms", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
    {"Richman", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
    {"Starfish Casino", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
    {"East Beach", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
    {"Jefferson", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
    {"Downtown Los Santos", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
    {"Downtown Los Santos", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
    {"Garver Bridge", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
    {"Julius Thruway South", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
    {"East Los Santos", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
    {"Greenglass College", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
    {"Las Colinas", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
    {"Mulholland", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
    {"Ocean Docks", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
    {"East Los Santos", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
    {"Ganton", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
    {"Avispa Country Club", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
    {"Willowfield", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
    {"Esplanade North", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
    {"The High Roller", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
    {"Ocean Docks", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
    {"Last Dime Motel", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
    {"Bayside Marina", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
    {"King's", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
    {"El Corona", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
    {"Blackfield Chapel", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
    {"The Pink Swan", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
    {"Julius Thruway West", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
    {"Los Flores", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
    {"The Visage", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
    {"Prickle Pine", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
    {"Verona Beach", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
    {"Robada Intersection", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
    {"Linden Side", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
    {"Ocean Docks", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
    {"Willowfield", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
    {"King's", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
    {"Commerce", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
    {"Mulholland", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
    {"Marina", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
    {"Battery Point", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
    {"The Four Dragons Casino", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
    {"Blackfield", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
    {"Julius Thruway North", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
    {"Yellow Bell Gol Course", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
    {"Idlewood", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
    {"Redsands West", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
    {"Doherty", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
    {"Hilltop Farm", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
    {"Las Barrancas", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
    {"Pirates in Men's Pants", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
    {"City Hall", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
    {"Avispa Country Club", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
    {"The Strip", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
    {"Hashbury", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
    {"Los Santos International", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
    {"Whitewood Estates", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
    {"Sherman Reservoir", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
    {"El Corona", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
    {"Downtown", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
    {"Foster Valley", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
    {"Las Payasadas", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
    {"Valle Ocultado", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
    {"Blackfield Intersection", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
    {"Ganton", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
    {"Easter Bay Airport", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
    {"Redsands East", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
    {"Esplanade East", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
    {"Caligula's Palace", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
    {"Royal Casino", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
    {"Richman", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
    {"Starfish Casino", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
    {"Mulholland", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
    {"Downtown", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
    {"Hankypanky Point", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
    {"K.A.C.C. Military Fuels", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
    {"Harry Gold Parkway", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
    {"Bayside Tunnel", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
    {"Ocean Docks", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
    {"Richman", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
    {"Randolph Industrial Estate", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
    {"East Beach", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
    {"Flint Water", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
    {"Blueberry", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
    {"Linden Station", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
    {"Glen Park", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
    {"Downtown", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
    {"Redsands West", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
    {"Richman", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
    {"Gant Bridge", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
    {"Lil' Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
    {"Flint Intersection", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
    {"Las Colinas", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
    {"Sobell Rail Yards", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
    {"The Emerald Isle", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
    {"El Castillo del Diablo", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
    {"Santa Flora", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
    {"Playa del Seville", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
    {"Market", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
    {"Queens", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
    {"Pilson Intersection", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
    {"Spinybed", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
    {"Pilgrim", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
    {"Blackfield", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
    {"'The Big Ear'", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
    {"Dillimore", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
    {"El Quebrados", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
    {"Esplanade North", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
    {"Easter Bay Airport", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
    {"Fisher's Lagoon", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
    {"Mulholland", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
    {"East Beach", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
    {"San Andreas Sound", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
    {"Shady Creeks", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
    {"Market", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
    {"Rockshore West", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
    {"Prickle Pine", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
    {"Easter Basin", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
    {"Leafy Hollow", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
    {"LVA Freight Depot", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
    {"Prickle Pine", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
    {"Blueberry", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
    {"El Castillo del Diablo", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
    {"Downtown", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
    {"Rockshore East", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
    {"San Fierro Bay", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
    {"Paradiso", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
    {"The Camel's Toe", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
    {"Old Venturas Strip", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
    {"Juniper Hill", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
    {"Juniper Hollow", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
    {"Roca Escalante", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
    {"Julius Thruway East", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
    {"Verona Beach", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
    {"Foster Valley", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
    {"Arco del Oeste", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
    {"Fallen Tree", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
    {"The Farm", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
    {"The Sherman Dam", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
    {"Esplanade North", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
    {"Financial", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
    {"Garcia", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
    {"Montgomery", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
    {"Creek", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
    {"Los Santos International", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
    {"Santa Maria Beach", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
    {"Mulholland Intersection", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
    {"Angel Pine", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
    {"Verdant Meadows", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
    {"Octane Springs", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
    {"Come-A-Lot", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
    {"Redsands West", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
    {"Santa Maria Beach", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
    {"Verdant Bluffs", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
    {"Las Venturas Airport", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
    {"Flint Range", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
    {"Verdant Bluffs", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
    {"Palomino Creek", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
    {"Ocean Docks", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
    {"Easter Bay Airport", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
    {"Whitewood Estates", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
    {"Calton Heights", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
    {"Easter Basin", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
    {"Los Santos Inlet", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
    {"Doherty", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
    {"Mount Chiliad", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
    {"Fort Carson", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
    {"Foster Valley", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
    {"Ocean Flats", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
    {"Fern Ridge", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
    {"Bayside", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
    {"Las Venturas Airport", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
    {"Blueberry Acres", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
    {"Palisades", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
    {"North Rock", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
    {"Hunter Quarry", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
    {"Los Santos International", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
    {"Missionary Hill", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
    {"San Fierro Bay", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
    {"Restricted Area", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
    {"Mount Chiliad", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
    {"Mount Chiliad", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
    {"Easter Bay Airport", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
    {"The Panopticon", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
    {"Shady Creeks", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
    {"Back o Beyond", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
    {"Mount Chiliad", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
    {"Tierra Robada", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
    {"Flint County", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
    {"Whetstone", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
    {"Bone County", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
    {"Tierra Robada", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
    {"San Fierro", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
    {"Las Venturas", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
    {"Red County", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
    {"Los Santos", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}}
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return "Unknown"
end

function kvadrat1(param)
	local KV = {
	  ["А"] = 1,
	  ["Б"] = 2,
	  ["В"] = 3,
	  ["Г"] = 4,
	  ["Д"] = 5,
	  ["Ж"] = 6,
	  ["З"] = 7,
	  ["И"] = 8,
	  ["К"] = 9,
	  ["Л"] = 10,
	  ["М"] = 11,
	  ["Н"] = 12,
	  ["О"] = 13,
	  ["П"] = 14,
	  ["Р"] = 15,
	  ["С"] = 16,
	  ["Т"] = 17,
	  ["У"] = 18,
	  ["Ф"] = 19,
	  ["Х"] = 20,
	  ["Ц"] = 21,
	  ["Ч"] = 22,
	  ["Ш"] = 23,
	  ["Я"] = 24,
	  ["а"] = 1,
	  ["б"] = 2,
	  ["в"] = 3,
	  ["г"] = 4,
	  ["д"] = 5,
	  ["ж"] = 6,
	  ["з"] = 7,
	  ["и"] = 8,
	  ["к"] = 9,
	  ["л"] = 10,
	  ["м"] = 11,
	  ["н"] = 12,
	  ["о"] = 13,
	  ["п"] = 14,
	  ["р"] = 15,
	  ["с"] = 16,
	  ["т"] = 17,
	  ["у"] = 18,
	  ["ф"] = 19,
	  ["х"] = 20,
	  ["ц"] = 21,
	  ["ч"] = 22,
	  ["ш"] = 23,
	  ["я"] = 24,
	}
	return KV[param]
end

function hook.onSendSpawn()
	if color.v then
		lua_thread.create(function()
			wait(1400)
			sampSendChat('/clist '..colorid.v)
		end)
	end
end

function hook.onServerMessage(color, text)
	if color == 1790050303 then
		if text:find('Вы поменяли пули на обычные') then
			 hudtazer = "Деактивирован"
			 if tazer.v then
				 lua_thread.create(function()
		 		 	wait(600)
		 			sampSendChat('/seeme переключил тип потронов на обычные')
		 		end)
			end
		end
		if text:find('Вы поменяли пули на резиновые') then
			 hudtazer = "Активирован"
			 if tazer.v then
				 lua_thread.create(function()
		 		 	wait(600)
		 			sampSendChat('/seeme переключил тип потронов на резиновые')
		 		end)
			end
		end
	end
end

function hook.onShowDialog(id, style, title, button1, button2, text)
	if id == 22 and checkstat then
		ffrak = text:match('.+Организация%s+(.+)%s+Ранг')
		frang = text:match('.+Ранг%s+(.+)%s+Работа')
		sampSendDialogResponse(id, 0, _, _)
		checkstat = false
		return false
	end
	if id == 245 then
		if armour.v or specgun.v or deagle.v or shot.v or smg.v or M4A1.v or rifle.v then
			local guns = getCompl()
			lua_thread.create(function()
				wait(125)
				if autoBP == #guns + 1 then
					autoBP = 1
					sampCloseCurrentDialogWithButton(0)
					return
				end
				sampSetCurrentDialogListItem(guns[autoBP])
				wait(125)
				sampCloseCurrentDialogWithButton(1)
				if button1 then autoBP = autoBP + 1 end
				return
			end)
		end
	end
end

function checkStats()
	checkstat = true
	sampSendChat('/stats')
end

function getFreeSeat()
    seat = 3
    if isCharInAnyCar(PLAYER_PED) then
        local veh = storeCarCharIsInNoSave(PLAYER_PED)
        for i = 1, 3 do
            if isCarPassengerSeatFree(veh, i) then
                seat = i
            end
        end
    end
    return seat
end

function getCompl()
  local t = {}
  if deagle.v then
    table.insert(t, 0)
    if deaglept.v then table.insert(t, 0) end
  end
  if shot.v then
    table.insert(t, 1)
    if shotpt.v then table.insert(t, 1) end
  end
  if smg.v then
    table.insert(t, 2)
    if smgpt.v then table.insert(t, 2) end
  end
  if M4A1.v then
    table.insert(t, 3)
    if M4A1pt.v then table.insert(t, 3) end
  end
  if rifle.v then
    table.insert(t, 4)
    if riflept.v then table.insert(t, 4) end
  end
	if armour.v then table.insert(t, 5) end
  if specgun.v then table.insert(t, 6) end
  return t
end

function apply_custom_style()
	if not state then
		imgui.SwitchContext()
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
		local ImVec2 = imgui.ImVec2

		style.WindowPadding = ImVec2(15, 15)
		style.WindowRounding = 5.0
		style.FramePadding = ImVec2(5, 5)
		style.FrameRounding = 4.0
		style.ItemSpacing = ImVec2(12, 8)
		style.ItemInnerSpacing = ImVec2(8, 6)
		style.IndentSpacing = 25.0
		style.ScrollbarSize = 15.0
		style.ScrollbarRounding = 9.0
		style.GrabMinSize = 5.0
		style.GrabRounding = 3.0

		colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)

		colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
		colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
		colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
		colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
		colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
		colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
		colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
		colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
		colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
		colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
		colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
		colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
		colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
		colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
		colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
		colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
	end
end
apply_custom_style()

function imgui.TextQuestion(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end
