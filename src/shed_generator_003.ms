--Shed Generator

/*


add windows on opposite walls - need to add window routines!
we can have single pane and double pane windows, display cost in report too
we should be able to set num of windows we want per wall
research how windows are framed in walls, there will be cripples above and below

add rafter supports and front/back support faces

add door handle + hinges to doors

open doors so players can pass through them

add particle board exterior covering on walls 
add particle board interior covering on ceiling
add particle board interior covering on walls
add particle board to report cost

add insulation meshes and cost estimates, with drop down types (based on volume)

add steel roof, with supports
add roof insulation

can we partition the room into bathroom / living space / kitchen?
then we could build/design a bathroom




add human reference model
add queen size bed to room
add toilet
add shower
add sink (similar setup to current bathroom)
add water heater
add pipe conections between water heater and sink (through walls)
add waste water outlets for sink, toilet, shower
add cabinets in bathroom for storage
kitchen sink
kitchen oven + stovetop
kitchen dishwasher

laundry washer
laundry dryer

fuse box + power supply (pole)


*/

(
	
	local scriptTitle = "ShedGen v003"
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
	
	fn GetStud =
	(
		Stud = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:stud_length width:stud_width height:stud_height pos:[0,0,0] 
		Stud.wirecolor = [250, 220, 180]
		Stud.pos.z -= (stud_height * 0.5)
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
	
	
	
	
	
	--util methods
	fn delete_empty_layers =
	(
		local counter = 0
	 
		for id = LayerManager.count - 1 to 1 by -1 do
		(
			local layer = LayerManager.getLayer id
			local contains_nodes = LayerManager.doesLayerHierarchyContainNodes layer.name
			if not contains_nodes then
			(
				local deleted = LayerManager.deleteLayerByName layer.name
				if deleted then counter += 1
			)
		)
	)

	fn BuildPlate zPos wLength = 
	(
		plate_array = #()
		
		for i = 0 to wLength do
		(
			local build = false
			
			if(mod i stud_height == 0)then(build = true)
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
		S.height -= (S.pos.x + stud_height) - wLength - (stud_width * 0.5)
		--S.wirecolor = [255, 0, 0]
		return plate_array
	)
	
	fn BuildLockPlate zPos wLength = 
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
			
		for i = 0 to (wLength - 24) do
		(
			local build = false
			
			if(mod i stud_height == 0)then(build = true)
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
		S.height -= (S.pos.x + stud_height) - (wLength) - (stud_width * 0.5)
		--S.wirecolor = [255, 0, 0]
		return plate_array
	)
	
	fn BuildWall wLength wName =
	(
		foundationThickness = builderDialog.rl_concreteThicness.value
		compArray = #()
		
		bottomPlates = BuildPlate (foundationThickness + (stud_width * 0.5)) wLength
		compArray = compArray + bottomPlates
		
		topPlates = BuildPlate (foundationThickness + stud_height + (stud_width * 1.5)) wLength
		compArray = compArray + topPlates
		
		lockPlates = BuildLockPlate (foundationThickness + stud_height + (stud_width * 2.5)) wLength
		compArray = compArray + lockPlates
		
		
		--studs are placed every 16" along spline
		local studIndex = 0;
		local buildingDoor = false;
		
		for i = 0 to wLength do
		(
			local build = false
			
			if(mod i 16 == 0)then(build = true)
			if(i == 0)then(build = true)
			if(i == floor(wLength))then(build = true)
			
			if(build) then
			(
				local S = GetStud()
				S.pos.x = i
				S.pos.y = 0
				S.pos.z = foundationThickness + (stud_width)
				studIndex += 1
				append compArray S
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
						D.pos.z = foundationThickness + (stud_width)
						append compArray D
						
						--set trimmer studs
						local L = GetStud()
						L.name = "Stud_2x4_Trimmer_" + (stud_array.count as string)
						L.pos.x = i + stud_width
						L.pos.y = 0
						L.pos.z = foundationThickness + (stud_width)
						append compArray L
						
						local R = GetStud()
						R.name = "Stud_2x4_Trimmer_" + (stud_array.count as string)
						R.pos.x = i + 36 + (stud_width * 2)
						R.pos.y = 0
						R.pos.z = foundationThickness + (stud_width)
						append compArray R
						
						local RR = GetStud()
						RR.name = "Stud_2x4_Trimmer_" + (stud_array.count as string)
						RR.pos.x = i + 36 + (stud_width * 3)
						RR.pos.y = 0
						RR.pos.z = foundationThickness + (stud_width)
						append compArray RR
						
						--set header studs
						local H = GetStud()
						H.name = "Stud_2x4_Header_" + (stud_array.count as string)
						H.pos.x = i + stud_width + (stud_width * 0.5)
						H.pos.y = 0
						H.pos.z = foundationThickness + (stud_width) + door_height + (stud_width * 0.5) + 0.1
						rotate H (eulerangles 0 90 0)
						H.height = door_width
						append compArray H
						
						local HH = GetStud()
						HH.name = "Stud_2x4_Header_" + (stud_array.count as string)
						HH.pos.x = i + stud_width + (stud_width * 0.5)
						HH.pos.y = 0
						HH.pos.z = foundationThickness + (stud_width) + door_height + (stud_width * 0.5) + 0.1
						HH.pos.z += stud_width
						rotate HH (eulerangles 0 90 0)
						HH.height = door_width
						append compArray HH
						
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
					)
				)
			)
			
			
		)
		
		
		
		--add wall studs to layer that is unique to this wall
		local layer = LayerManager.getLayerFromName wName
		if(layer == undefined) then 
		(
			local layer = LayerManager.newLayer()
			layer.setname wName
		)
		for n in compArray do layer.addnode n
		
		
		
		g = group compArray
		select g
		return g;
	)
	
	
	
	
	--main build method
	fn BuildShed = 
	(
		-- collect variables from dialog and shorten them for local use
		foundationThickness = builderDialog.rl_concreteThicness.value
		roofLength = builderDialog.rl_house_length.value
		roofWidth = builderDialog.rl_house_width.value
		roofHeight = builderDialog.rl_roof_height.value
		wallHeight = builderDialog.rl_wall_height.value
		roofOverhang_length = builderDialog.rl_roofOverhang_length.value
		
		roofZoffset = stud_width * 3 + (stud_length * 0.5)
		rafterSpacing = builderDialog.rl_rafterSpacing_length.value
		
		
		
		-- //////////////////// Layer initialization //////////////////// --
		(
			--create various layers to sort geometry to
			local layer = LayerManager.getLayerFromName "Roof"
			if(layer == undefined) then 
			(
				local layer = LayerManager.newLayer()
				layer.setname "Roof"
			)
			
			layer = LayerManager.getLayerFromName "Concrete"
			if(layer == undefined) then 
			(
				local layer = LayerManager.newLayer()
				layer.setname "Concrete"
			)
			
			
			--use case
			--layer = LayerManager.getLayerFromName "Lumber"
			--layer.addnode n
			--for n in (selection as array) do layer.addnode n
		)
		
		
		/*
		-- //////////////////// Build 1 Acre land //////////////////// --
		local acre = 208.71 * 12
		Land = Plane lengthsegs:10 widthsegs:10 length:acre width:acre pos:[0,0,-1]
		Land.wirecolor = [0, 30, 0]
		Land.name = "Land_1_Acre"
		*/
		
		-- //////////////////// Build Foundation //////////////////// --
		Foundation = Box lengthsegs:5 widthsegs:5 heightsegs:1 length:(roofLength+3) width:(roofWidth+2) height:foundationThickness pos:[0,0,0]
		Foundation.wirecolor = [100, 100, 100]
		Foundation.name = "Foundation_Concrete"
		(local layer = LayerManager.getLayerFromName "Concrete"
		layer.addnode Foundation)
		
		
		-- //////////////////// Build Roof //////////////////// --
		Roof = Plane lengthsegs:1 widthsegs:1 length:roofLength width:(roofWidth*0.5) pos:[0,0,0]
		Roof.wirecolor = [100, 20, 20]
		Roof.name = "Roof_Base"
		Roof.pos.x = Roof.width * 0.5
		
		ConvertTo Roof Editable_Poly
		select Roof
		
		--raise verts to desired height
		pos=polyop.getvert $ 1
		polyop.setvert $ 1 [pos.x,pos.y,roofHeight]
		
		pos=polyop.getvert $ 3
		polyop.setvert $ 3 [pos.x,pos.y,roofHeight]
		
		--set pivot to zero and mirror roof 
		Roof.pivot = [0,0,0]
		m = Mirror copy:true offset:(roofWidth *-0.5)
		addmodifier Roof (m)
		
		--offset roof by wall amount
		Roof.pos.z = wallHeight + foundationThickness + roofZoffset
		
		--get positions for all verts in roof rough shape
		posA = polyop.getvert $ 1 --top front
		posB = polyop.getvert $ 2 --bottom front
		posC = polyop.getvert $ 3 --top back
		posD = polyop.getvert $ 4 --bottom back
		
		--add rafters, based on rise and run
		total = (roofLength / rafterSpacing) + 1
		total = floor(total)
		--print total as string
		
		
		
		
		
		--build ridge beam center of roof
		(
			S = GetStud()
			rotate S (eulerangles 90 0 0)
			S.pos = [0,0,0]
			S.pos.z = wallHeight + foundationThickness + roofZoffset + roofHeight
			--S.pos.z -= 1 --align with rafters
			S.pos.y += roofLength * 0.5
			S.pos.y += stud_width * 0.5 --offset to align with rafter beams
			
			local layer = LayerManager.getLayerFromName "Roof"
			layer.addnode S
			
			--determine how many beams we need to span run
			run = distance posA posC
			run += stud_width --offset to align with rafter beams
			
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
					C.pos.y -= stud_height * g
					C.wirecolor = [250, 220, 180]
					append stud_array C --track how many studs are created
					C.name = "Stud_2x4_" + (stud_array.count as string)
					local layer = LayerManager.getLayerFromName "Roof"
					layer.addnode C
					
					if(g == runTotal) then
					( 	--trim and limit height of stud 
						C.height = run - stud_height * runTotal 
						if(C.height > stud_height) then (C.height = stud_height)
					)
				)
			)
		)
		
		--build positive X side first
		for i = 0 to (total) do
		(	
			--build a 2x4 stud facing correct direction for rafter
			S = GetStud()
			rotate S (eulerangles 0 270 0)
			rotate S (eulerangles 90 0 0)
			rotate S (eulerangles 0 180 0)
			
			--position rafter 16" on center
			S.pos = posB
			S.pos.x = 0
			S.pos.z = wallHeight + foundationThickness + roofZoffset + roofHeight
			S.pos.y += (i * rafterSpacing)
			
			--position last rafter at end of roof
			if(i == total) do ( S.pos.y = posD.y )
			--print i as string
			
			--rotate into rafter position
			run = posB.x + posA.x 
			rise = posA.z - wallHeight - foundationThickness - roofZoffset
			
			--divide rise by run, plug into arctan calc to get degree
			val = atan (rise / run) 
			rotate S (eulerangles 0 val 0)
			
			--calculate roof overhang
			S.height = distance posA posB
			S.height += roofOverhang_length
			
			--limit rafter height to stud height
			if(S.height > stud_height) then (S.height = stud_height)
			
			local layer = LayerManager.getLayerFromName "Roof"
			layer.addnode S
		)
		
		--build negative X side next
		for i = 0 to (total) do
		(	
			--build a 2x4 stud facing correct direction for rafter
			S = GetStud()
			rotate S (eulerangles 0 270 0)
			rotate S (eulerangles 90 0 0)
			rotate S (eulerangles 0 180 0)
			
			--position rafter 16" on center
			S.pos = posB
			S.pos.x = 0
			S.pos.z = wallHeight + foundationThickness + roofZoffset + roofHeight
			S.pos.y += (i * rafterSpacing)
			
			--position last rafter at end of roof
			if(i == total) do ( S.pos.y = posD.y )
			--print i as string
			
			--rotate into rafter position
			run = posB.x + posA.x 
			rise = posA.z - wallHeight - foundationThickness - roofZoffset
			
			--divide rise by run, plug into arctan calc to get degree
			val = atan (rise / run) 
			val *= -1
			val += 180
			rotate S (eulerangles 0 val 0)
			
			--calculate roof overhang
			S.height = distance posA posB
			S.height += roofOverhang_length
			
			--limit rafter height to stud height
			if(S.height > stud_height) then (S.height = stud_height)
			
			local layer = LayerManager.getLayerFromName "Roof"
			layer.addnode S
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
			S.pos.z -= 1 --sink into top plate this amount
			S.pos.X *= -1
			rotate S (eulerangles 0 180 0)
			S.pos.y += (i * rafterSpacing)
			S.pos.y += stud_width
			
			--position last rafter at end of roof
			if(i == total) then ( S.pos.y = (posD.y - stud_width) )
			
			local layer = LayerManager.getLayerFromName "Roof"
			layer.addnode S
			
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
					local layer = LayerManager.getLayerFromName "Roof"
					layer.addnode C
					
					if(g == runTotal) then
					( 	--trim and limit height of stud 
						C.height = run - stud_height * runTotal 
						if(C.height > stud_height) then (C.height = stud_height)
					)
				)
			)
		)
		
		
		
		
		
		
		
		
		
		
		
		
		--scoot roof into position above rafters
		Roof.pos.z += 1.3
		
		--expand roof to length overhang value
		pos=polyop.getvert $ 1
		polyop.setvert $ 1 [pos.x,pos.y-roofOverhang_length,pos.z]
		
		pos=polyop.getvert $ 2
		polyop.setvert $ 2 [pos.x,pos.y-roofOverhang_length,pos.z]
		
		pos=polyop.getvert $ 3
		polyop.setvert $ 3 [pos.x,pos.y+roofOverhang_length,pos.z]
		
		pos=polyop.getvert $ 4
		polyop.setvert $ 4 [pos.x,pos.y+roofOverhang_length,pos.z]
		
		--shell roof with some depth
		sh = shell()
		sh.inneramount = 0.5
		addModifier Roof sh
		
		
		
		
		
		
		
		
		-- //////////////////// Build Walls //////////////////// --
		
		(
			buildDoor = false
			local A = BuildWall roofLength "Wall_A"
			rotate A (eulerangles 0 0 90)
			A.pos.x = roofWidth * 0.5
			A.pos.x -= stud_length * 0.5
			ungroup A
			
			buildDoor = false
			local B = BuildWall roofLength "Wall_B"
			rotate B (eulerangles 0 0 90)
			B.pos.x = roofWidth * -0.5
			B.pos.x += stud_length * 0.5
			ungroup B
			
			buildDoor = true
			local C = BuildWall (roofWidth - (stud_length * 2) - 1.5) "Wall_C"
			C.pos = [0,0,C.pos.z]
			C.pos.y = (roofLength * 0.5) - (stud_length * 0.5) + 0.75
			ungroup C
			
			buildDoor = false
			local D = BuildWall (roofWidth - (stud_length * 2) - 1.5) "Wall_D"
			D.pos = [0,0,D.pos.z]
			D.pos.y = (roofLength * -0.5) - (stud_length * 0.5) + 2.75
			ungroup D
		)
		
		delete roof
		clearSelection()
	)
	
	
	
	
	
	
	
	
	
	
	
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
	buildingOptionYoffset = 70
	buildBtnOffset_Y = (rolloutHeight - 216) --anchors ui items to bottom of rollout
	
	rollout builderDialog scriptTitle
	(
		label label_stud_0 padStr pos:[6,12+studOptionsYoffset]
		--label label_stud_1 padStr pos:[6,60+studOptionsYoffset]
		label ChooseText0 "2x4 Stud Options" pos:[6,5+studOptionsYoffset]
		spinner rl_stud_width "(in) Width   :" range:[0.5,2.5,stud_width] type:#float fieldWidth:40 pos:[6,30+studOptionsYoffset]
		spinner rl_stud_length "(in) Length :" range:[2.5,4.5,stud_length] type:#float fieldWidth:41 pos:[6,50+studOptionsYoffset]
		spinner rl_stud_height "(in) Height  :" range:[stud_height,stud_height,stud_height] type:#integer fieldWidth:50 pos:[130,30+studOptionsYoffset]
		spinner rl_stud_price "Board Cost  : $" range:[0.01,100.00,stud_price] type:#float fieldWidth:38 pos:[130,50+studOptionsYoffset]
		
		label label_house_0 padStr pos:[6,12+buildingOptionYoffset]
		label ChooseText1 "Building Options" pos:[6,5+buildingOptionYoffset]
		spinner rl_house_width "(in) Width   :" range:[90,180,180] type:#integer fieldWidth:40 pos:[6,30+buildingOptionYoffset]
		spinner rl_house_length "(in) Length :" range:[90,400,180] type:#integer fieldWidth:41 pos:[6,50+buildingOptionYoffset]
		spinner rl_wall_height "(in) Wall Height  :" range:[12 * 9,12 * 9,12 * 9] type:#integer fieldWidth:27 pos:[130,30+buildingOptionYoffset]
		spinner rl_roof_height "(in) Roof Height  :" range:[12 * 1,48,12 * 3] type:#integer fieldWidth:24 pos:[130,50+buildingOptionYoffset]
		
		
		label label_roof_0 "------ Roof Options ------" pos:[130,95+buildingOptionYoffset]
		spinner rl_roofOverhang_length "(in) Overhang:" range:[1,48,12] type:#integer fieldWidth:38 pos:[130,115+buildingOptionYoffset]
		spinner rl_rafterSpacing_length "(in) Spacing:   " range:[16,24,24] type:#integer fieldWidth:38 pos:[130,135+buildingOptionYoffset]
		
		label label_concrete_0 "--- Concrete Options ---" pos:[6,95+buildingOptionYoffset]
		spinner rl_concreteCost "Per ft:     $" range:[0.01,1000,3] type:#float fieldWidth:46 pos:[6,115+buildingOptionYoffset]
		spinner rl_concreteThicness "(in) Depth :" range:[1,12,5] type:#integer fieldWidth:45 pos:[6,135+buildingOptionYoffset]
		
		
		
		--
		
		label label_build_1 padStr pos:[6,0 + buildBtnOffset_Y]
		button randBtn "Randomize" pos:[6,0 + buildBtnOffset_Y - 14] width:(rolloutWidth-10-(rolloutWidth * 0.5)) height:21
		button resetBtn "Reset" pos:[6 - 3 + (rolloutWidth * 0.5),0 + buildBtnOffset_Y - 14] width:(rolloutWidth-10-(rolloutWidth * 0.5)) height:21
			
		button runBTN ">  Build Shed  <" pos:[5,18 + buildBtnOffset_Y] width:(rolloutWidth-11) height:40
		label label_build_2 padStr pos:[6,197 + buildBtnOffset_Y]
		edittext feedbackBox text:feedbackString fieldWidth:(rolloutWidth-13) height:140 pos:[2,63 + buildBtnOffset_Y] readOnly:true
		
		fn Run =
		(
			--clear scene for new build test
			delete objects
			
			stud_array = #()
			door_array = #()
			
			delete_empty_layers()
			
			tStart = timestamp()
			BuildShed()
			tEnd = timestamp ()
			feedbackBox.text = ("Creation time: " + ((tEnd-tStart)/1000.0) as string + " seconds.")
			
			--add report here
			local studCost = (stud_price * stud_array.count)
			local concreteCost = (rl_house_width.value/12) * (rl_house_length.value/12) * rl_concreteCost.value
			local doorCost = (door_price * door_array.count)
			local grandTotal = (studCost + concreteCost + doorCost)
			
			feedbackBox.text += ("\n---------------------- Cost Report ---------------------")
			feedbackBox.text += ("\n$" + studCost as string + " for " + stud_array.count as string + " 2x4s")
			feedbackBox.text += ("\n$" + concreteCost as string + " for concrete foundation")
			feedbackBox.text += ("\n$" + doorCost as string + " for doors")
			--
			
			feedbackBox.text += ("\n")
			feedbackBox.text += ("\nTotal $" + (grandTotal as string))
			completeRedraw()
			--max tool zoomextents all
			clearSelection()
		)
		
		on runBTN pressed do Run()
		
		on randBtn pressed do 
		(
			rl_house_width.value = random (90) (12*15)
			rl_house_length.value = random (90) (12*30)
			rl_roof_height.value = random 12 48
			rl_rafterSpacing_length.value = random 16 24
			rl_roofOverhang_length.value = random 6 48
			Run()
		)
		
		on resetBtn pressed do 
		(
			rl_house_width.value = 180
			rl_house_length.value = 180
			rl_roof_height.value = 36
			rl_rafterSpacing_length.value = 24
			rl_roofOverhang_length.value = 12
			Run()
		)
	)
	createDialog builderDialog rolloutWidth rolloutHeight 1270 600 lockWidth:true lockHeight:true style:#(#style_toolwindow, #style_sysmenu)
	
	builderDialog.rl_stud_width.enabled = false
	builderDialog.rl_stud_length.enabled = false
	builderDialog.rl_stud_height.enabled = false
	builderDialog.rl_wall_height.enabled = false
)