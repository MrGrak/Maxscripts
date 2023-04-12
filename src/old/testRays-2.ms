(
select $Shape*
if $ != undefined then (delete $)
numOfRays = 20 --global
theOriginPOS = $MyOrigin --ObjLooking
$MyOrigin.pos = [(random 0 100),(random 0 100),0]
theRayArray = #()
for i = 1 to numOfRays do (
	--randomize negative and positive on the ray direction
	local randomNum = (random 1 4)
	local rayXcontroller1 = (random 0.0 1.0) --0.478232 ex.
	local rayYcontroller1 = 1 - rayXcontroller1 --get whats left of 1, assign
	local checkRaypost1 = undefined
	case of
	(
		(randomNum == 1): checkRaypost1 = ray theOriginPOS.pos [rayXcontroller1,rayYcontroller1,0]
		(randomNum == 2): checkRaypost1 = ray theOriginPOS.pos [-rayXcontroller1,rayYcontroller1,0]
		(randomNum == 3): checkRaypost1 = ray theOriginPOS.pos [rayXcontroller1,-rayYcontroller1,0]
		(randomNum == 4): checkRaypost1 = ray theOriginPOS.pos [-rayXcontroller1,-rayYcontroller1,0]
	)
	local checkRayhitA = intersectRay $WallOBJ checkRaypost1 --ObjToFind !!!
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
			append theRayArray checkRayhit1
		)
) --end for
print theRayArray
)