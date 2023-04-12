
--we are building a wall (with studs, cripples, windows, doors) from a spline

--X create wall with random length
--X add studs every 16"
--X add top, lock, and bottom plates, with lock plate offset of 24"

--add fn parameter to control addition of door
--door placement is based on stud offset (since we build based on stud)
--add fn parameter to control addition of windows, based on length of wall
--window placement is also based on stud offset
--if stud == 2, build window (example)
--doors have set sizes in north america, but windows dont
--we should have inputs to control the width, height, elevation of windows
--we can model and provide options for single pane and double pane, with price
--add price input field for stud cost
--add price input field for nail cost, factor in cost of nails, place nails too
--group each wall into an array, along with actually grouping them
--create 4 walls - 1 with a door, the others with windows
--organize objects onto layers so we can toggle through them





(
	local scriptTitle = " WallGenerator - v0.0.1"
	clearListener();
	global builderDialog
	try destroyDialog builderDialog catch()
	
	--delete objects
	clearSelection()
	
	--set units to us american inches
	units.DisplayType = #US
	units.SystemType = #inches

	--wall properties
	wallHeight = 12 * 9 --in inches, 9ft 
	wallWidth = 12 * 5 --in inches, 5ft
	
	
	
	
	fn drawLineBetweenTwoPoints pointA pointB =
	(
		ss = SplineShape pos:pointA
		addNewSpline ss
		addKnot ss 1 #corner #line PointA
		addKnot ss 1 #corner #line PointB
		updateShape ss
		ss
	)

	
	
	
	--wall stud properties
	stud_length = 3.5
	stud_width = 1.5
	stud_price = 4.00
	stud_array = #()
	
	fn GetStud =
	(
		Stud = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:stud_length width:stud_width height:wallHeight pos:[0,0,0] 
		Stud.wirecolor = [250, 220, 180]
		Stud.pos.z -= (wallHeight * 0.5)
		append stud_array Stud --track how many studs are created
		Stud.name = "Stud_2x4_" + (stud_array.count as string)
		return Stud
	)
	
	
	
	--door properties
	buildDoor = true
	doorStudOffset = 3
	door_height = 80
	door_width = 36
	door_price = 120.00
	door_array = #()
	
	fn GetDoor =
	(
		Door = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:1.75 width:door_width height:door_height pos:[0,0,0] 
		Door.wirecolor = [150, 150, 150]
		append door_array Door
		Door.name = "Door_" + (door_array.count as string)
		return Door
	)
	
	
	
	fn BuildPlate zPos = 
	(
		plate_array = #()
		
		for i = 0 to wallWidth do
		(
			local build = false
			
			if(mod i wallHeight == 0)then(build = true)
			if(i == 0)then(build = true)
			
			if(build) then
			(
				local S = GetStud()
				S.pos.x = i - (stud_width * 0.5)
				S.pos.y = 0
				S.pos.z = zPos
				rotate S (eulerangles 0 90 0)
				append plate_array S
			)
		)
		
		--trim last stud to width
		local S = stud_array[stud_array.count]
		S.height -= (S.pos.x + wallHeight) - wallWidth - (stud_width * 0.5)
		--S.wirecolor = [255, 0, 0]
	)
	
	fn BuildLockPlate zPos = 
	(
		plate_array = #()
		
		(	--build first stud 24" max
			local S = GetStud()
			S.pos.x = 0 - (stud_width * 0.5)
			S.pos.y = 0
			S.pos.z = zPos
			S.height = 24
			--S.wirecolor = [255, 0, 0]
			rotate S (eulerangles 0 90 0)
			append plate_array S
		)
			
		for i = 0 to (wallWidth - 24) do
		(
			local build = false
			
			if(mod i wallHeight == 0)then(build = true)
			if(i == 0)then(build = true)
			
			if(build) then
			(
				local S = GetStud()
				S.pos.x = 24 + i - (stud_width * 0.5)
				S.pos.y = 0
				S.pos.z = zPos
				rotate S (eulerangles 0 90 0)
				append plate_array S
			)
		)
		
		--trim last stud to width
		local S = stud_array[stud_array.count]
		S.height -= (S.pos.x + wallHeight) - (wallWidth) - (stud_width * 0.5)
		--S.wirecolor = [255, 0, 0]
	)

	
	
	
	fn BuildWall =
	(
		--spline_1 = drawLineBetweenTwoPoints [0,0,0] [0 + wallWidth,0,0]
		
		--shell the wall for visualization 
		/*
		local wall_mod = extrude amount:wallHeight
		local wall_shell = shell outerAmount:0
		wall_shell.innerAmount = 1 --in nches
		wall_shell.outerAmount = 0
		addModifier spline_1 (wall_mod)
		addModifier spline_1 (wall_shell)
		*/
		
		--studs are placed every 16" along spline
		local studIndex = 0;
		local buildingDoor = false;
		
		for i = 0 to wallWidth do
		(
			local build = false
			
			if(mod i 16 == 0)then(build = true)
			if(i == 0)then(build = true)
			if(i == wallWidth)then(build = true)
			
			if(build) then
			(
				local S = GetStud()
				S.pos.x = i
				S.pos.y = 0
				S.pos.z = 0
				studIndex += 1
				redrawViews()
			)
			
			--check to see if we need to start build of door at this stud
			if(buildDoor) then
			(
				if(doorStudOffset == studIndex) then
				( 
					if(buildingDoor == false) then
					(
						--build main door panel, plus surrounding studs
						buildingDoor = true
						local D = GetDoor()
						D.pos.x = i + (door_width * 0.5) + (stud_width * 0.5) + (stud_width)
						D.pos.y = 0
						D.pos.z = 0
						
						--set trimmer studs
						local L = GetStud()
						L.name = "Stud_2x4_Trimmer_" + (stud_array.count as string)
						L.pos.x = i + stud_width
						L.pos.y = 0
						L.pos.z = 0
						
						local R = GetStud()
						R.name = "Stud_2x4_Trimmer_" + (stud_array.count as string)
						R.pos.x = i + 36 + (stud_width * 2)
						R.pos.y = 0
						R.pos.z = 0
						
						local RR = GetStud()
						RR.name = "Stud_2x4_Trimmer_" + (stud_array.count as string)
						RR.pos.x = i + 36 + (stud_width * 3)
						RR.pos.y = 0
						RR.pos.z = 0
						
						--set header studs
						local H = GetStud()
						H.name = "Stud_2x4_Header_" + (stud_array.count as string)
						H.pos.x = i + stud_width + (stud_width * 0.5)
						H.pos.y = 0
						H.pos.z = door_height + (stud_width * 0.5) + 0.1
						rotate H (eulerangles 0 90 0)
						H.height = door_width
						
						local HH = GetStud()
						HH.name = "Stud_2x4_Header_" + (stud_array.count as string)
						HH.pos.x = i + stud_width + (stud_width * 0.5)
						HH.pos.y = 0
						HH.pos.z = door_height + (stud_width * 0.5) + 0.1
						HH.pos.z += stud_width
						rotate HH (eulerangles 0 90 0)
						HH.height = door_width
					)
				)
			)
			
			--trim the next 2 studs in build process - managed by studIndex & buildingDoor
			if(buildingDoor) then 
			(
				if(mod i 16 == 0) then --only check when a stud is made
				(
					if(doorStudOffset == studIndex - 1) then 
					(
						--modify stud to be cripple (last stud added)
						local S = stud_array[stud_array.count]
						S.height -= (door_height + (stud_width * 2))
						S.pos.z += (door_height + (stud_width * 2))
					)
					else if(doorStudOffset == studIndex - 2) then 
					(
						--modify stud to be cripple (last stud added)
						local S = stud_array[stud_array.count]
						S.height -= (door_height + (stud_width * 2))
						S.pos.z += (door_height + (stud_width * 2))
						
						buildingDoor = false
						
						--build another door, if there is enough space
						--if(i < (wallWidth - door_width - (16 * 2))) then
						--( doorStudOffset += 3 )
						--this is a nice way to do windows
					)
				)
			)
		)
		
		--build top plate
		BuildPlate (wallHeight + (stud_width * 0.5))
		--build lock plate
		BuildLockPlate (wallHeight + (stud_width * 0.5) + stud_width)
		--build bottom/sole plate
		BuildPlate (stud_width * -0.5)
		
		
	)

	
	
	
	
	feedbackString = "WallGenerator builds walls." --this variable holds a string of feedback
	local runBtnText = ">  Build  <"
	uiOffset_Y = 100
	
	rollout builderDialog scriptTitle
	(
		--UI
		label label0 "________________________________________________" pos:[6,12]
		label ChooseText "Choose Options" pos:[6,5]
		
		spinner gen_house_width "(ft) Width:" range:[5,100,10] type:#integer fieldWidth:30 pos:[6,31]
		spinner gen_house_height "(ft) Height:" range:[9,9,9] type:#integer fieldWidth:30 pos:[115,31]
		
		checkbox door_check "Door" pos:[6,51] checked:true
		spinner door_offset "Offset:" range:[1,20,3] type:#integer fieldWidth:30 pos:[55,52]
		
		--dropdownlist gen_house_foundation "Foundation Type" items:#("Concrete","Pier Beam") width:90 pos:[6,51]
		
		/*
		checkbox GripCheck "Grip" pos:[6,53] checked:true
		checkbox GripSafetyCheck "Grip Safety" pos:[199,75] checked:true enabled:true
		checkbox TriggerHousingCheck "Trigger Housing" pos:[199,97] checked:true enabled:true
		*/
		
		label label1 "________________________________________________" pos:[6,107 + uiOffset_Y]
		button runBTN runBtnText pos:[5,127 + uiOffset_Y] width:289 height:40
		label label2 "________________________________________________" pos:[6,310 + uiOffset_Y]
		edittext feedbackBox text:feedbackString fieldWidth:287 height:140 pos:[2,174 + uiOffset_Y] readOnly:true
		label label3 "////////////////////////////////////////////////////////////////////////" pos:[6,330 + uiOffset_Y]
		
		fn Run =
		(
			--delete objects
			
			--clear all arrays being used
			stud_array = #()
			door_array = #()
			
			--get values from ui to build with
			wallWidth = (builderDialog.gen_house_width.value * 12)
			doorStudOffset = (builderDialog.door_offset.value)
			buildDoor = (builderDialog.door_check.state)
			
			
			tStart = timestamp()
			BuildWall()
			tEnd = timestamp ()
			feedbackBox.text = ("Creation time: " + ((tEnd-tStart)/1000.0) as string + "seconds.")
			
			--dump wall report
			feedbackBox.text += ("\nWall Dimensions: " + wallWidth as string + ", " + wallHeight as string + " inches")
			feedbackBox.text += ("\nCost of studs: $" + (stud_array.count * stud_price) as string + ", " + stud_array.count as string + " x $" + stud_price as string)
			feedbackBox.text += ("\nCost of doors: $" + (door_array.count * door_price) as string + ", " + door_array.count as string + " x $" + door_price as string)
			local total = ((stud_array.count * stud_price) + (door_array.count * door_price))
			feedbackBox.text += ("\nTotal: $" + total as string)
			
			completeRedraw()
			max tool zoomextents all
			clearSelection()
		)
		
		on runBTN pressed do (Run(););
	)
	createDialog builderDialog 300 451 4 88 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
)