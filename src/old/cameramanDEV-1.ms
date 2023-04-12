
global SBCcontainerRollout
   global stretchyBonesCreatorStruct
   --destroy any currently open SBCcontainerRollout
   try destroyDialog SBCcontainerRollout catch()
   ( --start script
   	struct stretchyBonesCreatorStruct 
   	(
   	fn searchForSBCchains = (
   		print "test"
   	),
   	fn closeDownWeights = ()
   	)
   	stretchyBonesCreatorStruct = stretchyBonesCreatorStruct()
   	--rollouts for UI
   	rollout SBCcontainerRollout "  Cameraman v0.01"
   	(
   		subrollout stretchyBonesCreatorSUB
   	)
   	rollout stretchyBonesCreator "Ctrl Options                                                                  "
   	(
   	--define UI
   	radioButtons ctrlTypeBTN "" pos:[5,10] width:180 height:16 labels:#("Spheres", "P.Helpers") columns:2 default:1
   	colorPicker ctrlColorPicker "" pos:[230,11] width:45 height:16 color:(color 0 114 255)
   	spinner ctrlSizeSPN "Size: " pos:[168,11] width:50 height:16 type:#integer range:[0.01,1000,10]
   	editText ctrlsLayerNameEditText "" pos:[3,36] width:190 height:18 text:"controls"
   	button setCtrlLayerBTN "Set Layer" pos:[210,36] width:64 height:18
   	)
   	--create dialog and add subrollouts
   	createDialog SBCcontainerRollout 320 710 100 100 style:#(#style_toolwindow, #style_sysmenu)
   	AddSubRollout SBCcontainerRollout.stretchyBonesCreatorSUB stretchyBonesCreator
   	SBCcontainerRollout.stretchyBonesCreatorSUB.height   = 700
   	SBCcontainerRollout.stretchyBonesCreatorSUB.width = 300
   	SBCcontainerRollout.stretchyBonesCreatorSUB.pos = [10,1]
   	--init
   	stretchyBonesCreatorStruct.searchForSBCchains()
   ) --end script


