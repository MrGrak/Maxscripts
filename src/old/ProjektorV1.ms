--ProjektorV1
--fixes scaling and preps meshes for rigging and skinning, based in part on garps voroni fracture script 1.1
--by garrickcampsey (JAN.2011) - garrick@garrickcampsey.com

--TODO
--Code algorithm that uses 2 point rayIntersect to determine alignment of PSA[i] to meshObjpicked
	--allows projektor to align flat objects to sloped ground

( --start script
global Projektor
try destroyDialog Projektor catch()
--
local theAxisToProjekt = "Y" --determines the initial axis to project upon
local theMeshObjectPicked = undefined --the mesh object that the user has picked
local codeBlockCounter --tracks the fn, if error happens, user can send the code block #
local introFeedbackText = "Projektor says:
Select some objects, then press the 
'Project selected' button above." --init feedback text
local feedbackUpdate = undefined --string for feedback/stats update
--
fn ProjektorFN = (
try (
	codeBlockCounter = 0
	--set axis
	local chosenAxis
	case of
		(
		(theAxisToProjekt == "X"): chosenAxis = [1,0,0]
		(theAxisToProjekt == "Y"): chosenAxis = [0,1,0]
		(theAxisToProjekt == "Z"): chosenAxis = [0,0,1]
		default: print "\nwarning: chosen axis case failed.\n"
		)
	local selectionAsArray = selection as array
	local paddedSelectionArray = #(0)
	join paddedSelectionArray selectionAsArray --join geoClassInSelection into padded array
	local PSAcount = paddedSelectionArray.count
	--shoot 'theSelection' at 'theObjToStickTo' along the 'chosenAxis'
	for i = 2 to PSAcount do --skip the padded 0 array[1] value
		(
		--
		--codeBlockCounter increments for each obj in PSAarray
		codeBlockCounter += 1
		--align pivot of paddedSelectionArray[i] to bottom of it's BoundingBox
		CenterPivot paddedSelectionArray[i]
		local PSAiBBsize = paddedSelectionArray[i].max - paddedSelectionArray[i].min
		--build a helper box to the BB of the object
		PSAiBBboxHelper = Box lengthsegs:1 widthsegs:1 heightsegs:1 \
		length:PSAiBBsize[2] width:PSAiBBsize[1] height:PSAiBBsize[3] \
		mapcoords:on pos:[0,0,0] isSelected:off
		--
		
		--if negative
			--align the PSA pivot to bottom of it's boundingBox
			PSAiBBboxHelper.pos = paddedSelectionArray[i].pos
			PSAiBBboxHelper.pos.z += -(PSAiBBboxHelper.height/2)
			paddedSelectionArray[i].pivot = PSAiBBboxHelper.pivot
			delete PSAiBBboxHelper
		--if positive
			--align the PSA pivot to top of it's boundingBox
		
		--****
		--code ray search section here
		local rayToMeshPositive = ray paddedSelectionArray[i].pos chosenAxis --
		local rayToMeshNegative = ray paddedSelectionArray[i].pos -chosenAxis --
		local intersectPositive = intersectRay theMeshObjectPicked rayToMeshPositive --
		local intersectNegative = intersectRay theMeshObjectPicked rayToMeshNegative --
		local positionCHECKvar = 100 --100 value means no rays intersect, 101=negative, 110=positive, 111=both
		--
		if intersectPositive != undefined then (positionCHECKvar += 10)
		if intersectNegative != undefined then (positionCHECKvar += 1)	
		if positionCHECKvar == 100 then (print "projectSelected's rays did not intersect with mesh.")
		if positionCHECKvar == 101 then 
			(--figure out which axis to use
			case of
				(
				(theAxisToProjekt == "X"): paddedSelectionArray[i].pos.x = intersectNegative.pos.x
				(theAxisToProjekt == "Y"): paddedSelectionArray[i].pos.y = intersectNegative.pos.y
				(theAxisToProjekt == "Z"): paddedSelectionArray[i].pos.z = intersectNegative.pos.z
				default: print "no hit on negative"
				)
			)--end if
		if positionCHECKvar == 110 then 
			(--figure out which axis to use
			case of
				(
				(theAxisToProjekt == "X"): paddedSelectionArray[i].pos.x = intersectPositive.pos.x
				(theAxisToProjekt == "Y"): paddedSelectionArray[i].pos.y = intersectPositive.pos.y
				(theAxisToProjekt == "Z"): paddedSelectionArray[i].pos.z = intersectPositive.pos.z
				default: print "no hit on positive"
				)
			)--end if
		if positionCHECKvar == 111 then
			(	--get absolute values
				local negCHECK
				local posCHECK
				if theAxisToProjekt == "X" then 
				(negCHECK = (abs(abs(intersectNegative.pos.x) - abs(paddedSelectionArray[i].pos.x)))
				posCHECK = (abs(abs(intersectPositive.pos.x) - abs(paddedSelectionArray[i].pos.x))))
				if theAxisToProjekt == "Y" then 
				(negCHECK = (abs(abs(intersectNegative.pos.y) - abs(paddedSelectionArray[i].pos.y)))
				posCHECK = (abs(abs(intersectPositive.pos.y) - abs(paddedSelectionArray[i].pos.y))))
				if theAxisToProjekt == "Z" then 
				(negCHECK = (abs(abs(intersectNegative.pos.z) - abs(paddedSelectionArray[i].pos.z)))
				posCHECK = (abs(abs(intersectPositive.pos.z) - abs(paddedSelectionArray[i].pos.z))))
				--
				if posCHECK < negCHECK then
				(--figure out which axis to use
					case of
						(
						(theAxisToProjekt == "X"): paddedSelectionArray[i].pos.x = intersectPositive.pos.x
						(theAxisToProjekt == "Y"): paddedSelectionArray[i].pos.y = intersectPositive.pos.y
						(theAxisToProjekt == "Z"): paddedSelectionArray[i].pos.z = intersectPositive.pos.z
						default: print "projectSelected errored out... pos"
						)
				) else if posCHECK > negCHECK then
				(--figure out which axis to use
					case of
						(
						(theAxisToProjekt == "X"): paddedSelectionArray[i].pos.x = intersectNegative.pos.x
						(theAxisToProjekt == "Y"): paddedSelectionArray[i].pos.y = intersectNegative.pos.y
						(theAxisToProjekt == "Z"): paddedSelectionArray[i].pos.z = intersectNegative.pos.z
						default: print "projectSelected errored out... neg"
						)
				)--end else
			)--end if
		) --end for loop
		--
	--
	--format string value for feedback
	feedbackUpdate = "Projektor says:\nCompleted " + codeBlockCounter as string + " of " + codeBlockCounter as string +" code blocks.\nProjekt Axis :" + theAxisToProjekt
) catch(feedbackUpdate = "Error in code block: " + codeBlockCounter as string)
) --close function definition
--UI
rollout Projektor " Projektor v1"
(
	--UI
	button projectStickBTN "Project selected" pos:[5,5] tooltip:"Press to project." width:240
	label lbl1 "along World" pos:[30,29] width:140 height:16
	radioButtons axisToProjectRDO "" pos:[95,29] width:120 height:16 labels:#("X", "Y", "Z") columns:3 default:2
	label lbl2 "axis" pos:[190,29] width:140 height:16
	label lbl3 "onto :" pos:[30,48] width:140 height:16
	pickbutton theMeshBTN "this object" pos:[63,46] width:147 height:20 autoDisplay:true
	edittext feedbackBox text:introFeedbackText fieldWidth:236 height:70 pos:[3,72]
	--EVENTS
	on theMeshBTN picked obj do 
	(if isValidNode obj do (theMeshObjectPicked = theMeshBTN.object))
	--
	on axisToProjectRDO changed theState do 
	(
		if axisToProjectRDO.state == 1 then (theAxisToProjekt = "X")
		if axisToProjectRDO.state == 2 then (theAxisToProjekt = "Y")
		if axisToProjectRDO.state == 3 then (theAxisToProjekt = "Z")
	)
	--
	on projectStickBTN pressed do (ProjektorFN();feedbackBox.text = feedbackUpdate)
	--Standard
	button launchBTN "Launch GrakScripts" pos:[5,146] width:222 height:20
	on launchBTN pressed do	(try(fileIn "grakscripts.ms")catch(messagebox "Cannot find GrakScripts.ms"))
	button whoIsBTN "?" pos:[229,146] width:15 height:20
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
)
createDialog Projektor 250 170 100 100 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script
