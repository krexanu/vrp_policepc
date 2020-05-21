local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_minipolicepc")

local function ch_cautadupaid(player,choice)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		vRP.prompt({player,"Player ID:","",function(player, id)
			id = tonumber(id)
			if id == nil or id == "" or id <= 0 then
				vRPclient.notify(player,{"The ID should be a number and higher than 0"})
			else
				if id == user_id then
					vRPclient.notify(player,{"You can't search yourself"})
				else
					local targetid = vRP.getUserId({id})
					local target = vRP.getUserSource({targetid})
					if target ~= nil then
						vRP.getUserIdentity({targetid, function(identity)
							if identity then
								vRP.getUserAddress({user_id, function(address)
									theAddress = ""
									if address ~= nil then
										theAddress = address.home.." ("..address.number..")"
									else
										theAddress = "Homeless"
									end
									content = "<strong>Information about: </strong>"..GetPlayerName(target).."("..targetid..")<br /><strong>Name: </strong>"..identity.name.."<br /><strong>FirstName: </strong>"..identity.firstname.."<br /><strong>Age: </strong>"..identity.age.."<br /><br /><strong>Phone Number: </strong>"..identity.phone.."<br /><br /><strong>Registration Nr: </strong>"..identity.registration.."<br /><br /><strong>House: </strong>"..theAddress.."<br />"
									vRPclient.setDiv(player,{"pulacautare",".div_pulacautare{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
									SetTimeout(10000, function()
										vRPclient.removeDiv(player,{"pulacautare"})
									end)
								end})
							end
						end})
					else
						vRPclient.notify(player,{"The player must be online!"})
					end
				end
			end
		end})
	end
end

local function ch_cautadupaidbusiness(player,choice)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		vRP.prompt({player,"Player ID:","",function(player, id)
			id = tonumber(id)
			if id == nil or id == "" or id <= 0 then
				vRPclient.notify(player,{"The ID should be a number and higher than 0"})
			else
				if id == user_id then
					vRPclient.notify(player,{"You can't search yourself"})
				else
					local targetid = vRP.getUserId({id})
					local target = vRP.getUserSource({targetid})
					if target ~= nil then
						vRP.getUserIdentity({targetid, function(identity)
							if identity then
								vRP.getUserBusiness({user_id, function(business)
									if business then
										bname = business.name
										bcapital = business.capital
										content = "<strong>Information about: </strong>"..GetPlayerName(target).."("..targetid..")<strong>Business Name: </strong>"..bname.."<br /><strong>Business Description: </strong>"..business.description.."<br /><strong>Capital: </strong>"..bcapital.."<br />"
										vRPclient.setDiv(player,{"pulacautaresadfsdfasdfasdfsd",".div_pulacautaresadfsdfasdfasdfsd{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
										SetTimeout(10000, function()
											vRPclient.removeDiv(player,{"pulacautaresadfsdfasdfasdfsd"})
										end)
									else
										vRPclient.notify(player,{"Nothing found!"})
									end
								end})
							end
						end})
					else
						vRPclient.notify(player,{"The player must be online!"})
					end
				end
			end
		end})
	end
end

local function ch_cautadupaidvehicles(player)
	menu = {name="Vehicule",css={top="75px", header_color="rgba(0,125,255,0.75)"}}
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		vRP.prompt({player,"Player ID:","",function(player, id)
			id = tonumber(id)
			if id == nil or id == "" or id <= 0 then
				vRPclient.notify(player,{"The ID should be a number and higher than 0"})
			else
				if id == user_id then
					vRPclient.notify(player,{"You can't search yourself"})
				else
					local targetid = vRP.getUserId({id})
					local target = vRP.getUserSource({targetid})
					MySQL.Async.fetchAll("SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id",{["user_id"] = targetid}, function(pula)
						if target ~= nil then
							for i,v in pairs(pula) do
								local vehicle = v.vehicle
								menu[vehicle] = {function(player,choice)
								end}
								vRP.closeMenu({player})
								SetTimeout(500, function()
									vRP.openMenu({player, menu})
								end)
							end
						else
							vRPclient.notify(player,{"The player must be online!"})
						end
					end)
				end
			end
		end})
	end
end

local function ch_cautadupaidpolicerecords(player,choice)
	local user_id = vRP.getUserId({player})
	vRP.prompt({player,"Player's Registration Number:","",function(player, reg)
		vRP.getUserByRegistration({reg, function(user_id)
		  	if user_id ~= nil then
			vRP.getUData({user_id, "vRP:police_records", function(content)
				vRPclient.setDiv(player,{"pulacautaresadfsdfaasdfasdfsdfasdfsd",".div_pulacautaresadfsdfaasdfasdfsdfasdfsd{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
				SetTimeout(10000, function()
					vRPclient.removeDiv(player,{"pulacautaresadfsdfaasdfasdfsdfasdfsd"})
				end)
			end})
		  	else
				vRPclient.notify(player,{"Nothing found!"})
		  	end
		end})
	end})
end

vRP.registerMenuBuilder({"police", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		if(vRP.hasGroup({user_id,"cop"}))then
			choices["Search People"] = {function(player,choice)
				vRP.buildMenu({"Search", {player = player}, function(menu)
					menu.name = "Search"
					menu.css={top="75px",header_color="rgba(235,0,0,0.75)"}
					menu.onclose = function(player) vRP.openMainMenu({player}) end

					menu["Basic Information"] = {ch_cautadupaid,"Search by player's ID."}
					menu["Business Information"] = {ch_cautadupaidbusiness,"Search by player's ID."}
					menu["Police Records"] = {ch_cautadupaidpolicerecords,"Search by player's Registration Number."}
					menu["Vehicle Information"] = {ch_cautadupaidvehicles,"Search by player's ID."}

					vRP.openMenu({player, menu})
				end})
			end, "Search People"}
		end
		add(choices)
	end
end})