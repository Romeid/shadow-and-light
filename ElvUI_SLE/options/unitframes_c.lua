﻿local SLE, _, E, L = unpack(select(2, ...))
local UF = E.UnitFrames
local SUF = SLE.UnitFrames

local CUSTOM = CUSTOM
local LEVEL = LEVEL
local wipe = wipe
local roleValues = {}

local function CreateOfflineConfig(group)
	local config = {
		order = 5,
		type = 'group',
		name = L["Offline Indicator"],
		get = function(info) return E.db.sle.unitframes.unit[group].offline[info[#info]] end,
		set = function(info, value) E.db.sle.unitframes.unit[group].offline[info[#info]] = value; UF:CreateAndUpdateHeaderGroup(group) end,
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = L["Enable"],
			},
			size = {
				order = 2,
				type = 'range',
				name = L["Size"],
				min = 10, max = 120, step = 1,
			},
			xOffset = {
				order = 3,
				type = 'range',
				name = L["X-Offset"],
				min = -600, max = 600, step = 1,
			},
			yOffset = {
				order = 4,
				type = 'range',
				name = L["Y-Offset"],
				min = -600, max = 600, step = 1,
			},
			texture = {
				order = 5,
				type = 'select',
				name = L["Texture"],
				values = {
					ALERT = [[|TInterface\DialogFrame\UI-Dialog-Icon-AlertNew:14|t]],
					ARTHAS =[[|TInterface\LFGFRAME\UI-LFR-PORTRAIT:14|t]],
					SKULL = [[|TInterface\LootFrame\LootPanel-Icon:14|t]],
					PASS = [[|TInterface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent:14|t]],
					NOTREADY = [[|TInterface\RAIDFRAME\ReadyCheck-NotReady:14|t]],
					CUSTOM = CUSTOM,
				},
			},
			CustomTexture = {
				order = 6,
				type = 'input',
				name = L["Custom Texture"],
				width = 'full',
				disabled = function() return E.db.sle.unitframes.unit[group].offline.texture ~= 'CUSTOM' end,
			},
		},
	}
	return config
end

local function CreateDeadConfig(group)
	local config = {
		order = 6,
		type = 'group',
		name = L["Dead Indicator"],
		get = function(info) return E.db.sle.unitframes.unit[group].dead[info[#info]] end,
		set = function(info, value) E.db.sle.unitframes.unit[group].dead[info[#info]] = value; UF:CreateAndUpdateHeaderGroup(group) end,
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = L["Enable"]
			},
			size = {
				order = 2,
				type = 'range',
				name = L["Size"],
				min = 10, max = 120, step = 1,
			},
			xOffset = {
				order = 3,
				type = 'range',
				name = L["X-Offset"],
				min = -600, max = 600, step = 1,
			},
			yOffset = {
				order = 4,
				type = 'range',
				name = L["Y-Offset"],
				min = -600, max = 600, step = 1,
			},
			texture = {
				order = 5,
				type = 'select',
				name = L["Texture"],
				values = {
					SKULL = [[|TInterface\LootFrame\LootPanel-Icon:14|t]],
					SKULL1 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL:14|t]],
					SKULL2 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL1:14|t]],
					SKULL3 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL2:14|t]],
					SKULL4 = [[|TInterface\AddOns\ElvUI_SLE\media\textures\SKULL3:14|t]],
					CUSTOM = CUSTOM,
				},
			},
			CustomTexture = {
				order = 6,
				type = 'input',
				name = L["Custom Texture"],
				width = 'full',
				disabled = function() return E.db.sle.unitframes.unit[group].dead.texture ~= 'CUSTOM' end,
			},
		},
	}

	return config
end

local function CreateAurasConfig(unitID)
	local config = {
		order = 6,
		type = 'group',
		name = L["Auras"],
		args = {
			buffs = {
				order = 1,
				type = 'group',
				name = L["Buffs"],
				guiInline = true,
				get = function(info) return E.db.sle.unitframes.unit[unitID].auras.buffs[info[#info]] end,
				set = function(info, value) E.db.sle.unitframes.unit[unitID].auras.buffs[info[#info]] = value; E:UpdateCooldownSettings('unitframe') end,
				args = {
					enable = {
						order = 1,
						name = L["Enable"],
						type = 'toggle',
					},
					threshold = {
						order = 2,
						type = 'range',
						name = L["Low Threshold"],
						desc = L["Threshold before text turns red and is in decimal form. Set to -1 for it to never turn red"],
						min = -1, max = 20, step = 1,
						disabled = function() return not E.db.sle.unitframes.unit[unitID].auras.buffs.enable end,
					},
				},
			},
			debuffs = {
				order = 2,
				type = 'group',
				name = L["Debuffs"],
				guiInline = true,
				get = function(info) return E.db.sle.unitframes.unit[unitID].auras.debuffs[info[#info]] end,
				set = function(info, value) E.db.sle.unitframes.unit[unitID].auras.debuffs[info[#info]] = value; E:UpdateCooldownSettings('unitframe') end,
				args = {
					enable = {
						order = 1,
						name = L["Enable"],
						type = 'toggle',
					},
					threshold = {
						order = 2,
						type = 'range',
						name = L["Low Threshold"],
						desc = L["Threshold before text turns red and is in decimal form. Set to -1 for it to never turn red"],
						min = -1, max = 20, step = 1,
						disabled = function() return not E.db.sle.unitframes.unit[unitID].auras.debuffs.enable end,
					},
				},
			},
		},
	}

	return config
end

local function configTable()
	if not SLE.initialized then return end
	local ACH = E.Libs.ACH

	E.Options.args.sle.args.modules.args.unitframes = {
		order = 1,
		type = 'group',
		name = L["UnitFrames"],
		childGroups = 'tab',
		disabled = function() return not E.private.unitframe.enable end,
		args = {
			desc = ACH:Description(L["Options for customizing unit frames. Please don't change these setting when ElvUI's testing frames for bosses and arena teams are shown. That will make them invisible until retoggling."], 1),
			Reset = {
				order = 2,
				type = 'execute',
				name = L["Restore Defaults"],
				desc = L["Reset these options to defaults"],
				func = function() SLE:Reset('unitframes') end,
			},
			general = {
				order = 10,
				type = 'group',
				name = L["General"],
				args = {
					roleIcons = {
						order = 1,
						type = 'group',
						inline = true,
						name = 'Role Icons',
						get = function(info)
							return E.db.sle.unitframes[info[#info-1]][info[#info]]
						end,
						set = function(info, value)
							E.db.sle.unitframes[info[#info-1]][info[#info]] = value
						end,
						args = {
							enable = {
								order = 1,
								type = 'toggle',
								name = L["Enable"],
								disabled = false,
							},
							icons = {
								order = 2,
								type = 'select',
								name = L["LFG Icons"],
								desc = L["Choose what icon set will unitframes and chat use."],
								values = function()
									wipe(roleValues)
									for name, path in pairs(SLE.rolePaths) do
										roleValues[name] = name..' |T'..path['TANK']..':15:15:0:0:64:64:2:56:2:56|t '..'|T'..path['HEALER']..':15:15:0:0:64:64:2:56:2:56|t '..'|T'..path['DAMAGER']..':15:15:0:0:64:64:2:56:2:56|t '
									end

									return roleValues
								end,
							},
						}
					},
				}
			},
			individualUnits = {
				order = 15,
				type = 'group',
				childGroups = 'tab',
				name = L["Individual Units"],
				args = {
					player = {
						order = 1,
						type = 'group',
						name = L["Player Frame"],
						args = {
							pvpIconText = {
								order = 5,
								type = 'group',
								name = L["PvP & Prestige Icon"],
								get = function(info) return E.db.sle.unitframes.unit.player.pvpIconText[info[#info]] end,
								set = function(info, value) E.db.sle.unitframes.unit.player.pvpIconText[info[#info]] = value; UF:Configure_PVPIcon(_G.ElvUF_Player) end,
								args = {
									enable = {
										order = 1,
										type = 'toggle',
										name = L["Enable"],
									},
									xoffset = {
										order = 2,
										type = 'range',
										name = L["X-Offset"],
										min = -300, max = 300, step = 1,
									},
									yoffset = {
										order = 3,
										type = 'range',
										name = L["Y-Offset"],
										min = -150, max = 150, step = 1,
									},
									level = {
										order = 4,
										type = 'toggle',
										name = LEVEL,
									},
								},
							},
							auras = CreateAurasConfig('player'),
						},
					},
					target = {
						order = 2,
						type = 'group',
						name = L["Target Frame"],
						args = {
							pvpIconText = {
								order = 5,
								type = 'group',
								name = L["PvP & Prestige Icon"],
								get = function(info) return E.db.sle.unitframes.unit.target.pvpIconText[info[#info]] end,
								set = function(info, value) E.db.sle.unitframes.unit.target.pvpIconText[info[#info]] = value; UF:Configure_PVPIcon(_G.ElvUF_Target) end,
								args = {
									level = {
										order = 4,
										type = 'toggle',
										name = LEVEL,
									},
								},
							},
							auras = CreateAurasConfig('target'),
						},
					},
					targettarget = {
						order = 3,
						type = 'group',
						name = L["TargetTarget Frame"],
						args = {
							auras = CreateAurasConfig('targettarget'),
						},
					},
					targettargettarget = {
						order = 4,
						type = 'group',
						name = L["TargetTargetTarget Frame"],
						args = {
							auras = CreateAurasConfig('targettargettarget'),
						},
					},
					focus = {
						order = 5,
						type = 'group',
						name = L["Focus Frame"],
						args = {
							auras = CreateAurasConfig('focus'),
						},
					},
					focustarget = {
						order = 6,
						type = 'group',
						name = L["FocusTarget Frame"],
						args = {
							auras = CreateAurasConfig('focustarget'),
						},
					},
					pet = {
						order = 7,
						type = 'group',
						name = L["Pet Frame"],
						args = {
							auras = CreateAurasConfig('pet'),
						},
					},
					pettarget = {
						order = 8,
						type = 'group',
						name = L["PetTarget Frame"],
						args = {
							auras = CreateAurasConfig('pettarget'),
						},
					},
				},
			},
			groupUnits = {
				order = 20,
				type = 'group',
				childGroups = 'tab',
				name = L["Group Units"],
				args = {
					party = {
						order = 1,
						type = 'group',
						name = L["Party Frames"],
						args = {
							configureToggle = {
								order = -10,
								type = 'execute',
								name = L["Display Frames"],
								func = function()
									UF:HeaderConfig(_G.ElvUF_Party, _G.ElvUF_Party.forceShow ~= true or nil)
								end,
							},
							offline = CreateOfflineConfig('party'),
							dead = CreateDeadConfig('party'),
							auras = CreateAurasConfig('party'),
						},
					},
					raid = {
						order = 2,
						type = 'group',
						name = L["Raid Frames"],
						args = {
							configureToggle = {
								order = -10,
								type = 'execute',
								name = L["Display Frames"],
								func = function()
									UF:HeaderConfig(_G.ElvUF_Raid, _G.ElvUF_Raid.forceShow ~= true or nil)
								end,
							},
							offline = CreateOfflineConfig('raid'),
							dead = CreateDeadConfig('raid'),
							auras = CreateAurasConfig('raid'),
						},
					},
					raid40 = {
						order = 3,
						type = 'group',
						name = L["Raid-40 Frames"],
						args = {
							configureToggle = {
								order = -10,
								type = 'execute',
								name = L["Display Frames"],
								func = function()
									UF:HeaderConfig(_G.ElvUF_Raid40, _G.ElvUF_Raid40.forceShow ~= true or nil)
								end,
							},
							offline = CreateOfflineConfig('raid40'),
							dead = CreateDeadConfig('raid40'),
							auras = CreateAurasConfig('raid40'),
						},
					},
					arena = {
						order = 4,
						type = 'group',
						name = L["Arena Frames"],
						args = {
							auras = CreateAurasConfig("arena"),
						},
					},
					boss = {
						order = 5,
						type = 'group',
						name = L["Boss Frames"],
						args = {
							auras = CreateAurasConfig('boss'),
						},
					},
				},
			},
			statusbars = {
				order = 50,
				type = 'group',
				name = L["Statusbars"],
				get = function(info) return E.db.sle.unitframes.statusTextures[info[#info]] end,
				set = function(info, value) E.db.sle.unitframes.statusTextures[info[#info]] = value; SUF:BuildStatusTable(); SUF:UpdateStatusBars() end,
				args = {
					power = {
						order = 1,
						type = 'toggle',
						name = L["Power"],
						disabled = function() return SLE._Compatibility['ElvUI_CustomTweaks'] end,
						get = function(info) return E.private.sle.unitframe.statusbarTextures[info[#info]] end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					powerTexture = {
						order = 2,
						type = 'select',
						name = L["Power Texture"],
						dialogControl = 'LSM30_Statusbar',
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.power or SLE._Compatibility['ElvUI_CustomTweaks'] end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					spacer1 = ACH:Spacer(3),
					cast = {
						order = 4,
						type = 'toggle',
						name = L["Castbar"],
						get = function(info) return E.private.sle.unitframe.statusbarTextures[info[#info]] end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					castTexture = {
						order = 5,
						type = 'select',
						name = L["Castbar Texture"],
						dialogControl = 'LSM30_Statusbar',
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.cast end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					spacer2 = ACH:Spacer(6),
					aura = {
						order = 7,
						type = 'toggle',
						name = L["Aura Bars"],
						get = function(info) return E.private.sle.unitframe.statusbarTextures[info[#info]] end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					auraTexture = {
						order = 8,
						type = 'select',
						name = L["Aura Bars Texture"],
						dialogControl = 'LSM30_Statusbar',
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.aura end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
					spacer3 = ACH:Spacer(9),
					class = {
						order = 10,
						type = 'toggle',
						name = L["Classbar"],
						get = function(info) return E.private.sle.unitframe.statusbarTextures[info[#info]] end,
						set = function(info, value) E.private.sle.unitframe.statusbarTextures[info[#info]] = value; E:StaticPopup_Show('PRIVATE_RL') end,
					},
					classTexture = {
						order = 11,
						type = 'select',
						name = L["Classbar Texture"],
						dialogControl = 'LSM30_Statusbar',
						disabled = function() return not E.private.unitframe.enable or not E.private.sle.unitframe.statusbarTextures.class end,
						set = function(info, value) E.db.sle.unitframes.statusTextures[info[#info]] = value; UF:CreateAndUpdateUF('player') end,
						values = AceGUIWidgetLSMlists.statusbar,
					},
				},
			},
		},
	}
end

tinsert(SLE.Configs, configTable)
