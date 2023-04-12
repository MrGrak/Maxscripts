--ObjektV1
--by Garrick@GarrickCampsey.com 
--started:DEC.30.2010 lastUpdated:DEC.31.2010
--this idea can be expanded to include any type of object (table, chair, stones, pieces of wood, etc...)




--TODO
--0.  add code that sets objekt pivot equal to BB bottom, then moves objekt back to spawn icon .pos
--0.  scale spawn icon to the size of the objekt last built
--1.  add layer management to spawnIcon and created objekts
--2.  add a lock to the width and height values
--3.  add turbosmooth control for final smooths, include render itrs, and display itrs
--4.  --add more controls for the FFD modifier, there are lots of possibilities here
		--you could potentially use a circle ctrl to modify top and bottom
--WISHLIST
--add preset for plate, wastebasket, flowerpot, kiddiepool
--add checkbox for 'openTop' - openTop describes current objects
--'closedTop' objects would be things like tables, chairs, books, etc...
--add algorithms for building closed top objects, use spawn icon
--get control over the edgeloops dictating the top lip of the cup, use a ring on a known line index
--add code for handles on the side of the cup, allow for mirroring across both axis
--add code for a stem to be added, add UI checkbox for stem/noStem
	--stem should have FFD(s) controlling the edgeloops defining it's silhouette
	--stem bottom lip needs controls
	--stem top whereItConnectsTo the bottom of the cup needs controls
--add code for different types of tops, such as a screw on top, kettle top, domed top, flat top, etc...




( --start script
global ObjektRollout
try destroyDialog ObjektRollout catch()
--
local introFeedbackText = "Objekt says:\nLet's make some Objekts." --init feedback text
local feedbackUpdate
local cupPinchAmount = 95 --determines pinch amount for objekt edges
local insetAmount = 0.111 --normalized space, controls amount of objekt inset
local myCupHeight = 50
local myCupWidth = 50
local myCupLength = 50
local myCupShellSegments = 3 --determines the segments on the shell mod
local myCupShellAmount = 5 --determines the amount shelled OUT on the shell mod
local experimentMode = true --determines if the previous cup is deleted or not
local codeBlockCounter --tracks the fn, if error happens, user can send the code block #
local myBox
local bottomFaceInsetAmount = 15 --determines the inset amount for the bottom box face
local outputColorValue = (color 0 0 200) --default color value blue
local iconColorValue = (color 255 255 255) --default color value blue
local scaleAmount = 1 --controls amount of scale on objekt
local objektSpawnICON --the Spawn Icon
--
fn spawnIconFN = (
	--scene setup
	backgroundColor = color 100 100 100
	--build objekt's spawn point
	try(select $SpawnIcon;delete $)catch() --check to remove prior spawn point
	local objektText = text size:15 kerning:0 leading:0 pos:[0,-4.45549,0] text:"Objekt"
	convertToSplineShape objektText
	updateShape objektText
	objektSpawnICON = Circle radius:25 pos:[0,0,0]
	objektSpawnICON.name = "SpawnIcon"
	convertToSplineShape objektSpawnICON
	updateShape objektSpawnICON
	addAndWeld objektSpawnICON objektText 0.0 --attach the text to the circle
	updateShape objektSpawnICON
	objektSpawnICON.wirecolor = iconColorValue
	select objektSpawnICON
	)
--
fn SubDObjects = (
--try (
	codeBlockCounter = 0
	if experimentMode == true then (try(select myBox;delete $)catch()) --remove myBox
	myBox = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:myCupLength width:myCupWidth height:myCupHeight pos:[0,0,0]
	--
	try(myBox.pos = objektSpawnICON.pos)catch(spawnIconFN();myBox.pos = objektSpawnICON.pos)
	myBox.name = uniqueName "Objekt"
	fn randomColValue = (return random 0 200)
	myBox.wirecolor = [randomColValue(),randomColValue(),randomColValue()]
	--myBox.wirecolor = outputColorValue
	scale myBox [scaleAmount,scaleAmount,scaleAmount]
	--
	--**1
	codeBlockCounter += 1
	select myBox
	modPanel.addModToSelection (Edit_Poly ()) ui:on --add editPoly mod
	--**2
	codeBlockCounter += 1
	--build edgeloops for top and bottom
	if cupPinchAmount == 0  then 
		(
		--no edgeloop is added
		) 
	else if cupPinchAmount == 1 then
		(
		subobjectLevel = 2
		myBox.modifiers[#Edit_Poly].SetSelection #Edge #{10}
		myBox.modifiers[#Edit_Poly].ButtonOp #SelectEdgeRing
		myBox.modifiers[#Edit_Poly].connectEdgeSegments = 1 --just one edge loop
		myBox.modifiers[#Edit_Poly].Commit ()
		)
	else if cupPinchAmount == 100 then
		(
		subobjectLevel = 2
		myBox.modifiers[#Edit_Poly].SetSelection #Edge #{10}
		myBox.modifiers[#Edit_Poly].Select #Edge #{10}
		myBox.modifiers[#Edit_Poly].ButtonOp #SelectEdgeRing
		myBox.modifiers[#Edit_Poly].SetOperation #ConnectEdges
		myBox.modifiers[#Edit_Poly].connectEdgeSegments = 2 --lots of segments
		myBox.modifiers[#Edit_Poly].connectEdgePinch = 99 --max pinch
		myBox.modifiers[#Edit_Poly].Commit ()
		
		)
	else 
		(
		subobjectLevel = 2
		myBox.modifiers[#Edit_Poly].SetSelection #Edge #{10}
		myBox.modifiers[#Edit_Poly].Select #Edge #{10}
		myBox.modifiers[#Edit_Poly].ButtonOp #SelectEdgeRing
		myBox.modifiers[#Edit_Poly].SetOperation #ConnectEdges
		myBox.modifiers[#Edit_Poly].connectEdgeSegments = 2 -- just 2
		myBox.modifiers[#Edit_Poly].connectEdgePinch = cupPinchAmount --pinch it
		myBox.modifiers[#Edit_Poly].Commit ()
		)
	if bottomFaceInsetAmount == 0 then 
		(
		--do not inset the face
		) 
	else
		(
		subobjectLevel = 4 --inset the bottom face
		myBox.modifiers[#Edit_Poly].SetSelection #Face #{}
		myBox.modifiers[#Edit_Poly].Select #Face #{1}
		myBox.modifiers[#Edit_Poly].SetOperation #Inset
		myBox.modifiers[#Edit_Poly].insetAmount = bottomFaceInsetAmount
		myBox.modifiers[#Edit_Poly].Commit ()
		)
	--
	--**3
	codeBlockCounter += 1
	--remove top face
	subobjectLevel = 4
	myBox.modifiers[#Edit_Poly].SetSelection #Face #{}
	myBox.modifiers[#Edit_Poly].Select #Face #{2}
	myBox.modifiers[#Edit_Poly].ButtonOp #DeleteFace
	--close up editPoly mod
	subobjectLevel = 0
	--turbo smooth
	modPanel.addModToSelection (TurboSmooth ()) ui:on
	myBox.modifiers[#TurboSmooth].iterations = 2
	modPanel.addModToSelection (Shell ()) ui:on
	myBox.modifiers[#Shell].outerAmount = myCupShellAmount
	myBox.modifiers[#Shell].Segments = myCupShellSegments
	--**4
	codeBlockCounter += 1
	--
	--FFD 2x2x2 - Inset algorithm
	modPanel.addModToSelection (FFD_2x2x2 ()) ui:on
	animateAll myBox.modifiers[#FFD_2x2x2]
	--add code to control top and bottom points movement, then move into ffd3 and ffd4
	--bottom left
	myBox.ffd_2x2x2.control_point_1 += [insetAmount,insetAmount,0] --bottom
	--myBox.ffd_2x2x2.control_point_2 += [insetAmount,insetAmount,0] --top
	--top left
	myBox.ffd_2x2x2.control_point_3 += [insetAmount,-insetAmount,0] --bottom
	--myBox.ffd_2x2x2.control_point_4 += [insetAmount,-insetAmount,0] --top
	--bottom right
	myBox.ffd_2x2x2.control_point_5 += [-insetAmount,insetAmount,0] --bottom
	--myBox.ffd_2x2x2.control_point_6 += [-insetAmount,insetAmount,0] --top
	--top right
	myBox.ffd_2x2x2.control_point_7 += [-insetAmount,-insetAmount,0] --bottom
	--myBox.ffd_2x2x2.control_point_8 += [-insetAmount,-insetAmount,0] --top
	--
	--**5
	codeBlockCounter += 1
	modPanel.addModToSelection (TurboSmooth ()) ui:on
	myBox.modifiers[#TurboSmooth].iterations = 0
	myBox.modifiers[#TurboSmooth].isolineDisplay = on
	myBox.modifiers[#TurboSmooth].useRenderIterations = on
	myBox.modifiers[#TurboSmooth].renderIterations = 2
	--
	
	--assign a default standard material
	local m = standard()
	m.diffuse = color 123 123 123
	myBox.material = m 
	
	
	
	
	
	--add handle
	--add stem
	--
	--zoom bounds
	--actionMan.executeAction 0 "311"
	--
	--UPDATE ICON
	--determine boundingBox of objekt
	--determine boundingBox of currentSpawnIcon
	--compare these dimensions, if the Icon's BB < objekt's BB, scale icon, compare again, else 
	--END
	--
	/*
	try(select $Spawn;delete $)catch() --check to remove prior spawn point
	local objektText = text size:15 kerning:0 leading:0 pos:[0,-4.45549,0] text:"Objekt"
	convertToSplineShape objektText
	updateShape objektText
	objektSpawnICON = Circle radius:25 pos:[0,0,0]
	objektSpawnICON.name = "Spawn"
	convertToSplineShape objektSpawnICON
	updateShape objektSpawnICON
	addAndWeld objektSpawnICON objektText 0.0 --attach the text to the circle
	updateShape objektSpawnICON
	objektSpawnICON.wirecolor = outputColorValue
	select objektSpawnICON
	*/
	--give user back objekt spawn icon
	select objektSpawnICON
	--
	--provide feedback to script listener
	feedbackUpdate = "Objekt says :\nCompleted " + codeBlockCounter as string + " of " + codeBlockCounter as string +" code blocks."
	--
--) catch(feedbackUpdate = "Error in code block: " + codeBlockCounter as string)
)
--UI
rollout ObjektRollout " Objekt v1"
(
--UI
	button runCCBTN "Build Objekt" pos:[5,5] width:135 height:20
	button spawnIconBTN "Build Spawn Icon" pos:[145,5] width:100 height:20
	checkbox experimentModeCHK "Developer's Mode" checked:true pos:[80,35]
	label cupPinchAmountLBL "Pinch Amount :" width:90 height:18 pos:[48,60]
	spinner cupPinchAmountSPN range:[0,100,95] type:#integer fieldwidth:70 pos:[120,60]
	label insetAmountLBL "Inset Amount :" width:90 height:18 pos:[52,80]
	spinner insetAmountSPN range:[0.000,1.000,0.1] type:#float scale:0.01 fieldwidth:70 pos:[120,80]
	label myCupHeightLBL "Height :" width:90 height:18 pos:[83,100]
	spinner myCupHeightSPN range:[0,1000,50] type:#float fieldwidth:70 pos:[120,100]
	label myCupWidthLBL "Width :" width:90 height:18 pos:[86,120]
	spinner myCupWidthSPN range:[0,1000,50] type:#float fieldwidth:70 pos:[120,120]
	label myCupLengthLBL "Length :" width:90 height:18 pos:[81,140]
	spinner myCupLengthSPN range:[0,1000,50] type:#float fieldwidth:70 pos:[120,140]
	label myCupShellAmountLBL "Thickness :" width:90 height:18 pos:[65,160]
	spinner myCupShellAmountSPN range:[0,1000,3] type:#float fieldwidth:70 pos:[120,160]
	label bottomFaceInsetAmountLBL "Bottom Inset :" width:90 height:18 pos:[55,180]
	spinner bottomFaceInsetAmountSPN range:[0,1000,15] type:#float fieldwidth:70 pos:[120,180]
	label scaleAmountLBL "Scale :" width:90 height:18 pos:[87,200]
	spinner scaleAmountSPN range:[0.00,10000.00,1.00] type:#float fieldwidth:70 pos:[120,200]
	--
	--dropdownlist presetsDD "Preset Objects" items:#("Cup", "Bowl", "DogDish", "BathTub", "PizzaPan", "SnowCone") selection:1 pos:[5,250] width:240
	button randomizeBTN "Randomize Values" pos:[5,295] width:240 height:20
	edittext feedbackBox text:introFeedbackText fieldWidth:238 height:50 pos:[2,320]
	button launchBTN "Launch GrakScripts" pos:[5,375] width:222 height:20
	on launchBTN pressed do	(try(fileIn "grakscripts.ms")catch(messagebox "Cannot find GrakScripts.ms"))
	button whoIsBTN "?" pos:[229,375] width:15 height:20
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
	--
--Events
	on myCupHeightSPN changed theState do (try(myCupHeight = myCupHeightSPN.value;myBox.height = myCupHeightSPN.value)catch())
	on myCupWidthSPN changed theState do (try(myCupWidth = myCupWidthSPN.value;myBox.width = myCupWidthSPN.value)catch())
	on myCupLengthSPN changed theState do (try(myCupLength = myCupLengthSPN.value;myBox.length = myCupLengthSPN.value)catch())
	on myCupShellAmountSPN changed theState do (try(myCupShellAmount = myCupShellAmountSPN.value;myBox.modifiers[#Shell].outerAmount = myCupShellAmountSPN.value)catch())
	--
	on spawnIconBTN pressed do (spawnIconFN();feedbackBox.text = "Objekt says :\nNew Spawn Icon created @ 0,0,0")
	on scaleAmountSPN changed theState do 
		(
		scaleAmount = scaleAmountSPN.value
		SubDObjects();try(feedbackBox.text = feedbackUpdate) catch() --run main fn
		)
	on randomizeBTN pressed do 
		(
		--the limiting values determine what can be built
		myCupHeightSPN.value = (random 1.0 80);myCupHeight = myCupHeightSPN.value
		--
		local lockWidthAndLengthChance = (random 1 100)
		if lockWidthAndLengthChance < 50 then
			( --the width and length are locked
			local theAmount = (random 10 200)
			myCupWidthSPN.value = theAmount;myCupWidth = myCupWidthSPN.value
			myCupLengthSPN.value = theAmount;myCupLength = myCupLengthSPN.value
			)
		else
			( --the width and length are not locked
			myCupWidthSPN.value = (random 10 200);myCupWidth = myCupWidthSPN.value
			myCupLengthSPN.value = (random 10 200);myCupLength = myCupLengthSPN.value
			)
		--
		myCupShellAmountSPN.value = (random 1.0 10);myCupShellAmount = myCupShellAmountSPN.value
		bottomFaceInsetAmountSPN.value = (random 1.0 25);bottomFaceInsetAmount = bottomFaceInsetAmountSPN.value
		cupPinchAmountSPN.value = (random 1 100);cupPinchAmount = cupPinchAmountSPN.value
		insetAmountSPN.value = (random 0.0 0.4);insetAmount = (insetAmountSPN.value)
		SubDObjects();try(feedbackBox.text = feedbackUpdate) catch() --run main fn
		)
	on bottomFaceInsetAmountSPN entered do (bottomFaceInsetAmount = bottomFaceInsetAmountSPN.value;SubDObjects();try(feedbackBox.text = feedbackUpdate) catch())
	on experimentModeCHK changed theState do (experimentMode = experimentModeCHK.state)
	on cupPinchAmountSPN entered do (cupPinchAmount = cupPinchAmountSPN.value;SubDObjects();try(feedbackBox.text = feedbackUpdate) catch())
	on insetAmountSPN entered do (insetAmount = insetAmountSPN.value;SubDObjects();try(feedbackBox.text = feedbackUpdate) catch())
	on runCCBTN pressed do (SubDObjects();try(feedbackBox.text = feedbackUpdate) catch())
	--on resetBTN pressed do (resetMaxFile #noPrompt)
	--
	--PRESETS
	dropdownlist presetsDD "Preset Objects" items:#("Cup", "Bowl", "Plate", "WasteBasket",\
	"DogDish", "SnowCone") selection:1 pos:[5,250] width:240
	on presetsDD selected i do 
		(
		if presetsDD.items[i] == "WasteBasket" then
			(
			cupPinchAmountSPN.value = 47
			insetAmountSPN.value = 0.07
			myCupHeightSPN.value = 75
			myCupWidthSPN.value = 100
			myCupLengthSPN.value = 100
			myCupShellAmountSPN.value = 2
			bottomFaceInsetAmountSPN.value = 20
			)
		if presetsDD.items[i] == "Cup" then
			(
			cupPinchAmountSPN.value = 95
			insetAmountSPN.value = 0.15
			myCupHeightSPN.value = 70
			myCupWidthSPN.value = 50
			myCupLengthSPN.value = 50
			myCupShellAmountSPN.value = 2
			bottomFaceInsetAmountSPN.value = 5
			)
		else if presetsDD.items[i] == "Bowl" then
			(
			cupPinchAmountSPN.value = 1
			insetAmountSPN.value = 0.04
			myCupHeightSPN.value = 50
			myCupWidthSPN.value = 80
			myCupLengthSPN.value = 80
			myCupShellAmountSPN.value = 2
			bottomFaceInsetAmountSPN.value = 0
			)
		else if presetsDD.items[i] == "DogDish" then
			(
			cupPinchAmountSPN.value = 50
			insetAmountSPN.value = 0.1
			myCupHeightSPN.value = 11
			myCupWidthSPN.value = 100
			myCupLengthSPN.value = 100
			myCupShellAmountSPN.value = 13
			bottomFaceInsetAmountSPN.value = 2
			)
		else if presetsDD.items[i] == "Plate" then
			(
			cupPinchAmountSPN.value = 99
			insetAmountSPN.value = 0.0
			myCupHeightSPN.value = 0.2
			myCupWidthSPN.value = 200
			myCupLengthSPN.value = 200
			myCupShellAmountSPN.value = 2
			bottomFaceInsetAmountSPN.value = 0.2
			)
		else if presetsDD.items[i] == "SnowCone" then
			(
			cupPinchAmountSPN.value = 0
			insetAmountSPN.value = 0.45
			myCupHeightSPN.value = 75
			myCupWidthSPN.value = 50
			myCupLengthSPN.value = 50
			myCupShellAmountSPN.value = 2
			bottomFaceInsetAmountSPN.value = 30
			)
		--set spinner values into script values
		myCupHeight = myCupHeightSPN.value
		myCupWidth = myCupWidthSPN.value
		myCupLength = myCupLengthSPN.value
		myCupShellAmount = myCupShellAmountSPN.value
		bottomFaceInsetAmount = bottomFaceInsetAmountSPN.value
		cupPinchAmount = cupPinchAmountSPN.value
		insetAmount = (insetAmountSPN.value)
		--run SubDObjects fn
		SubDObjects();try(feedbackBox.text = feedbackUpdate) catch() --run main fn
		)
)
createDialog ObjektRollout 250 400 100 100 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script