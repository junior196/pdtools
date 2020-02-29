script_name("PD Tools")
script_authors("junior")
script_version("0.2")

local imgui = require 'imgui'
local limadd, imadd = pcall(require, 'imgui_addons')
local lrkeys, rkeys  = pcall(require, 'rkeys')
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local hook = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status
local key = require 'vkeys'
local keys = require 'game.keys'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local autoBP = 1
local checkstat = false
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

local mainIni = inicfg.load({
config =
{
color = false,
colorid = 0,
tag = false,
tagtext = '',
doklad = false,
meg = false,
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
}
}, "pdtools")

local color = imgui.ImBool(mainIni.config.color)
local colorid = imgui.ImInt(mainIni.config.colorid)
local tag = imgui.ImBool(mainIni.config.tag)
local tagtext = imgui.ImBuffer(u8(mainIni.config.tagtext), 256)
local doklad = imgui.ImBool(mainIni.config.doklad)
local meg = imgui.ImBool(mainIni.config.meg)

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
function imgui.OnDrawFrame()
	if main_window_state.v then
		imgui.ShowCursor = true
		imgui.SetNextWindowSize(imgui.ImVec2(655, 450), imgui.Cond.FirstUseEver)
		imgui.Begin(script.this.name..' | ver.'..script.this.version, main_window_state, imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoCollapse)
		imgui.BeginChild('##set', imgui.ImVec2(140, 400), true)
		if imgui.Selectable(u8'Основное', show == 1) then show = 1 end
		if imgui.Selectable(u8'Отыгровки', show == 2) then show = 2 end
		if imgui.Selectable(u8'Авто-БП', show == 3) then show = 3 end
		if imgui.Selectable(u8'Команды', show == 4) then show = 4 end
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
					imgui.Text(u8'Используйте клавишу \"R\"')
				end
				if imgui.Checkbox(u8"Мегафон", meg) then mainIni.config.meg = meg.v inicfg.save(mainIni, 'pdtools.ini') end
				if meg.v then
					imgui.SameLine(150)
					imgui.Text(u8'Используйте клавишу \"B\"')
				end
				if canupdate then
					imgui.PushItemWidth(305)
					if imgui.Button(u8("Обновить"), imgui.ImVec2(100, 25)) then
						lua_thread.create(goupdate)
					end
					imgui.SameLine()
					if imgui.Button(u8("Отложить обновление"), imgui.ImVec2(150, 25)) then
						ftext("Если вы захотите установить обновление введите команду {9966CC}/pdtools")
					end
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
				imgui.Text(u8'/ak - Административный Кодекс')
				imgui.Text(u8'/yk - Уголовный Кодекс')
				imgui.Text(u8'/fp - Федеральное постановление')
				imgui.Text(u8'/ksh - Конституция штата')
			end
			imgui.EndChild()
		imgui.End()
	end
	if main_window_stats.v then
		imgui.ShowCursor = true
		local btn_size = imgui.ImVec2(-0.1, 0)
		imgui.SetNextWindowSize(imgui.ImVec2(300, 165), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'PD Tools | Доклад', main_window_stats, imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoCollapse)
		imgui.Text(u8'Выберите состояние:')
		if imgui.Button(u8 'Спокойное', btn_size) then
			r('Состояние: Спокойное')
			main_window_stats.v = false
			imgui.ShowCursor = false
		end
		if imgui.Button(u8 'Нападение', btn_size) then
			r('Состояние: Нападение')
			main_window_stats.v = false
			imgui.ShowCursor = false
		end
		if imgui.Button(u8 'Перестрелка', btn_size) then
			r('Состояние: Перестрелка')
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
			ftext('Файл \"ak.txt\" в папке \"moonloader/pdtools\" не найден!')
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
			ftext('Файл \"yk.txt\" в папке \"moonloader/pdtools\" не найден!')
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
			ftext('Файл \"ksh.txt\" в папке \"moonloader/pdtools\" не найден!')
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
			ftext('Файл \"fp.txt\" в папке \"moonloader/pdtools\" не найден!')
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
		update()
	while true do
		wait(0)
		imgui.Process = main_window_state.v or main_window_stats.v or imegaf.v or akwindow.v or ykwindow.v or kshwindow.v or fpwindow.v or fastmenu.v
		if sampIsDialogActive() == false and not isPauseMenuActive() and isPlayerPlaying(playerHandle) and sampIsChatInputActive() == false then
			if wasKeyPressed(82) then
				if doklad.v then
					r('Патрулирую сектор: '..kvadrat()..'. '..naparnik())
					main_window_stats.v = true
					imgui.ShowCursor = true
				end
			end
			if wasKeyPressed(66) then if meg.v then megaf() end	end
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
	local fpath = os.getenv('TEMP') .. '\\ftulsupd.json'
	downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/ftulsupd.json', fpath, function(id, status, p1, p2)
  if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r')
    if f then
      local info = decodeJson(f:read('*a'))
      updatelink = info.updateurl
      updlist1 = info.updlist
      ttt = updlist1
	    if info and info.latest then
	    	if tonumber(thisScript().version) < tonumber(info.latest) then
	        ftext('Обнаружено обновление {9966cc}'..script.this.name..'{ffffff}. Для обновления нажмите кнопку в окошке.')
	        ftext('Примечание: Если у вас не появилось окошко введите {9966cc}/pdtools')
	        updwindows.v = true
	        canupdate = true
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

function hook.onShowDialog(id, style, title, button1, button2, text)
	if id == 22 and checkstat then
		ffrak = text:match('.+Организация%s+(.+)%s+Ранг')
		frang = text:match('.+Ранг%s+(.+)%s+>> Уровень во фракции')
		sampSendDialogResponse(id, 0, _, _)
		checkstat = false
		return false
	end
	if id == 245 then
		if armour.v or specgun.v or deagle.v or shot.v or smg.v or M4A1.v or rifle.v then
			local guns = getCompl()
			lua_thread.create(function()
				wait(250)
				if autoBP == #guns + 1 then
					autoBP = 1
					sampCloseCurrentDialogWithButton(0)
					return
				end
				sampSetCurrentDialogListItem(guns[autoBP])
				wait(250)
				sampCloseCurrentDialogWithButton(1)
				if button1 then
					autoBP = autoBP + 1
				end
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
