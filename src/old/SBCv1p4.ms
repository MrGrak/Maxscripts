--SBC v1.4
--by Garrick Campsey 2010
--garrick@garrickcampsey.com

-- access this scripts functions via stretchyBonesCreatorStruct.<function>

( --start script
global SBCcontainerRollout
global stretchyBonesCreatorStruct
--destroy any currently open SBCcontainerRollout
try destroyDialog SBCcontainerRollout catch()
struct stretchyBonesCreatorStruct 
(
--the structs functions and purpose
fn searchForSBCchains = (),
fn chainManager = (),
fn buildBones = (),
fn buildCtrls = (),
fn clickToCreateLine = (),
fn clickToCreateCircle = (),
fn deleteSelectedChain = (),
fn resetSBC = (),
fn projectSelected = (),
fn linkOneToOne = (),
fn quickSkin = (),
fn openUpWeights = (),
fn closeDownWeights = (),

--functions
fn searchForSBCchains = 
(

),
fn chainManager = 
(

),
fn buildBones = 
(

),
fn buildCtrls = 
(

),
fn clickToCreateLine = 
(

),
fn clickToCreateCircle = 
(

),
fn deleteSelectedChain = 
(

),
fn resetSBC = 
(

),
fn projectSelected = 
(

),
fn linkOneToOne = 
(

),
fn quickSkin = 
(

),
fn openUpWeights = 
(

),
fn closeDownWeights = 
(

)

) --close struct definition

--rollouts for UI
rollout SBCcontainerRollout " Stretchy Bones Creator v1.4"
(
	subrollout SBC_SUB
)
rollout ctrlOptions "Ctrl Options                                                                "
(
	radioButtons ctrlTypeBTN "" pos:[5,5] width:180 height:16 labels:#("Spheres", "P.Helpers") columns:2 default:1
	colorPicker ctrlColorPicker "" pos:[230,6] width:45 height:16 color:(color 0 114 255)
	spinner ctrlSizeSPN "Size: " pos:[168,6] width:50 height:16 type:#integer range:[0.01,1000,10]
	editText ctrlsLayerNameEditText "" pos:[3,31] width:190 height:18 text:"controls"
	button setCtrlLayerBTN "Set Layer" pos:[210,31] width:64 height:18
)
rollout boneOptions "Bone Options                                                            "
(
	radioButtons boneTypeBTN "" pos:[5,5] width:158 height:16 labels:#("Bone", "BoxMode") columns:2
	colorPicker boneColorPicker "" pos:[230,6] width:45 height:16 color:(color 114 114 114)
	spinner ctrlSizeSPN "Size: " pos:[168,6] width:50 height:16 type:#integer range:[0.01,1000,10]
	editText bonesLayerNameEditText "" pos:[3,31] width:190 height:18 text:"bones"
	button setBoneLayerBTN "Set Layer" pos:[210,31] width:64 height:18
)
rollout createOptions "Create Options                                                          "
(
	button clickToCreateBTN "Enable Click to Create Line" pos:[5,8] width:180 height:20
	button clickToCreateBTN2 "Enable Click to Create Circle" pos:[5,30] width:180 height:20
	--
	groupBox mirrorOptionsGrp "Mirror:" pos:[204,3] width:70 height:80
	checkbox XmirrorCheck "X axis" checked:false pos:[215,20]
	checkbox YmirrorCheck "Y axis" checked:false pos:[215,40]
	checkbox ZmirrorCheck "Z axis" checked:false pos:[215,60]
	--
	spinner numOfCTRLStoMakeSPN "# of CTRLs to make:  " pos:[85,67] width:95 height:16 range:[1,20,1] type:#integer
	
	
	
	--button makeCircleBTN "MAKE a circle" pos:[142,95] width:125 height:18
	button addChildrenBTN "ADD # of ctrls to selected" pos:[5,90] width:270 height:18
)
rollout deleteOptions "Undo, Delete, Reset                                                 "
(
	button UNDOBTN "UNDO last chain" pos:[10,10] width:120 height:53
	button deleteSelectedBTN "DELETE selected chain" pos:[137,10] width:130 height:24
	button resetSBCbtn "RESET SBC" pos:[197,45] width:70 height:18
)	
rollout weldOptions "Weld Ctrls                                                                "
(
	button linkSelectedBTN "weld CTRL" pos:[10,10] width:110 height:24
	label lbl2 "to:" pos:[133,13] width:17 height:17
	pickbutton linkSingle2ParentBTN "CTRL" pos:[157,10] width:110 height:24
)

rollout projectOptions "Project Options                                                         "
(
	button projectStickBTN "STICK" pos:[5,10] tooltip:"Press to stick it." width:60
		label lbl3 "selected along World" pos:[74,14] width:140 height:16
		radioButtons axisToProjectRDO "" pos:[185,13] width:120 height:16 labels:#("X", "Y", "Z") columns:3
		label lbl4 "axis to:" pos:[213,35] width:140 height:16
		pickbutton meshToStickToBTN "object" tooltip:"Pick a scene object" autoDisplay:true width:70 pos:[200,55]
)


	
	 -- -5,-14




















--create dialog and add subrollouts + their properties
createDialog SBCcontainerRollout 320 710 100 100 style:#(#style_toolwindow, #style_sysmenu)

--add subrollouts to main rollout
AddSubRollout SBCcontainerRollout.SBC_SUB ctrlOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB boneOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB createOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB deleteOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB weldOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB projectOptions rolledUp:false

--rolled up property?
--styles for sub rollouts
SBCcontainerRollout.SBC_SUB.height = 700
SBCcontainerRollout.SBC_SUB.width = 300
SBCcontainerRollout.SBC_SUB.pos = [10,1]

--init
stretchyBonesCreatorStruct.searchForSBCchains()
) --end script









