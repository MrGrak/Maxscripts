--roof generator
/*
builds a gable roof

figure out how builders support roof
figure out how many sheets it takes to build roof
place those sheets on roof
build supporting wood structure

*/

(
	local scriptTitle = " RoofGen - v001"
	clearListener();
	global builderDialog
	try destroyDialog builderDialog catch()

	--set units to us american inches
	units.DisplayType = #US
	units.SystemType = #inches

	fn BuildRoof = 
	(
		
		Roof = Plane lengthsegs:1 widthsegs:1 length:builderDialog.gen_length.value width:(builderDialog.gen_width.value*0.5) pos:[0,0,0]
		Roof.wirecolor = [200, 200, 200]
		Roof.name = "Roof_Base"
		Roof.pos.x = Roof.width * 0.5
		
		ConvertTo Roof Editable_Poly
		select Roof
		
		--raise verts to desired height
		pos=polyop.getvert $ 1
		polyop.setvert $ 1 [pos.x,pos.y,builderDialog.gen_height.value]
		
		pos=polyop.getvert $ 3
		polyop.setvert $ 3 [pos.x,pos.y,builderDialog.gen_height.value]
		
		--set pivot to zero and mirror roof 
		Roof.pivot = [0,0,0]
		m = Mirror copy:true offset:(builderDialog.gen_width.value *-0.5)
		addmodifier Roof (m)
		
		clearSelection()
	)
	
	feedbackString = "Builds gabled roofs." --this variable holds a string of feedback
	local runBtnText = ">  Build  <"
	uiOffset_Y = 100
	
	rollout builderDialog scriptTitle
	(
		--UI
		label label0 "________________________________________________" pos:[6,12]
		label ChooseText "Choose Options" pos:[6,5]
		
		spinner gen_width "(in) Width:" range:[1,1000,12 * 10] type:#integer fieldWidth:30 pos:[6,31]
		spinner gen_length "(in) Length:" range:[1,1000,12 * 10] type:#integer fieldWidth:30 pos:[6,51]
		spinner gen_height "(in) Height:" range:[1,1000,12 * 3] type:#integer fieldWidth:30 pos:[6,71]
		
		label label1 "________________________________________________" pos:[6,107 + uiOffset_Y]
		button runBTN runBtnText pos:[5,127 + uiOffset_Y] width:289 height:40
		label label2 "________________________________________________" pos:[6,310 + uiOffset_Y]
		edittext feedbackBox text:feedbackString fieldWidth:287 height:140 pos:[2,174 + uiOffset_Y] readOnly:true
		label label3 "////////////////////////////////////////////////////////////////////////" pos:[6,330 + uiOffset_Y]
		
		fn Run =
		(
			--clear scene for new build test
			delete objects
			
			tStart = timestamp()
			BuildRoof()
			tEnd = timestamp ()
			feedbackBox.text = ("Creation time: " + ((tEnd-tStart)/1000.0) as string + " seconds.")
			
			completeRedraw()
			--max tool zoomextents all
			clearSelection()
		)
		
		on runBTN pressed do (Run(););
	)
	createDialog builderDialog 300 451 1400 400 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
)