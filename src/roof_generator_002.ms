--roof generator
/*
builds a gable roof

add center beam support
add roof supports

build walls below roof, connecting top plate and rafters

figure out how builders support roof
figure out how many sheets it takes to build roof
place those sheets on roof
build supporting wood structure below, with overhang

*/

(
	local scriptTitle = " RoofGen - v002"
	clearListener();
	global builderDialog
	try destroyDialog builderDialog catch()

	--set units to us american inches
	units.DisplayType = #US
	units.SystemType = #inches

	--wall stud properties
	stud_length = 3.5
	stud_width = 1.5
	stud_height = 12 * 9 --in inches, 9ft 
	stud_price = 4.00
	stud_array = #()
	
	fn GetStud =
	(
		Stud = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:stud_length width:stud_width height:stud_height pos:[0,0,0] 
		Stud.wirecolor = [250, 220, 180]
		Stud.pos.z -= (stud_height * 0.5)
		append stud_array Stud --track how many studs are created
		Stud.name = "Stud_2x4_" + (stud_array.count as string)
		return Stud
	)
	
	fn BuildRoof = 
	(
		
		Roof = Plane lengthsegs:1 widthsegs:1 length:builderDialog.gen_length.value width:(builderDialog.gen_width.value*0.5) pos:[0,0,0]
		Roof.wirecolor = [200, 200, 200]
		Roof.name = "Roof_Base"
		Roof.pos.x = Roof.width * 0.5
		
		roofLength = Roof.length
		roofWidth = Roof.width
		roofHeight = builderDialog.gen_height.value
		
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
		
		--get positions for all verts in roof rough shape
		posA = polyop.getvert $ 1 --top front
		posB = polyop.getvert $ 2 --bottom front
		posC = polyop.getvert $ 3 --top back
		posD = polyop.getvert $ 4 --bottom back
		
		
		--add rafters, based on rise and run
		total = (roofLength / 16) + 1
		total = floor(total)
		--print total as string
		
		--build positive X side first
		for i = 0 to (total) do
		(	
			--build a 2x4 stud facing correct direction for rafter
			S = GetStud()
			rotate S (eulerangles 0 270 0)
			rotate S (eulerangles 90 0 0)
			
			--position rafter 16" on center
			S.pos = posB
			S.pos.y += (i * 16)
			
			--position last rafter at end of roof
			if(i == total) do ( S.pos.y = posD.y )
			--print i as string
			
			--rotate into rafter position
			run = posB.x + posA.x --posA.x is zero in this case
			rise = posB.z + posA.z --posB.z is zero in this case
			
			--divide rise by run, plug into arctan calc to get degree
			val = atan (rise / run) 
			rotate S (eulerangles 0 val 0)
			
			--trim stud to length, distance between bottom & top verts
			S.height = distance posA posB
			S.height += 1 --add an extra inch
			--limit height of stud 
			if(S.height > stud_height) then (S.height = stud_height)
		)
		
		--build negative X side next
		for i = 0 to (total) do
		(	
			--build a 2x4 stud facing correct direction for rafter
			S = GetStud()
			rotate S (eulerangles 0 270 0)
			rotate S (eulerangles 90 0 0)
			
			--position rafter 16" on center
			S.pos = posB
			S.pos.X *= -1
			rotate S (eulerangles 0 180 0)
			S.pos.y += (i * 16)
			
			--position last rafter at end of roof
			if(i == total) do ( S.pos.y = posD.y )
			
			--rotate into rafter position
			run = posB.x + posA.x --posA.x is zero in this case
			rise = posB.z + posA.z --posB.z is zero in this case
			
			--divide rise by run, plug into arctan calc to get degree
			val = atan (rise / run) 
			val *= -1
			rotate S (eulerangles 0 val 0)
			
			--trim stud to length, distance between bottom & top verts
			S.height = distance posA posB
			S.height += 1 --add an extra inch
			--limit height of stud 
			if(S.height > stud_height) then (S.height = stud_height)
		)
		
		--build horizontal beams (use multiple studs for large spans)
		for i = 0 to (total) do
		(	
			--build a 2x4 stud facing correct direction for rafter
			S = GetStud()
			rotate S (eulerangles 0 270 0)
			rotate S (eulerangles 90 0 0)
			
			--position beam 16" off center
			S.pos = posB
			S.pos.X *= -1
			rotate S (eulerangles 0 180 0)
			S.pos.y += (i * 16)
			S.pos.y += stud_width
			
			--position last rafter at end of roof
			if(i == total) then ( S.pos.y = (posD.y - stud_width) )
			
			--determine how many beams we need to span run
			run = (posB.x + posA.x) * 2 --posA.x is zero in this case
			--if run is less than height of beam, trim beam to run
			if(run / stud_height <= 1) then ( S.height = run; )
			else
			(
				--figure out how many studs we need
				runT = run / stud_height
				runTotal = floor(runT)
				--print runTotal as string
				
				for g = 1 to runTotal do
				(
					C = copy S
					C.pos.x += stud_height * g
					C.wirecolor = [250, 220, 180]
					append stud_array C --track how many studs are created
					C.name = "Stud_2x4_" + (stud_array.count as string)
					
					if(g == runTotal) then
					( 	--trim and limit height of stud 
						C.height = run - stud_height * runTotal 
						if(C.height > stud_height) then (C.height = stud_height)
					)
				)
			)
		)
		
		
		--build support beams
		
		
		
		
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
		
		spinner gen_width "(in) Width   :" range:[12 * 5,12 * 15,12 * 10] type:#integer fieldWidth:30 pos:[6,31]
		spinner gen_length "(in) Length :" range:[12 * 3,12 * 30,12 * 10] type:#integer fieldWidth:31 pos:[6,51]
		spinner gen_height "(in) Height  :" range:[12,54,12 * 3] type:#integer fieldWidth:30 pos:[6,71]
		button randBtn "Randomize" pos:[120,31] width:90 height:36
		
		label label1 "________________________________________________" pos:[6,107 + uiOffset_Y]
		button runBTN runBtnText pos:[5,127 + uiOffset_Y] width:289 height:40
		label label2 "________________________________________________" pos:[6,310 + uiOffset_Y]
		edittext feedbackBox text:feedbackString fieldWidth:287 height:140 pos:[2,174 + uiOffset_Y] readOnly:true
		label label3 "////////////////////////////////////////////////////////////////////////" pos:[6,330 + uiOffset_Y]
		
		fn Run =
		(
			--clear scene for new build test
			delete objects
			stud_array = #()
			
			tStart = timestamp()
			BuildRoof()
			tEnd = timestamp ()
			feedbackBox.text = ("Creation time: " + ((tEnd-tStart)/1000.0) as string + " seconds.")
			
			completeRedraw()
			--max tool zoomextents all
			clearSelection()
		)
		
		on runBTN pressed do Run()
		on randBtn pressed do 
		(
			gen_width.value = random 60 120
			gen_length.value = random 60 120
			gen_height.value = random 12 54
		)	
		--on gen_width changed arg do Run()
		--on gen_length changed arg do Run()
		--on gen_height changed arg do (gen_height.value = 36) --could sanitize values to limits
	)
	createDialog builderDialog 300 451 1400 700 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
)