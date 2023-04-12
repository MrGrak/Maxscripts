
/*

*/
select $Shape*
if $ != undefined then (
	delete $
)
numOfRays = 20
theOriginPOS = $MyOrigin
$MyOrigin.pos = [(random 0 100),(random 0 100),0]
--need a wallOBJ not at center

--360/numOfRays

inc = -(numOfRays * 0.01)
trackingPrey = undefined

for i = 1 to numOfRays do (
	--randomize negative and positive on the ray direction
	local randomNum = (random 1 4)
	print randomNum
	rayXcontroller1 = (random 0.0 1.0) --0.478232 ex.
	rayYcontroller1 = 1 - rayXcontroller1 --get whats left of 1, assign
	if randomNum == 1 then(
		rayYcontroller1 = abs(rayYcontroller1)
		rayXcontroller1 = rayXcontroller1*-1
	) 
	if randomNum == 2 then(
		rayXcontroller1 = abs(rayXcontroller1)
		rayYcontroller1 = rayYcontroller1*-1
	)
	if randomNum == 3 then(
		rayYcontroller1 = abs(rayYcontroller1)
		rayXcontroller1 = abs(rayXcontroller1)
	) 
	if randomNum == 4 then(
		rayXcontroller1 = rayXcontroller1*-1
		rayYcontroller1 = rayYcontroller1*-1
	)
	local checkRaypost1 = ray theOriginPOS.pos [rayXcontroller1,rayYcontroller1,0]
	local checkRayhitA = intersectRay $WallOBJ checkRaypost1
	local checkRayhit1 = undefined
	if checkRayhitA != undefined then (checkRayhit1 = checkRayhitA)
	if checkRayhitB != undefined then (checkRayhit1 = checkRayhitB)
	if checkRayhit1 != undefined then --if a ray hit, then
		(
			--build a spline
			local theFirstNodePOS = theOriginPOS.pos
			local theSplineShape = SplineShape pos:theFirstNodePOS
			addNewSpline theSplineShape
			addKnot theSplineShape 1 #corner #line theOriginPOS.pos
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
		)

	inc = inc + (numOfRays * 0.01)
	
	
	/*
	local ray = intersectRay thePredator.pos (lastKnownPOSprey.dir + rayINC) thePrey
	
	if ray != undefined then trackingPrey = ray
	*/
	
) --end for
/*
if trackingPrey != undefined then (
	print trackingPrey
)
*/