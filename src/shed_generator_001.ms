--Shed Generator v001

/*

set roof type: gabled, flat
set option to add doors (0-3)
set option to add windows (per wall, 0-4)
each wall should have options: door, windows

create foundation for shed
create walls of shed
create roof for shed

provide sanity check for rafter length - if length exceeds stud height, 
dont allow build, warn user to reduce width of shed

*/

(
	
	local scriptTitle = " ShedGen v001 // by MrGrak"
	clearListener();
	global builderDialog
	try destroyDialog builderDialog catch()

	--set units to us american inches
	units.DisplayType = #US
	units.SystemType = #inches	

	--wall stud properties
	stud_width = 1.5
	stud_length = 3.5
	stud_height = 12 * 9 --in inches, 9ft 
	stud_price = 4.00
	stud_array = #()
	
	
	
	
	
	
	
	
	
	
	
	--rollout fields
	rolloutWidth = 260 
	rolloutHeight = 500
	
	feedbackString = "Builds procedural sheds."

	padStr = ""; --builds a string of _ chars that act as horizontal dividers
	(
		val = rolloutWidth / 6.5; -- width of _ char (tune to rl width)
		for g = 0 to val do ( padStr += "_"; ) 
	)
	
	studOptionsYoffset = 0
	buildingOptionYoffset = 110
	buildBtnOffset_Y = (rolloutHeight - 216) --anchors ui items to bottom of rollout
	
	rollout builderDialog scriptTitle
	(
		label label_stud_0 padStr pos:[6,12+studOptionsYoffset]
		--label label_stud_1 padStr pos:[6,60+studOptionsYoffset]
		label ChooseText0 "2x4 Stud Options" pos:[6,5+studOptionsYoffset]
		spinner rl_stud_width "(in) Width   :" range:[0.5,2.5,stud_width] type:#float fieldWidth:40 pos:[6,30+studOptionsYoffset]
		spinner rl_stud_length "(in) Length :" range:[2.5,4.5,stud_length] type:#float fieldWidth:41 pos:[6,50+studOptionsYoffset]
		spinner rl_stud_height "(in) Height  :" range:[12*1,12*20,stud_height] type:#float fieldWidth:50 pos:[130,30+studOptionsYoffset]
		spinner rl_stud_price "Board Cost  : $" range:[0.01,100.00,stud_price] type:#float fieldWidth:38 pos:[130,50+studOptionsYoffset]
		
		label label_house_0 padStr pos:[6,12+buildingOptionYoffset]
		--label label_house_1 padStr pos:[6,80+buildingOptionYoffset]
		--label label_house_2 "Note: rafters cannot exceed stud height" pos:[6,72+buildingOptionYoffset]
		label ChooseText1 "Building Options" pos:[6,5+buildingOptionYoffset]
		spinner rl_house_width "(in) Width   :" range:[12 * 5,12 * 15,12 * 10] type:#integer fieldWidth:40 pos:[6,30+buildingOptionYoffset]
		spinner rl_house_length "(in) Length :" range:[12 * 3,12 * 30,12 * 10] type:#integer fieldWidth:41 pos:[6,50+buildingOptionYoffset]
		spinner rl_wall_height "(in) Wall Height  :" range:[12 * 9,12 * 9,12 * 9] type:#integer fieldWidth:27 pos:[130,30+buildingOptionYoffset]
		spinner rl_roof_height "(in) Roof Height  :" range:[12 * 1,12 * 4,12 * 2] type:#integer fieldWidth:24 pos:[130,50+buildingOptionYoffset]
		dropdownlist gen_house_foundation "Foundation Type" items:#("Concrete","Pier Beam") width:113 pos:[6,75+buildingOptionYoffset]
		dropdownlist gen_house_roof "Roof Type" items:#("Gabled","Gabled") width:123 pos:[130,75+buildingOptionYoffset]
		button randBtn "Randomize" pos:[6,120+buildingOptionYoffset] width:247 height:20
		
		--
		
		label label_build_1 padStr pos:[6,0 + buildBtnOffset_Y]
		button runBTN ">  Build Shed  <" pos:[5,18 + buildBtnOffset_Y] width:(rolloutWidth-11) height:40
		label label_build_2 padStr pos:[6,197 + buildBtnOffset_Y]
		edittext feedbackBox text:feedbackString fieldWidth:(rolloutWidth-13) height:140 pos:[2,63 + buildBtnOffset_Y] readOnly:true
	)
	createDialog builderDialog rolloutWidth rolloutHeight 1450 600 lockWidth:true lockHeight:true style:#(#style_toolwindow, #style_sysmenu)
)