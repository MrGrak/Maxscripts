--easyLites
--builds interactive lightrigs
--by garrickcampsey (JAN.2011) - garrick@garrickcampsey.com

--TODO
--link UI to script values



--code presets for lightRig dropdown
--have checkbox for 'build cam constrained to circle around selection at 360 frames'
--for standard render
	--build a skylight and setup light-tracer automatically, preset rendering widthXheight 1280x720
	--setup default materials, assign to objects, build ground plane as matte/shadow or groundMAT
--for mental ray
	--setup AO materials, faked GI, etc..



( --start script
global easyLitesRollout
try destroyDialog easyLitesRollout catch()
--script values
local lightRigDistance = 2 --default 2, twice the size of the selection's boundingBox
local linkLitesCheck = true --determines if lights are linked to circle lite rig
local myFirstLightIntensity = 100
local mySecondLightIntensity = 50
local myThirdLightIntensity = 50
local myFourthLightIntensity = 50
local litesOnCheckSum = "1234" --the num notate which lites should be built, default "1234"
	--if only 1 on, checkSum = "1", if 234 on, checksum = "234", etc...
local ranIntensityLitesCheckSum = "1234" --the num notate which lites should have random intensities
local lite1ranIntMin = 100;local lite1ranIntMax = 200 --holds min and max value for intensity randomness
local lite2ranIntMin = 60;local lite2ranIntMax = 120 --(per light)
local lite3ranIntMin = 30;local lite3ranIntMax = 80
local lite4ranIntMin = 30;local lite4ranIntMax = 80
local lite1colorValue = (color 255 255 255) --light color defaults
local lite2colorValue = (color 255 255 255) --light color defaults
local lite3colorValue = (color 255 255 255) --light color defaults
local lite4colorValue = (color 255 255 255) --light color defaults
local ranColorLitesCheckSum = "1234" --the num notate which lites should have random colors
local lite1shadowType = 4 --defaults to 4: 512 shadow map
local lite2shadowType = 2 --defaults to 2: no shadow
local lite3shadowType = 2 --defaults to 2: no shadow
local lite4shadowType = 2 --defaults to 2: no shadow
local ranPosLitesCheckSum = "1234" --the num notate which lites should have random positions (from rotate ring)
--code these
	local ranLiteRigDistance = false --switch, true = random number for lightRigDistance
	local ranLiteNumOnOff = false --switch, true = random number of lites made
--
local darkestRandomColorMinimum = [200,200,200] --the darkest random color (determines black point from max white for random)
--
local codeBlockCounter --tracks the fn, if error happens, user can send the code block #
local introFeedbackText = "EasyLites says:\nI am EasyLites." --init feedback text
local feedbackUpdate = undefined --string for feedback/stats update
--

--
fn easyLitesFn = (
--try (
	--check scene for easyLite objs
	try(select $EasyLitesLiteRigCircle;delete $)catch() --remove prior circle ctrl
	try(select $EasyLitesLite1;delete $)catch() --remove prior circle ctrl
	try(select $EasyLitesLite2;delete $)catch() --remove prior circle ctrl
	try(select $EasyLitesLite3;delete $)catch() --remove prior circle ctrl
	try(select $EasyLitesLite4;delete $)catch() --remove prior circle ctrl	
	--init
	codeBlockCounter = 0
	local PSAiBBboxHelper
	local selectionBoundingBoxArray = #()
	local paddedSelectionArray = #(0)
	local allSceneNodes
	local selectionAsArray
	--if the selection is undefined then select all in scene
	if $ == undefined then 
	(
		allSceneNodes = for node in rootNode.children collect node
		join paddedSelectionArray allSceneNodes
	--otherwise,  the user has something selected
	) else	(
			selectionAsArray = selection as array
			join paddedSelectionArray selectionAsArray
			)
	local PSAcount = paddedSelectionArray.count
	--**1
	codeBlockCounter += 1
	--
	for i = 2 to PSAcount do --skip the padded 0 array[1] value
	(
		--get the bounding box for each object, make BboxCopy
		local PSApivotsave = paddedSelectionArray[i].pivot --save paddedSelectionArray[i]'s pivot
		CenterPivot paddedSelectionArray[i]
		local PSAiBBsize = paddedSelectionArray[i].max - paddedSelectionArray[i].min
		--build a helper box to the BB of the object
		PSAiBBboxHelper = Box lengthsegs:1 widthsegs:1 heightsegs:1 \
		length:PSAiBBsize[2] width:PSAiBBsize[1] height:PSAiBBsize[3] \
		mapcoords:on pos:[0,0,0] isSelected:off
		--align
		PSAiBBboxHelper.pos = paddedSelectionArray[i].pos
		PSAiBBboxHelper.pos.z += -(PSAiBBboxHelper.height/2) --center the boxhelper
		paddedSelectionArray[i].pivot = PSApivotsave --set the pivot back to original pos
		convertToMesh PSAiBBboxHelper
		--put Bbox copy into array to process later
		join selectionBoundingBoxArray PSAiBBboxHelper
	)
	local theCopy = copy PSAiBBboxHelper
	--attach all BboxCopies, get boundingBox for attached boxes
	for i = 1 to selectionBoundingBoxArray.count do	(meshop.attach theCopy selectionBoundingBoxArray[i])
	--get theCopy's boundingBox, this BoundingBox is the selectionsBoundingBox
	CenterPivot theCopy
	local theCopyBBsize = theCopy.max - theCopy.min
	local theCopyBBboxHelper = Box lengthsegs:1 widthsegs:1 heightsegs:1 \
	length:theCopyBBsize[2] width:theCopyBBsize[1] height:theCopyBBsize[3] \
	mapcoords:on pos:[0,0,0] isSelected:off
	theCopyBBboxHelper.pos = theCopy.pos
	theCopyBBboxHelper.pos.z += -(theCopyBBboxHelper.height/2)
	CenterPivot theCopyBBboxHelper
	delete theCopy
	theCopyBBboxHelper.xray = on;theCopyBBboxHelper.renderable = off
	--**2
	codeBlockCounter += 1
	--
	
	--build lights in proportion and distance to selectionsBoundingBox
	select theCopyBBboxHelper
	local myLightRingCircle
	--get the width & length of theCopyBBboxHelper, build light rig circle to largest value
	if theCopyBBboxHelper.width > theCopyBBboxHelper.length then (myLightRingCircle = Circle radius:(theCopyBBboxHelper.width*lightRigDistance) pos:theCopyBBboxHelper.pos) 
	else (myLightRingCircle = Circle radius:(theCopyBBboxHelper.length*lightRigDistance) pos:theCopyBBboxHelper.pos)
	--name myLightRingCircle
	myLightRingCircle.name = "EasyLitesLiteRigCircle";myLightRingCircle.wirecolor = (color 255 255 255)
	--get max of theLightRingCirclesize, use this value to adjust light's x & y position
	local theLightRingCirclesize = (myLightRingCircle.max - myLightRingCircle.min)
	local myLightBuildPOS = (theLightRingCirclesize[2]/2.6)
	
	--BUILD LIGHTS
	--litesOnCheckSum = "1234"
	local checkLite1on = findString litesOnCheckSum "1"
	local checkLite2on = findString litesOnCheckSum "2"
	local checkLite3on = findString litesOnCheckSum "3"
	local checkLite4on = findString litesOnCheckSum "4"
	--
	if checkLite1on != undefined then 
	(--build 1st light
	local myFirstLight = targetSpot rgb:lite1colorValue multiplier:myFirstLightIntensity \
		pos:[myLightBuildPOS+myLightRingCircle.pos.x,myLightBuildPOS+myLightRingCircle.pos.y,myLightBuildPOS] \
		target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]))
		myFirstLight.target.pos = theCopyBBboxHelper.pos
		myFirstLight.attenDecay = 3;myFirstLight.name = "EasyLitesLite1"
		--randomize light intensity code
		--ranIntensityLitesCheckSum = "1234"
		local ranIntLite1 = findString ranIntensityLitesCheckSum "1"
		if ranIntLite1 != undefined then (myFirstLight.multiplier = random lite1ranIntMin lite1ranIntMax)	
		--randomize color 
		--ranColorLitesCheckSum = "1234"
		local ranColLite1 = findString ranColorLitesCheckSum "1"
		if ranColLite1 != undefined then (myFirstLight.rgb = random darkestRandomColorMinimum [255,255,255])
		--randomize position code
		local ranPosLite1 = findString ranPosLitesCheckSum "1" --ranPosLitesCheckSum = "1234"
		if ranPosLite1 != undefined then
		(local myRanRot = (random -360 360)
		myFirstLight.parent = myLightRingCircle;rotate myLightRingCircle (angleaxis myRanRot [0,0,1])
		--**********************************************************************
		--the first light is the main light, these determine height
		--myFirstLight.pos.z = random -myLightBuildPOS myLightBuildPOS
		--myFirstLight.pos.z = random 0 myLightBuildPOS
		myFirstLight.pos.z = random (myLightBuildPOS*0.5) (myLightBuildPOS*2)
		--**********************************************************************
		myFirstLight.parent = undefined)
		
		--assign shadow presets
		--lite1shadowType = 2 --defaults to 2: no shadow
		if lite1shadowType == 2 then 
		(--do not assign a shadow
		myFirstLight.baseObject.castShadows = false)
		if lite1shadowType == 4 then 
			(myFirstLight.shadowGenerator = shadowMap()
			myFirstLight.baseObject.castShadows = true
			myFirstLight.mapsize = 1024;myFirstLight.mapbias = 0.1)
		if lite1shadowType == 3 then 
			(myFirstLight.shadowGenerator = raytraceShadow())
		--myFirstLight.shadowGenerator =Area_Shadows()
		
		 
		
	)
	if checkLite2on != undefined then 
	(--build 2nd light
	local mySecondLight = targetSpot rgb:lite2colorValue multiplier:mySecondLightIntensity \
		pos:[myLightBuildPOS+myLightRingCircle.pos.x,myLightBuildPOS+myLightRingCircle.pos.y,myLightBuildPOS] \
		target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]))
		mySecondLight.target.pos = theCopyBBboxHelper.pos
		mySecondLight.attenDecay = 3;mySecondLight.name = "EasyLitesLite2"
		--randomize light intensity code
		--ranIntensityLitesCheckSum = "1234"
		local ranIntLite2 = findString ranIntensityLitesCheckSum "2"
		if ranIntLite2 != undefined then (mySecondLight.multiplier = random lite2ranIntMin lite2ranIntMax)
		--randomize color 
		--coderanColorLitesCheckSum = "1234"
		local ranColLite2 = findString ranColorLitesCheckSum "2"
		if ranColLite2 != undefined then (mySecondLight.rgb = random darkestRandomColorMinimum [255,255,255])
		--randomize position code
		local ranPosLite2 = findString ranPosLitesCheckSum "2" --ranPosLitesCheckSum = "1234"
		if ranPosLite2 != undefined then
		(local myRanRot = (random -360 360)
		mySecondLight.parent = myLightRingCircle;rotate myLightRingCircle (angleaxis myRanRot [0,0,1])
		--mySecondLight.pos.z = random -myLightBuildPOS myLightBuildPOS
		mySecondLight.pos.z = random 0 myLightBuildPOS
		mySecondLight.parent = undefined)
		
		--assign shadow presets
		--lite2shadowType = 2 --defaults to 2: no shadow
		if lite2shadowType == 2 then 
		(--do not assign a shadow
		mySecondLight.baseObject.castShadows = false)
		if lite2shadowType == 4 then 
			(mySecondLight.shadowGenerator = shadowMap()
			mySecondLight.baseObject.castShadows = true
			mySecondLight.mapsize = 1024;mySecondLight.mapbias = 0.1)
		if lite2shadowType == 3 then 
			(mySecondLight.shadowGenerator = raytraceShadow())
		--mySecondLight.shadowGenerator =Area_Shadows()
		
	)
	if checkLite3on != undefined then 
	(--build 3rd light
	local myThirdLight = targetSpot rgb:lite3colorValue multiplier:myThirdLightIntensity \
		pos:[myLightBuildPOS+myLightRingCircle.pos.x,myLightBuildPOS+myLightRingCircle.pos.y,myLightBuildPOS] \
		target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]))
		myThirdLight.target.pos = theCopyBBboxHelper.pos
		myThirdLight.attenDecay = 3;myThirdLight.name = "EasyLitesLite3"
		--randomize light intensity code
		--ranIntensityLitesCheckSum = "1234"
		local ranIntLite3 = findString ranIntensityLitesCheckSum "3"
		if ranIntLite3 != undefined then (myThirdLight.multiplier = random lite3ranIntMin lite3ranIntMax)
		--randomize color 
		--coderanColorLitesCheckSum = "1234"
		local ranColLite3 = findString ranColorLitesCheckSum "3"
		if ranColLite3 != undefined then (myThirdLight.rgb = random darkestRandomColorMinimum [255,255,255])
		--randomize position code
		local ranPosLite3 = findString ranPosLitesCheckSum "3" --ranPosLitesCheckSum = "1234"
		if ranPosLite3 != undefined then
		(local myRanRot = (random -360 360)
		myThirdLight.parent = myLightRingCircle;rotate myLightRingCircle (angleaxis myRanRot [0,0,1])
		myThirdLight.pos.z = random -myLightBuildPOS myLightBuildPOS;myThirdLight.parent = undefined)
		
		--assign shadow presets
		--lite3shadowType = 2 --defaults to 2: no shadow
		if lite3shadowType == 2 then 
		(--do not assign a shadow
		myThirdLight.baseObject.castShadows = false)
		if lite3shadowType == 4 then 
			(myThirdLight.shadowGenerator = shadowMap()
			myThirdLight.baseObject.castShadows = true
			myThirdLight.mapsize = 1024;myThirdLight.mapbias = 0.1)
		if lite3shadowType == 3 then 
			(myThirdLight.shadowGenerator = raytraceShadow())
		--myThirdLight.shadowGenerator =Area_Shadows()
		
	)
	if checkLite4on != undefined then 
	(--build 4th light
	local myFourthLight = targetSpot rgb:lite4colorValue multiplier:myFourthLightIntensity \
		pos:[myLightBuildPOS+myLightRingCircle.pos.x,myLightBuildPOS+myLightRingCircle.pos.y,myLightBuildPOS] \
		target:(Targetobject transform:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0]))
		myFourthLight.target.pos = theCopyBBboxHelper.pos
		myFourthLight.attenDecay = 3;myFourthLight.name = "EasyLitesLite4"
		--randomize light intensity code
		--ranIntensityLitesCheckSum = "1234"
		local ranIntLite4 = findString ranIntensityLitesCheckSum "4"
		if ranIntLite4 != undefined then (myFourthLight.multiplier = random lite4ranIntMin lite4ranIntMax)
		--randomize color 
		--coderanColorLitesCheckSum = "1234"
		local ranColLite4 = findString ranColorLitesCheckSum "4"
		if ranColLite4 != undefined then (myFourthLight.rgb = random darkestRandomColorMinimum [255,255,255])
		--randomize position code
		local ranPosLite4 = findString ranPosLitesCheckSum "4" --ranPosLitesCheckSum = "1234"
		if ranPosLite4 != undefined then 
		(local myRanRot = (random -360 360)
		myFourthLight.parent = myLightRingCircle;rotate myLightRingCircle (angleaxis myRanRot [0,0,1])
		myFourthLight.pos.z = random -myLightBuildPOS myLightBuildPOS;myFourthLight.parent = undefined)
		
		--assign shadow presets
		--lite3shadowType = 2 --defaults to 2: no shadow
		if lite4shadowType == 2 then 
		(--do not assign a shadow
		myFourthLight.baseObject.castShadows = false)
		if lite4shadowType == 4 then 
			(myFourthLight.shadowGenerator = shadowMap()
			myFourthLight.baseObject.castShadows = true
			myFourthLight.mapsize = 1024;myFourthLight.mapbias = 0.1)
		if lite4shadowType == 3 then 
			(myFourthLight.shadowGenerator = raytraceShadow())
		--myFourthLight.shadowGenerator =Area_Shadows()
		
	)
		

	
	
	--linkLitesCheck:link all lights back to lightRigCircle
	if linkLitesCheck == true then 
	(--try each, lights may not exist
	try(myFirstLight.parent = myLightRingCircle)catch()
	try(mySecondLight.parent = myLightRingCircle)catch()
	try(myThirdLight.parent = myLightRingCircle)catch()
	try(myFourthLight.parent = myLightRingCircle)catch()
	)

	--set shadow properties
	
	--set decay properties, where does the decay begin?  100 unit offset?
	
	--delete bb helper
	delete theCopyBBboxHelper
	
	--set render output settings, set environment, etc...
	--format string value for feedback
	feedbackUpdate = "EasyLites says:\nCompleted " + codeBlockCounter as string + " of " + codeBlockCounter as string +" code blocks."
--) catch(feedbackUpdate = "Error in code block: " + codeBlockCounter as string)
)
--UI
rollout easyLitesRollout " EasyLites"
(
	--UI
	button standardEasyLitesBTN "Build EasyLite Rig" pos:[5,5] width:319 height:20
	dropdownlist presetsDD "Preset LightRigs" items:#("3 PointRig", "4 PointRig", "5 PointRig") selection:1 pos:[5,30] width:319
	--
	groupBox rigPropGroup "Rig Properties" pos:[5,75] width:319 height:45 
	spinner scaleAmountSPN "Rig Distance : " range:[0,10,1.00] type:#float fieldwidth:35 pos:[13,95]
	checkbox linkLitesCHK "Link Lites to Rig" checked:true pos:[220,95]
	--
	groupBox litesPropGroup "Light Properties" pos:[5,125] width:319 height:350 
	--
	checkbutton lite1BTN "Lite 1 ON" checked:false pos:[14,145] width:300 height:20
	spinner lite1intensitySPN "Intensity:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[12,168] enabled:false
	checkbutton lite1ranIntBTN "Ran" checked:false pos:[114,168] width:30 height:16 enabled:false
	spinner lite1intensityminSPN "min:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[154,168] enabled:false
	spinner lite1intensitymaxSPN "max:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[235,168] enabled:false
	colorpicker lite1color "Color:" color:[255,255,255] fieldWidth:65 height:16 pos:[14,193] enabled:false
	checkbutton lite1ranColBTN "Ran" checked:false pos:[114,193] width:30 height:16 enabled:false
	dropdownlist lite1shadowpresetsDD items:#("Shadow...", "Shadows OFF","RayTraced Shadows", "ShadowMap512",\
	"ShadowMap1K", "ShadowMap2K", "ShadowMap4K") selection:1 pos:[156,188] width:158 enabled:false
	--
	on lite1BTN changed theState do 
	(
		if theState == true then 
		(lite1BTN.text = "Lite 1 ON";lite1intensitySPN.enabled = true;lite1ranIntBTN.enabled = true;lite1color.enabled = true
		lite1ranColBTN.enabled = true;lite1shadowpresetsDD.enabled = true
		) else 	(
		lite1BTN.text = "Lite 1 OFF";lite1intensitySPN.enabled = false;lite1ranIntBTN.enabled = false;lite1color.enabled = false
		lite1ranColBTN.enabled = false;	lite1shadowpresetsDD.enabled = false;lite1ranIntBTN.state = false;lite1ranColBTN.state = false;
		lite1intensityminSPN.enabled = false;lite1intensitymaxSPN.enabled = false
		)
	)
	on lite1ranIntBTN changed theState do (if theState == true then 
	(lite1intensitySPN.enabled = false;lite1intensityminSPN.enabled = true;lite1intensitymaxSPN.enabled = true) 
	else (lite1intensitySPN.enabled = true;lite1intensityminSPN.enabled = false;lite1intensitymaxSPN.enabled = false))
	on lite1ranColBTN changed theState do (if theState == true then (lite1color.enabled = false) else (lite1color.enabled = true))
	--	
	label lightSetDivide1 "---------------------------------------------------------------------------------------------------" pos:[14,212] width:300 height:17
	--Lite set 2 (+85px)
	checkbutton lite2BTN "Lite 2 ON" checked:false pos:[14,230] width:300 height:20
	spinner lite2intensitySPN "Intensity:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[12,253] enabled:false
	checkbutton lite2ranIntBTN "Ran" checked:false pos:[114,253] width:30 height:16 enabled:false
	spinner lite2intensityminSPN "min:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[154,253] enabled:false
	spinner lite2intensitymaxSPN "max:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[235,253] enabled:false
	colorpicker lite2color "Color:" color:[255,255,255] fieldWidth:65 height:16 pos:[14,278] enabled:false
	checkbutton lite2ranColBTN "Ran" checked:false pos:[114,278] width:30 height:16 enabled:false
	dropdownlist lite2shadowpresetsDD items:#("Shadow...", "Shadows OFF","RayTraced Shadows", "ShadowMap512",\
	"ShadowMap1K", "ShadowMap2K", "ShadowMap4K") selection:1 pos:[156,273] width:158 enabled:false
	--
	label lightSetDivide2 "---------------------------------------------------------------------------------------------------" pos:[14,297] width:300 height:17
	--Lite set 3 (+85px)
	checkbutton lite3BTN "Lite 3 ON" checked:false pos:[14,315] width:300 height:20
	spinner lite3intensitySPN "Intensity:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[12,338] enabled:false
	checkbutton lite3ranIntBTN "Ran" checked:false pos:[114,338] width:30 height:16 enabled:false
	spinner lite3intensityminSPN "min:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[154,338] enabled:false
	spinner lite3intensitymaxSPN "max:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[235,338] enabled:false
	colorpicker lite3color "Color:" color:[255,255,255] fieldWidth:65 height:16 pos:[14,363] enabled:false
	checkbutton lite3ranColBTN "Ran" checked:false pos:[114,363] width:30 height:16 enabled:false
	dropdownlist lite3shadowpresetsDD items:#("Shadow...", "Shadows OFF","RayTraced Shadows", "ShadowMap512",\
	"ShadowMap1K", "ShadowMap2K", "ShadowMap4K") selection:1 pos:[156,358] width:158 enabled:false
	--
	label lightSetDivide3 "---------------------------------------------------------------------------------------------------" pos:[14,382] width:300 height:17
	--Lite set 4 (+85px)
	checkbutton lite4BTN "Lite 4 ON" checked:false pos:[14,400] width:300 height:20
	spinner lite4intensitySPN "Intensity:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[12,423] enabled:false
	checkbutton lite4ranIntBTN "Ran" checked:false pos:[114,423] width:30 height:16 enabled:false
	spinner lite4intensityminSPN "min:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[154,423] enabled:false
	spinner lite4intensitymaxSPN "max:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[235,423] enabled:false
	colorpicker lite4color "Color:" color:[255,255,255] fieldWidth:65 height:16 pos:[14,448] enabled:false
	checkbutton lite4ranColBTN "Ran" checked:false pos:[114,448] width:30 height:16 enabled:false
	dropdownlist lite4shadowpresetsDD items:#("Shadow...", "Shadows OFF","RayTraced Shadows", "ShadowMap512",\
	"ShadowMap1K", "ShadowMap2K", "ShadowMap4K") selection:1 pos:[156,443] width:158 enabled:false
	--
	groupBox randomPropGroup "Randomize Properties" pos:[5,480] width:319 height:65 
	checkbutton randomizeOnBTN "Randomize ON" checked:false pos:[14,500] width:300 height:20
	checkbox ranPosCHK "Position" checked:false pos:[14,525] enabled:false
	checkbox ranColCHK "Color" checked:false pos:[76,525] enabled:false
	checkbox ranIntCHK "Intensity" checked:false pos:[126,525] enabled:false
	checkbox ranDisCHK "Distance" checked:false pos:[190,525] enabled:false
	checkbox ranNumCHK "Number" checked:false pos:[257,525] enabled:false
	--
	checkbox prepSceneCHK "Prep scene for render..." checked:false pos:[5,550] enabled:false
	--main button event
	on standardEasyLitesBTN pressed do (easyLitesFn();try(feedbackBox.text = feedbackUpdate) catch())
	--PRESETS Dropdown devents
	on presetsDD selected i do 
		(
		if presetsDD.items[i] == "3 PointRig" then
			(
			--code...
			)
		else if presetsDD.items[i] == "4 PointRig" then
			(
			--code...
			)
		else if presetsDD.items[i] == "5 PointRig" then
			(
			--code...
			)
		)
	--Grakscripts Standard UI & Events
	edittext feedbackBox text:introFeedbackText fieldWidth:319 height:100 pos:[2,570]
	button launchBTN "Launch GrakScripts" pos:[5,675] width:302 height:20
	on launchBTN pressed do	(try(fileIn "grakscripts.ms")catch(messagebox "Cannot find GrakScripts.ms"))
	button whoIsBTN "?" pos:[311,675] width:15 height:20
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
)
createDialog easyLitesRollout 330 700 100 100 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script
