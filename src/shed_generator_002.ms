--Shed Generator

/*

ridge beam needs to be longer, basedon width of 2x4

we need the rafters to hang over the edges and have seat cuts in them
they also need to be cut to align with the ridge beam

create walls of shed - we're missing two

each wall should have options: door (0-2), windows (0-4)
ensure that wall has enough distance to support X windows

add extras array - when we cut a 2x4, the extra we cut off becomes another
stud (not in stud array). we can then loop this array and search for lumber
that we can reuse (or not, make it a toggle). if we can reuse an extra piece
of lumber, then it gets removed from the extras array.

sort all geometry to layers - a lumber layer, nails layer, foundation, roof, etc
we should be able to toggle views on/off

add particle board exterior covering, estimate costs

add insulation meshes and cost estimates, with drop down types (based on volume)

add roof overhang, we will need to project verts along their local
axis to get the overhang we want

*/

(
	
	local scriptTitle = "ShedGen v002"
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
	
	fn BuildWall wLength =
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
			if(i == wLength)then(build = true)
			
			if(build) then
			(
				local S = GetStud()
				S.pos.x = i
				S.pos.y = 0
				S.pos.z = foundationThickness + (stud_width)
				studIndex += 1
				append compArray S
			)
		)
		
		
		
		g = group compArray
		select g
		return g;
	)
	
	
	
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
		
		-- //////////////////// Build Foundation //////////////////// --
		Foundation = Box lengthsegs:5 widthsegs:5 heightsegs:1 length:roofLength width:roofWidth height:foundationThickness pos:[0,0,0]
		Foundation.wirecolor = [100, 100, 100]
		Foundation.name = "Foundation_Concrete"
		
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
		total = (roofLength / 16) + 1
		total = floor(total)
		--print total as string
		
		--build ridge beam center of roof
		(
			S = GetStud()
			rotate S (eulerangles 90 0 0)
			S.pos = [0,0,0]
			S.pos.z = wallHeight + foundationThickness + roofZoffset + roofHeight
			S.pos.y += roofLength * 0.5
			
			--determine how many beams we need to span run
			run = distance posA posC
			
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
			
			--position rafter 16" on center
			S.pos = posB
			S.pos.y += (i * 16)
			
			--position last rafter at end of roof
			if(i == total) do ( S.pos.y = posD.y )
			--print i as string
			
			--rotate into rafter position
			run = posB.x + posA.x 
			rise = posA.z - wallHeight - foundationThickness - roofZoffset
			
			--divide rise by run, plug into arctan calc to get degree
			val = atan (rise / run) 
			rotate S (eulerangles 0 val 0)
			
			--trim stud to length, distance between bottom & top verts
			S.height = distance posA posB
			S.height += 1 --add extra to height
			S.pos.z -=1 --move down
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
			run = posB.x + posA.x 
			rise = posA.z - wallHeight - foundationThickness - roofZoffset
			
			--divide rise by run, plug into arctan calc to get degree
			val = atan (rise / run) 
			val *= -1
			rotate S (eulerangles 0 val 0)
			
			--trim stud to length, distance between bottom & top verts
			S.height = distance posA posB
			S.height += 1 --add extra to height
			S.pos.z -=1 --move down
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
			S.pos.z -= 1 --sink into top plate this amount
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
		
		
		
		--build roof support beams
		
		--ridge board or ridge beam?
		
		--ceiling joists can be 16" to 24" inches spaced, provide options in gui
		
		
		
		
		
		
		
		
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
			local A = BuildWall roofLength
			rotate A (eulerangles 0 0 90)
			A.pos.x = roofWidth * 0.5
			A.pos.x -= stud_length * 0.5
			ungroup A
			
			local B = BuildWall roofLength
			rotate B (eulerangles 0 0 90)
			B.pos.x = roofWidth * -0.5
			B.pos.x += stud_length * 0.5
			ungroup B
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
		--label label_house_1 padStr pos:[6,80+buildingOptionYoffset]
		--label label_house_2 "Note: rafters cannot exceed stud height" pos:[6,72+buildingOptionYoffset]
		label ChooseText1 "Building Options" pos:[6,5+buildingOptionYoffset]
		spinner rl_house_width "(in) Width   :" range:[12 * 5,12 * 15,12 * 10] type:#integer fieldWidth:40 pos:[6,30+buildingOptionYoffset]
		spinner rl_house_length "(in) Length :" range:[12 * 5,12 * 30,12 * 10] type:#integer fieldWidth:41 pos:[6,50+buildingOptionYoffset]
		spinner rl_wall_height "(in) Wall Height  :" range:[12 * 9,12 * 9,12 * 9] type:#integer fieldWidth:27 pos:[130,30+buildingOptionYoffset]
		spinner rl_roof_height "(in) Roof Height  :" range:[12 * 1,48,12 * 3] type:#integer fieldWidth:24 pos:[130,50+buildingOptionYoffset]
		
		
		label label_roof_0 "------ Roof Options ------" pos:[130,95+buildingOptionYoffset]
		spinner rl_roofOverhang_length "(in) Overhang:" range:[1,12,6] type:#integer fieldWidth:38 pos:[130,115+buildingOptionYoffset]
		
		label label_concrete_0 "--- Concrete Options ---" pos:[6,95+buildingOptionYoffset]
		spinner rl_concreteCost "Per sq ft: $" range:[0.01,1000,3] type:#float fieldWidth:46 pos:[6,115+buildingOptionYoffset]
		spinner rl_concreteThicness "(in) Depth :" range:[1,12,5] type:#integer fieldWidth:45 pos:[6,135+buildingOptionYoffset]
		
		button randBtn "Randomize" pos:[6,170+buildingOptionYoffset] width:247 height:20
		
		--
		
		label label_build_1 padStr pos:[6,0 + buildBtnOffset_Y]
		button runBTN ">  Build Shed  <" pos:[5,18 + buildBtnOffset_Y] width:(rolloutWidth-11) height:40
		label label_build_2 padStr pos:[6,197 + buildBtnOffset_Y]
		edittext feedbackBox text:feedbackString fieldWidth:(rolloutWidth-13) height:140 pos:[2,63 + buildBtnOffset_Y] readOnly:true
		
		fn Run =
		(
			--clear scene for new build test
			delete objects
			stud_array = #()
			door_array = #()
			
			tStart = timestamp()
			BuildShed()
			tEnd = timestamp ()
			feedbackBox.text = ("Creation time: " + ((tEnd-tStart)/1000.0) as string + " seconds.")
			
			--add report here
			local studCost = (stud_array.count * stud_price)
			local concreteCost = (rl_house_width.value/12) * (rl_house_length.value/12) * rl_concreteCost.value
			feedbackBox.text += ("\n---------------------- Cost Report ---------------------")
			feedbackBox.text += ("\n$" + studCost as string + " for " + stud_array.count as string + " 2x4s")
			feedbackBox.text += ("\n$" + concreteCost as string + " for concrete foundation")
			
			feedbackBox.text += ("\n")
			feedbackBox.text += ("\nTotal $" + ((studCost + concreteCost) as string))
			completeRedraw()
			max tool zoomextents all
			clearSelection()
		)
		
		on runBTN pressed do Run()
		
		on randBtn pressed do 
		(
			rl_house_width.value = random (12*5) (12*15)
			rl_house_length.value = random (12*5) (12*30)
			rl_roof_height.value = random 12 48
			Run()
		)
		
	)
	createDialog builderDialog rolloutWidth rolloutHeight 1450 600 lockWidth:true lockHeight:true style:#(#style_toolwindow, #style_sysmenu)
	
	builderDialog.rl_stud_width.enabled = false
	builderDialog.rl_stud_length.enabled = false
	builderDialog.rl_stud_height.enabled = false
	builderDialog.rl_wall_height.enabled = false
)