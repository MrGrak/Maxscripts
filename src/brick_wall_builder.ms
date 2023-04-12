(
	local scriptTitle = " HouseGenerator - v0.0.1"
	clearListener();
	global builderDialog
	try destroyDialog builderDialog catch()

	
	
	
	
	
	
	
	/*
	
	todo:
	
	
	get wall algorithm working 
	
	show estimated material cost of concrete foundation in report
	
	add depth spinner for foundation (add this variable into code too)
	
	build pier and beam foundation algorithm
	
	
	
	button to create room, bathroom, kitchen rectangle splines
	
	run collects all splines and collapses copies of them to a single spline
	only the perimeter spline is kept 
	from that we build walls (from wood, according to texas construction standards)
	
	add cost rollout so we can accurately price all materials
	
	fix rollout input so that we actually build feet
	
	add depth for foundation (depth of concrete, or height of pier and beam
	
	create land that is +5 feet beyond the size of the house, so we have a ground reference
	
	add a front door

	*/
	
	
	
	struct _Main 
	(
		--create a vec3 position to place house
		position = [0, 0, 0],
		house_height = 5,
		house_width = 10,
		house_length = 10,
		
		--all bricks are stored in brick array, with following properties
		brick_array = #(),
		brick_length = 3.625,
		brick_width = 8,
		brick_height = 2.25,
		brick_price = 0.90,
		
		--size of land
		land_width = 1,
		land_height = 1,
		
		
		
		
		--predeclare all methods 
		fn Run = (),
		fn BuildHouse = (),
		fn BuildWall = (),
		fn GetBrick = (),
		fn GetBuildCost = (),
		fn SortToLayers = (),
		
		
		
		fn Run = 
		(
			--delete all geometry
			delete objects
			gc()
			
			--clear selection
			clearSelection()
			clearListener()
			print "House Builder v0.00";
			
			--set units to us american inches
			units.DisplayType = #US
			units.SystemType = #inches
			
			--get values from rollout
			house_width = builderDialog.gen_house_width.value
			house_length = builderDialog.gen_house_length.value
			house_height = builderDialog.gen_house_height.value
			
			--build a house with brick walls
			BuildHouse position.x position.y position.z house_width house_length house_height
			
			--get a cost estimate of build
			GetBuildCost()
			
			--organize scene a bit
			SortToLayers()
		),
		
		fn BuildHouse xPos yPos zPos hWidth hLength hHeight =
		(
			--create land
			Land = Box lengthsegs:10 widthsegs:10 heightsegs:10 length:((hLength * 12) * 2) width:((hWidth * 12) * 2) height:1 pos:[0,0,0] 
			Land.wirecolor = [20, 100, 20]
			Land.pivot = Land.center
			Land.name = "Land"
			redrawViews()
			
			--create a concrete foundation
			Foundation = Box lengthsegs:8 widthsegs:8 heightsegs:8 length:(hLength * 12) width:(hWidth * 12) height:1 pos:[0,0,1] 
			Foundation.wirecolor = [70, 70, 70]
			Foundation.pivot = Foundation.center
			Foundation.name = "Foundation"
			redrawViews()
			
			
			
			--build walls
			BuildWall (xPos -= ((hWidth * brick_length) * 1.5)) (yPos + ((hWidth * brick_length) * 1.5)) (zPos + 3) hWidth hHeight 0 0
			redrawViews()
			
			/*
			BuildWall (xPos + (-brick_width * 0.27)) (yPos + (-brick_length * 0.6)) (zPos) hLength hHeight 1 0
			redrawViews()
			
			BuildWall (xPos + (-brick_width * 0.27)) (yPos + (-brick_length * 0.6) + ((hWidth + 1.03) * (brick_width + 0.1))) (zPos) hLength hHeight 1 1
			redrawViews()
			
			BuildWall xPos (yPos + ((hLength + 1.03) * (brick_width + 0.1))) (zPos) hWidth hHeight 0 1
			redrawViews()
				*/
		),
		
		fn BuildWall xPos yPos zPos width height direction stacking = 
		(
			for j = 0 to height do
			(
				for i = 0 to width do
				(
					local B = GetBrick()
					B.pos.x = xPos
					B.pos.y = yPos
					B.pos.z = zPos
					
					--use values 0 -3+ as an enum
					if (direction == 0) then
					(
						B.pos.x += i * (B.width + 0.1)
						B.pos.z += j * (B.height + 0.1)
						--apply brick stacking
						if stacking == 0 then
						( if (mod j 2) != 0 then (B.pos.x += (B.width * 0.5)) )
						else
						( if (mod j 2) == 0 then (B.pos.x += (B.width * 0.5)) )
					)
					--this is 90 perpendicular
					else if (direction == 1) then
					(
						B.rotation = eulerAngles 0 0 90
						
						B.pos.y += i * (B.width + 0.1)
						B.pos.z += j * (B.height + 0.1)
						--apply brick stacking
						if stacking == 0 then
						( if (mod j 2) == 0 then (B.pos.y += (B.width * 0.5)) )
						else
						( if (mod j 2) != 0 then (B.pos.y += (B.width * 0.5)) )
					)
				)
			)
		),
		
		fn GetBrick =
		(
			Brick = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:brick_length width:brick_width height:brick_height pos:[0,0,0] 
			Brick.wirecolor = [random 20 100, 0, 0]
			Brick.pivot = Brick.center
			append brick_array Brick --track how many bricks are created
			Brick.name = "Brick_" + (brick_array.count as string)
			return Brick
		),
		
		fn GetBuildCost =
		(
			--set brick price based on how many are being used
			if(brick_array.count < 500) then (brick_price = 0.60)
			else if(brick_array.count < 1000) then (brick_price = 0.35)
			else if(brick_array.count < 2000) then (brick_price = 0.25)
			else (brick_price = 0.15)
			
			--display formatted report
			report = ("------------------------- Builder Report -------------------------")
			
			report += ("\nW/L/H : " + (house_width * (brick_width + 0.1)) as string + "'', " + (house_length * (brick_width + 0.1)) as string + "'', " + (house_height * (brick_height + 0.1)) as string + "''")
			report += ("\nBricks : " + (brick_array.count) as string)
			report += (" Cost : $" + (brick_array.count * brick_price) as string + ", $" + (brick_price as string) + " per brick")
			
			--display cost in rollout		
			builderDialog.feedbackBox.text = report
		),

		fn SortToLayers =
		(
			--sort bricks to brick layer
			local layer = LayerManager.getLayerFromName "Bricks"
			if (layer == undefined) then
			( layer = LayerManager.newLayerFromName "Bricks"; )
			try (for eachObj in brick_array do (layer.addnode eachObj;));
			catch()
			
			
		)
	)

	Program = _Main()
	feedbackString = "HouseGenerator creates and prices simple houses." --this variable holds a string of feedback
	local runBtnText = ">  Create House  <";
	
	
	uiOffset_Y = 100
	
	rollout builderDialog scriptTitle
	(
		--UI
		label label0 "________________________________________________" pos:[6,12]
		label ChooseText "Choose House Options" pos:[6,5]
		
		spinner gen_house_width "(ft) Width:" range:[0,100,10] type:#integer fieldWidth:30 pos:[6,31]
		spinner gen_house_length "Length:" range:[0,100,10] type:#integer fieldWidth:30 pos:[115,31]
		spinner gen_house_height "Height:" range:[0,100,10] type:#integer fieldWidth:30 pos:[215,31]
		
		dropdownlist gen_house_foundation "Foundation Type" items:#("Concrete","Pier Beam") width:90 pos:[6,51]
		
		/*
		checkbox StockCheck "Brick Walls" pos:[6,31] checked:true
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
			tStart = timestamp()
			
			Program.Run();
			
			tEnd = timestamp ()
			feedbackBox.text += ("\nCreation time: " + ((tEnd-tStart)/1000.0) as string + "seconds.")
			
			completeRedraw()
			max tool zoomextents all
		)
		
		on runBTN pressed do (Run(););
	)
	createDialog builderDialog 300 451 4 88 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
)