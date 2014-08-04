﻿local E, L, V, P, G, _ = unpack(ElvUI);
local CFO = E:GetModule('CharacterFrameOptions')

local function configTable()
	E.Options.args.sle.args.characterframeoptions = {
		type = 'group',
		name = L["Armory Mode"],
		order = 6,
		childGroups = 'tab',
		args = {
			intro = {
				order = -1,
				type = 'description',
				name = L['Test Description'],
			},
			characterframe = {
				order = 2,
				type = 'group',
				name = L['Character Frame'],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Character Frame Options"],
					},
					intro = {
						order = 2,
						type = 'description',
						name = L['CFO_DESC'],
					},
					enable = {
						order = 3,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable/Disable Character Frame Options"],
						get = function(info) return E.private.sle.characterframeoptions.enable end,
						set = function(info, value) E.private.sle.characterframeoptions.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
					},
					decoration = {
						type = "group",
						name = L["Decoration"],
						order = 55,
						disabled = function() return not E.private.sle.characterframeoptions.enable end,
						args = {
							normalgradient = {
								order = 1,
								type = 'toggle',
								name = L["Show Equipment Gradients"],
								desc = L["Shows gradient effect for all equipment slots."],
								get = function(info) return E.db.sle.characterframeoptions.shownormalgradient end,
								set = function(info, value) E.db.sle.characterframeoptions.shownormalgradient = value; CFO:ChangeGradiantVisibility(); end,
							},
							errorgradient = {
								order = 2,
								type = 'toggle',
								name = L["Show Error Gradients"],
								desc = L["Highlights equipment slot if an error has been found."],
								disabled = function() return not E.private.sle.characterframeoptions.enable or not E.db.sle.characterframeoptions.shownormalgradient end,
								get = function(info) return E.db.sle.characterframeoptions.showerrorgradient end,
								set = function(info, value) E.db.sle.characterframeoptions.showerrorgradient = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							bgimage = {
								order = 3,
								type = 'toggle',
								name = L["Show Background Image"],
								get = function(info) return E.db.sle.characterframeoptions.showimage end,
								set = function(info, value) E.db.sle.characterframeoptions.showimage = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							dropdown = {
								type = 'select',
								name = L['Background picture'],
								order = 4,
								disabled = function() return not E.db.sle.characterframeoptions.showimage end,
								values = {
									['SPACE'] = 'Space',
									['ALLIANCE'] = FACTION_ALLIANCE,
									['HORDE'] = FACTION_HORDE, 
									['CUSTOM'] = L["Custom"],
									["EMPIRE"] = "The Empire",
									["CASTLE"] = "Castle",
								},
								get = function() return E.db.sle.characterframeoptions.image.dropdown end,
								set = function(_, value)
									E.db.sle.characterframeoptions.image.dropdown = value; CFO:ArmoryFrame_DataSetting();
								end,
								
							},
							custom = {
								order = 5,
								type = 'input',
								width = 'full',
								name = L["Texture"],
								desc = L["Set the texture to use in this frame. Requirements are the same as the chat textures."],
								disabled = function() return E.db.sle.characterframeoptions.image.dropdown ~= "CUSTOM" or not E.db.sle.characterframeoptions.showimage end,
								get = function() return E.db.sle.characterframeoptions.image.custom end,
								set = function(info, value) 
									E.db.sle.characterframeoptions.image.custom = value;
									CFO:ArmoryFrame_DataSetting();
								end,
							},
						},
					},
					itemlevel = {
						type = "group",
						name = STAT_AVERAGE_ITEM_LEVEL,
						order = 66,
						disabled = function() return not E.private.sle.characterframeoptions.enable end,
						args = {
							show = {
								order = 3,
								type = "toggle",
								name = L["Show Item Level"],
								get = function(info) return E.db.sle.characterframeoptions.itemlevel.show end,
								set = function(info, value) E.db.sle.characterframeoptions.itemlevel.show = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							fontGroup = {
								order = 5,
								type = 'group',
								guiInline = true,
								name = L['Font'],
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = L["The font that the item level will use."],
										values = AceGUIWidgetLSMlists.font,	
										get = function(info) return E.db.sle.characterframeoptions.itemlevel.font end,
										set = function(info, value) E.db.sle.characterframeoptions.itemlevel.font = value; CFO:ArmoryFrame_DataSetting(); end,
									},
									fontSize = {
										order = 2,
										name = L["Font Size"],
										desc = L["Set the font size that the item level will use."],
										type = "range",
										min = 6, max = 22, step = 1,
										get = function(info) return E.db.sle.characterframeoptions.itemlevel.fontSize end,
										set = function(info, value) E.db.sle.characterframeoptions.itemlevel.fontSize = value; CFO:ArmoryFrame_DataSetting(); end,
									},
									fontOutline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline that the item level will use."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROME'] = 'MONOCHROME',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
										get = function(info) return E.db.sle.characterframeoptions.itemlevel.fontOutline end,
										set = function(info, value) E.db.sle.characterframeoptions.itemlevel.fontOutline = value; CFO:ArmoryFrame_DataSetting(); end,
									},
								},
							},
						},
					},
					itemdurabilty = {
						type = "group",
						name = DURABILITY,
						order = 77,
						disabled = function() return not E.private.sle.characterframeoptions.enable end,
						args = {
							show = {
								order = 3,
								type = "toggle",
								name = L["Show Durability"],
								get = function(info) return E.db.sle.characterframeoptions.itemdurability.show end,
								set = function(info, value) E.db.sle.characterframeoptions.itemdurability.show = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							fontGroup = {
								order = 5,
								type = 'group',
								guiInline = true,
								name = L['Font'],
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = L["The font that the item durability will use."],
										values = AceGUIWidgetLSMlists.font,	
										get = function(info) return E.db.sle.characterframeoptions.itemdurability.font end,
										set = function(info, value) E.db.sle.characterframeoptions.itemdurability.font = value; CFO:ArmoryFrame_DataSetting(); end,
									},
									fontSize = {
										order = 2,
										name = L["Font Size"],
										desc = L["Set the font size that the item durability will use."],
										type = "range",
										min = 6, max = 22, step = 1,
										get = function(info) return E.db.sle.characterframeoptions.itemdurability.fontSize end,
										set = function(info, value) E.db.sle.characterframeoptions.itemdurability.fontSize = value; CFO:ArmoryFrame_DataSetting(); end,
									},
									fontOutline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline that the item durability will use."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROME'] = 'MONOCHROME',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
										get = function(info) return E.db.sle.characterframeoptions.itemdurability.fontOutline end,
										set = function(info, value) E.db.sle.characterframeoptions.itemdurability.fontOutline = value; CFO:ArmoryFrame_DataSetting(); end,
									},
								},
							},
						},
					},
					itemenchant = {
						type = "group",
						name = L["Enchanting"],
						order = 88,
						disabled = function() return not E.private.sle.characterframeoptions.enable end,
						args = {
							show = {
								order = 1,
								type = "toggle",
								name = L["Show Enchants"],
								desc = L["Show the enchantment effect near the enchanted item"],
								get = function(info) return E.db.sle.characterframeoptions.itemenchant.show end,
								set = function(info, value) E.db.sle.characterframeoptions.itemenchant.show = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							mouseover = {
								order = 2,
								type = "toggle",
								name = L['Mouse Over'],
								desc = L["Show the enchantment effect near the enchanted item (not the item itself) when mousing over."],
								disabled = function() return not E.db.sle.characterframeoptions.itemenchant.show or not E.private.sle.characterframeoptions.enable end,
								get = function(info) return E.db.sle.characterframeoptions.itemenchant.mouseover end,
								set = function(info, value) E.db.sle.characterframeoptions.itemenchant.mouseover = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							showwarning = {
								order = 3,
								type = "toggle",
								name = L["Show Warning"],
								get = function(info) return E.db.sle.characterframeoptions.itemenchant.showwarning end,
								set = function(info, value) E.db.sle.characterframeoptions.itemenchant.showwarning = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							warningsize = {
								order = 4,
								name = L["Warning Size"],
								desc = L["Set the icon size that the warning notification will use."],
								type = "range",
								min = 8, max = 18, step = 1,
								get = function(info) return E.db.sle.characterframeoptions.itemenchant.warningSize end,
								set = function(info, value) E.db.sle.characterframeoptions.itemenchant.warningSize = value; CFO:ResizeErrorIcon(); end,
							},
							fontGroup = {
								order = 5,
								type = 'group',
								guiInline = true,
								name = L['Font'],
								args = {
									font = {
										type = "select", dialogControl = 'LSM30_Font',
										order = 1,
										name = L["Font"],
										desc = L["The font that the enchant notification will use."],
										values = AceGUIWidgetLSMlists.font,	
										get = function(info) return E.db.sle.characterframeoptions.itemenchant.font end,
										set = function(info, value) E.db.sle.characterframeoptions.itemenchant.font = value; CFO:ArmoryFrame_DataSetting(); end,
									},
									fontSize = {
										order = 2,
										name = L["Font Size"],
										desc = L["Set the font size that the enchant notification will use."],
										type = "range",
										min = 6, max = 22, step = 1,
										get = function(info) return E.db.sle.characterframeoptions.itemenchant.fontSize end,
										set = function(info, value) E.db.sle.characterframeoptions.itemenchant.fontSize = value; CFO:ArmoryFrame_DataSetting(); end,
									},
									fontOutline = {
										order = 3,
										name = L["Font Outline"],
										desc = L["Set the font outline that the enchant notification will use."],
										type = "select",
										values = {
											['NONE'] = L['None'],
											['OUTLINE'] = 'OUTLINE',
											['MONOCHROME'] = 'MONOCHROME',
											['MONOCHROMEOUTLINE'] = 'MONOCROMEOUTLINE',
											['THICKOUTLINE'] = 'THICKOUTLINE',
										},
										get = function(info) return E.db.sle.characterframeoptions.itemenchant.fontOutline end,
										set = function(info, value) E.db.sle.characterframeoptions.itemenchant.fontOutline = value; CFO:ArmoryFrame_DataSetting(); end,
									},
								},
							},
						},
					},
					itemgem = {
						type = "group",
						name = L["Gem Sockets"],
						order = 99,
						disabled = function() return not E.private.sle.characterframeoptions.enable end,
						args = {
							show = {
								order = 1,
								type = "toggle",
								name = L["Show Gems"],
								desc = L["Show gem slots near the item"],
								get = function(info) return E.db.sle.characterframeoptions.itemgem.show end,
								set = function(info, value) E.db.sle.characterframeoptions.itemgem.show = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							showwarning = {
								order = 2,
								type = "toggle",
								name = L["Show Warning"],
								get = function(info) return E.db.sle.characterframeoptions.itemgem.showwarning end,
								set = function(info, value) E.db.sle.characterframeoptions.itemgem.showwarning = value; CFO:ArmoryFrame_DataSetting(); end,
							},
							warningsize = {
								order = 3,
								name = L["Warning Size"],
								desc = L["Set the icon size that the warning notification will use."],
								type = "range",
								min = 8, max = 18, step = 1,
								get = function(info) return E.db.sle.characterframeoptions.itemgem.warningSize end,
								set = function(info, value) E.db.sle.characterframeoptions.itemgem.warningSize = value; CFO:ResizeErrorIcon(); end,
							},
							socketsize = {
								order = 4,
								name = L["Socket Size"],
								desc = L["Set the size of sockets to show."],
								type = "range",
								min = 10, max = 18, step = 1,
								get = function(info) return E.db.sle.characterframeoptions.itemgem.socketSize end,
								set = function(info, value) E.db.sle.characterframeoptions.itemgem.socketSize = value; CFO:ResizeErrorIcon(); end,
							},
						},
					},
				},
			},
			inspectframe = {
				order = 2,
				type = 'group',
				name = L['Inspect Frame'],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Inspect Frame Options"],
					},
					intro = {
						order = 2,
						type = 'description',
						name = L['IFO_DESC'],
					},
					enable = {
						order = 3,
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable/Disable Inspect Frame Options"],
						get = function(info) return E.private.sle.inspectframeoptions.enable end,
						set = function(info, value) E.private.sle.inspectframeoptions.enable = value; E:StaticPopup_Show("PRIVATE_RL") end
					},
				},
			},
		},
	}
end

table.insert(E.SLEConfigs, configTable)