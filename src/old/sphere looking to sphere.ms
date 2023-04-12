--can one sphere see another sphere based on color?
struct canYouSee (
	attemptsToFind = 1,
	foundNum = 0,
	fn getRay theSelection = (
	
		--randomize black
		Point pos:$BlackS.pos isSelected:off wirecolor:[0,0,255] box:true size:6
		select $BlackS
		local randomNum1 = (random 1.0 10)
		local randomNum2 = (random 1.0 10)
		--both neg and positive
		local negAndPosVar = (random 1 2)
		if negAndPosVar == 2 then
		(
			randomNum1 = randomNum1 * -1
			randomNum2 = randomNum2 * -1
		)
		$.pos = $.pos + [randomNum1,randomNum2,0]
		clearSelection()
		--randomize white
		Point pos:$WhiteS.pos isSelected:off wirecolor:[255,255,255] box:true size:6
		select $WhiteS
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
		
		

		--set random values for directions to cast ray
		local rayXcontroller1 = (random 0.0 1.0) --0.478232 ex.
		local rayYcontroller1 = 1 - rayXcontroller1 --get whats left of 1, assign
		local rayXcontroller2 = (random 0.0 1.0) --0.478232 ex.
		local rayYcontroller2 = 1 - rayXcontroller2
		--shoot rays
		local checkRaypost1 = ray $.pos [rayXcontroller1,rayYcontroller1,0]
		local checkRaypost2 = ray $.pos [rayXcontroller1,-rayYcontroller1,0]
		local checkRaypost3 = ray $.pos [-rayXcontroller1,rayYcontroller1,0]
		local checkRaypost4 = ray $.pos [-rayXcontroller1,-rayYcontroller1,0]
		local checkRaypost5 = ray $.pos [rayXcontroller2,rayYcontroller2,0]
		local checkRaypost6 = ray $.pos [rayXcontroller2,-rayYcontroller2,0]
		local checkRaypost7 = ray $.pos [-rayXcontroller2,rayYcontroller2,0]
		local checkRaypost8 = ray $.pos [-rayXcontroller2,-rayYcontroller2,0]
		--check to see if rays hits
		local checkRayhitA = intersectRay $BlackS checkRaypost1
		local checkRayhitB = intersectRay $BlackS checkRaypost2
		local checkRayhitC = intersectRay $BlackS checkRaypost3
		local checkRayhitD = intersectRay $BlackS checkRaypost4
		local checkRayhitE = intersectRay $BlackS checkRaypost5
		local checkRayhitF = intersectRay $BlackS checkRaypost6
		local checkRayhitG = intersectRay $BlackS checkRaypost7
		local checkRayhitH = intersectRay $BlackS checkRaypost8
		--if one hits, set it to rayHit1
		local checkRayhit1 = undefined
		if checkRayhitA != undefined then (checkRayhit1 = checkRayhitA)
		if checkRayhitB != undefined then (checkRayhit1 = checkRayhitB)
		if checkRayhitC != undefined then (checkRayhit1 = checkRayhitC)
		if checkRayhitD != undefined then (checkRayhit1 = checkRayhitD)
		if checkRayhitE != undefined then (checkRayhit1 = checkRayhitE)
		if checkRayhitF != undefined then (checkRayhit1 = checkRayhitF)
		if checkRayhitG != undefined then (checkRayhit1 = checkRayhitG)
		if checkRayhitH != undefined then (checkRayhit1 = checkRayhitH)
		--if a ray didn't hit,
		if checkRayhit1 == undefined then
		(
			--print "did not hit black"
			--increment ray degree
			attemptsToFind = attemptsToFind+1
			if attemptsToFind < 400 then
			(
				select $WhiteS
				getRay $
			) else (messagebox "400 tries and no solutions")
		) else if checkRayhit1 != undefined then --if a ray hit, then
		(
			select $BlackS
			$.wirecolor = (color 0 0 255)
			print "found! attempts:"
			print attemptsToFind
			attemptsToFind = attemptsToFind + 1
			--build a spline from the obj to the hit
			local theFirstNodePOS = $WhiteS.pos
			local theSplineShape = SplineShape pos:theFirstNodePOS
			addNewSpline theSplineShape
			addKnot theSplineShape 1 #corner #line $WhiteS.pos
			addKnot theSplineShape 1 #corner #line checkRayhit1.pos
			--set properties of spline just built
			theSplineShape.render_displayRenderMesh = true
			theSplineShape.render_viewport_rectangular = false
			theSplineShape.render_thickness = 0.5
			theSplineShape.render_sides = 6
			theSplineShape.wirecolor = [255,0,0]
			clearSelection()
			--MUST CALL UPDATESHAPE to prevent max from crashing
			updateShape theSplineShape
			foundNum = foundNum + 1
			if foundNum < 3 then
			(
			select $WhiteS
			getRay $
			)
			
	
		)
	), --end fn getRay
	fn buildSpheres = (
		--build sphere 1
		Sphere radius:5 smooth:on segs:30 chop:0 slice:off \
		sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
		pos:[0,0,0] isSelected:on
		$.wirecolor = (color 0 0 0)
		$.name = "BlackS"
		clearSelection()
		--build sphere 2
		Sphere radius:5 smooth:on segs:30 chop:0 slice:off \
		sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
		pos:[0,0,0] isSelected:on
		$.wirecolor = (color 255 255 255)
		$.name = "WhiteS"
		clearSelection()
		--get white
		select $WhiteS
		getRay $
		clearSelection()
	)
) --end struct

--explicit instructions
resetMaxFile #noPrompt
canYouSeeStruct = canYouSee()
canYouSeeStruct.buildSpheres()
