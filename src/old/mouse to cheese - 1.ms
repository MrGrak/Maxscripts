--mouse finds cheese
struct MouseAndCheese (
	attemptsToFind = 0,
	pursuitCounter = 0,
	slopeOfY = undefined,
	slopeOfX = undefined,
	
	--predeclared functions of MouseAndCheese
	fn initSIM = (),
	fn runSIM = (),
	fn moveToCheese = (),
	fn shootRays = (),
	
	
	
	--fn definitions
	fn moveToCheese cheeseLocation = (
		--move the mouse to the cheese location
		
		if intersects $Mouse $Cheese then
		(
			Point pos:$Mouse.pos isSelected:off wirecolor:[0,255,0] box:true size:6 --drop a breadcrumb
			print "mouse catches cheese successfully."
		) else 
		(
			Point pos:$Mouse.pos isSelected:off wirecolor:[255,0,0] box:true size:6 --drop a breadcrumb
			--print cheeseLocation.pos
			--print cheeseLocation.dir
			if pursuitCounter < 30 then --in pursuit, '30' determines how much 'determination' our mouse has
			(
				
				if pursuitCounter == 0 then
				(
					slopeOfY = (cheeseLocation.pos.y - $Mouse.pos.y)/10
					slopeOfX = (cheeseLocation.pos.x - $Mouse.pos.x)/10
				)
				pursuitCounter = pursuitCounter + 1 --increase the catch attempts
				
				$Mouse.pos.x = $Mouse.pos.x + slopeOfX
				$Mouse.pos.y = $Mouse.pos.y + slopeOfY
				
				--call the function again
				moveToCheese cheeseLocation
			) else --problem, win the game
			(
				print "error, game over.."
				$Mouse.pos = cheeseLocation.pos
			)
		) --intersect over
	),
	
		
	fn shootRays = (

		--set random values for directions to cast ray
		local rayXcontroller1 = (random 0.0 1.0) --0.478232 ex.
		local rayYcontroller1 = 1 - rayXcontroller1 --get whats left of 1, assign

		--shoot rays
		local checkRaypost1 = ray $.pos [rayXcontroller1,rayYcontroller1,0]
		local checkRaypost2 = ray $.pos [rayXcontroller1,-rayYcontroller1,0]
		local checkRaypost3 = ray $.pos [-rayXcontroller1,rayYcontroller1,0]
		local checkRaypost4 = ray $.pos [-rayXcontroller1,-rayYcontroller1,0]

		--check to see if rays hits
		local checkRayhitA = intersectRay $Cheese checkRaypost1
		local checkRayhitB = intersectRay $Cheese checkRaypost2
		local checkRayhitC = intersectRay $Cheese checkRaypost3
		local checkRayhitD = intersectRay $Cheese checkRaypost4

		--if one hits, set it to rayHit1
		local checkRayhit1 = undefined
		if checkRayhitA != undefined then (checkRayhit1 = checkRayhitA)
		if checkRayhitB != undefined then (checkRayhit1 = checkRayhitB)
		if checkRayhitC != undefined then (checkRayhit1 = checkRayhitC)
		if checkRayhitD != undefined then (checkRayhit1 = checkRayhitD)

		--if a ray didn't hit,
		if checkRayhit1 == undefined then
		(
			--print "did not hit black"
			--increment ray degree
			attemptsToFind = attemptsToFind+1
			if attemptsToFind < 400 then
			(
				runSIM()
			) else (messagebox "400 tries and no solutions")
		) else if checkRayhit1 != undefined then --if a ray hit, then
		(
			print "cheese found! search attempts:"
			print attemptsToFind
			--build a spline from the obj to the hit
			local theFirstNodePOS = $Mouse.pos
			local theSplineShape = SplineShape pos:theFirstNodePOS
			addNewSpline theSplineShape
			addKnot theSplineShape 1 #corner #line $Mouse.pos
			addKnot theSplineShape 1 #corner #line checkRayhit1.pos
			--set properties of spline just built
			theSplineShape.render_displayRenderMesh = true
			theSplineShape.render_viewport_rectangular = false
			theSplineShape.render_thickness = 0.4
			theSplineShape.render_sides = 6
			theSplineShape.wirecolor = [255,0,0]
			clearSelection()
			--MUST CALL UPDATESHAPE to prevent max from crashing
			updateShape theSplineShape
			
			--move to cheese and
			moveToCheese checkRayhit1
		)
	), --end fn getRay
	
	fn runSIM = (
		--drop history breadcrumb
		Point pos:$Mouse.pos isSelected:off wirecolor:[135,59,8] box:true size:6
		select $Mouse
		--move mouse
		local randomNum3 = (random 1.0 10)
		local randomNum4 = (random 1.0 10)
		--both neg and positive
		local negAndPosVar2 = (random 1 2)
		if negAndPosVar2 == 2 then
		(
			randomNum3 = randomNum3 * -1
			randomNum4 = randomNum4 * -1
		)
		$.pos = $.pos + [randomNum3,randomNum4,0]
		shootRays()
	),

	fn initSIM = (
		--randomize cheese pos
		local randomCheeseNum1 = (random 1.0 100)
		local randomCheeseNum2 = (random 1.0 100)
		--both neg and positive
		local negAndPosVar3 = (random 1 2)
		if negAndPosVar3 == 2 then
		(
			randomCheeseNum1 = randomCheeseNum1 * -1
			randomCheeseNum2 = randomCheeseNum2 * -1
		)
		Sphere radius:5 smooth:on segs:30 chop:0 slice:off \
		sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
		pos:[randomCheeseNum1,randomCheeseNum2,0] isSelected:on
		$.wirecolor = (color 225 198 87)
		$.name = "Cheese"
		clearSelection()
		--build sphere 2
		Sphere radius:10 smooth:on segs:30 chop:0 slice:off \
		sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
		pos:[0,0,0] isSelected:on
		$.wirecolor = (color 135 59 8)
		$.name = "Mouse"
		clearSelection()
		--get white
		runSIM()
		clearSelection()
	)
) --end struct

--explicit instructions
resetMaxFile #noPrompt
MouseAndCheeseStruct = MouseAndCheese()
MouseAndCheeseStruct.initSIM()
