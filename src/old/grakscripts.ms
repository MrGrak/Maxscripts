--GrakScripts
--by Garrick@GarrickCampsey.com 
( --start script
global grakscriptsRollout
try destroyDialog grakscriptsRollout catch()
rollout grakscriptsRollout " GrakScripts"
(
	dropdownlist presetsDD "Choose a script to run:" items:#("CleanCopy", "Objekt", "Projektor", "SBC", "EasyLites") selection:1 pos:[5,5] width:240
	on presetsDD selected i do 
	(
		if presetsDD.items[i] == "CleanCopy" then	(try(fileIn "cleanCopyV3.ms")catch(messagebox "Cannot find cleanCopyV3.ms"))
		if presetsDD.items[i] == "Objekt" then	(try(fileIn "ObjektV1.ms")catch(messagebox "Cannot find ObjektV1.ms"))
		if presetsDD.items[i] == "Projektor" then	(try(fileIn "ProjektorV1.ms")catch(messagebox "Cannot find ProjektorV1.ms"))
		if presetsDD.items[i] == "SBC" then	(try(fileIn "SBCv3.ms")catch(messagebox "Cannot find SBCv3.ms"))
		if presetsDD.items[i] == "EasyLites" then	(try(fileIn "easyLitesV1.ms")catch(messagebox "Cannot find easyLitesV1.ms"))
	)
)
createDialog grakscriptsRollout 250 50 100 100 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script