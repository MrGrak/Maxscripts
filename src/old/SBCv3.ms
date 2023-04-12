--SBC v2.2
--by Garrick Campsey 2010
--garrick@garrickcampsey.com
/* 	
	TODO - 11.28
	- add checkBox 'link up CTRLS to SBC_meshCTRL' - automates the process of linking up CTRLS to head CTRL
	- ability to add single ctrls, and project, and add into skin (for delicate control)
	- create working quat/joleanes setup bones
	- make local to local ctrl axis (upon creation), so user has option for world or local ctrl co-ordinates
	- reset should destroy all nodes on SBC layers, then delete layers.  currently, it breaks if any layer has a node
	- link two ctrls, select 2 ctrls, then press link, to build a bonechain between them
	- code a flood weights fn for the skin mod
	- code a method to make the bones default weight better (envelope sizes?)
	- mirror existing chain - select any SBC chain and build a mirror of it on opposite user-set world axis
	- add a rayIntersect search function that shoots rays from the ctrls position, but if a ray doesn't hit,
	  then it shoots rays from the ctrls position + and - 100 units, then checks again. if a ray doesn't hit,
	  then it shoots rays from the ctrls position + and - 1000 units, and so on.  It should also randomly
	  add an offset to the ctrls position that is very small, as that may help with checking for ray intersects.
	  Also, code a method that searches in an outward spiral from the chosen .pos, as this is an effective way
	  of searching for the mesh.
	- add code to click to create function that resets the pickpoint so it breaks less
*/
















( --start script
global SBCcontainerRollout
--global stretchyBonesCreatorStruct --not needed
try destroyDialog SBCcontainerRollout catch()
--SCRIPT INDEX
--script scope values, updated by buttons as they are clicked/entered/changed, accessed by fns
local boneChainNumerator = 1 --determines the first chain number created with this script instance, default:SBChain1, updated by searchForSBCchains()
local theMeshObjectPicked = undefined --the mesh object that the user has picked
local currentCtrlLayerName =  "controls" --default:"controls"
local currentBoneLayerName = "bones" --default:"bones"
local currentTypeOfCtrl = "Spheres" --default:"Spheres"
local currentTypeOfBone = "Bone" --default:"Bone"
local currentControlColor = (color 0 0 255) --default:blue
local currentBoneColor = (color 125 125 125) --default:grey
local layerColorHidden = (color 0 0 0) --this variable determines the hidden layer color values
local currentControlSize = 1 --default size:1
local currentBoneSize = 1 --default size:1
local currentC2CpHelpersSize = 1 --default size:1
local currentNumOfControlsToMake = 5 --the number of children ctrls to add to the selected object, default value:5
local stretchOrJoleanesType = "stretchy" --defaults type of bone to "stretchy", "joleanes" - this is Euler_XYZ(), trying to make other Quat
local buildType = undefined --this variable holds the type of build, "line", "addChild"
local mirrorC2CaxisXenabled = false --mirror click to create ctrls on x axis
local mirrorC2CaxisYenabled = false --mirror click to create ctrls on y axis
local mirrorC2CaxisZenabled = false --mirror click to create ctrls on z axis
local currentProjectAxis = "y" --this determines the axis that is projected, defaults to "y"
local autoSkinValue = false --decides wether the bones are auto added into skin mod
local autoProject = false --decides wether ctrls are projected onto mesh at creation time
local chainIsMirrored = false --default setting for chain is mirrored question
local currentBoneUpNode = [0,0,1] -- default: [0,0,1] this determines the bones upnode axis (the flip axis)
--arrays
local newCTRLSArray = #() --created ctrls go into this array
local newCTRLSArrayMirror = #() --created mirror ctrls go into this array
local newBONESArray = #() --created bones go into this array
local newBONESArrayMirror = #() --created mirror bones go into this array
local newSBCchain = #() --the new chain array, containing all bones and ctrls just created
local newSBCchainMirror = #() --the new mirror chain array, containing all bones and ctrls just created
local lastCreatedChain = #() --the last created chain, target for UNDO
local lastCreatedChainMirror = #() --the last created mirror chain, target for UNDO
local buildingHelpersArray = #() --used in the clickToCreate fn, this holds the temp helpers in an array
local buildingHelpersArrayMirrored = #() --used in the clickToCreate fn, this holds the mirrored temp helpers in an array
local theCurrentOBJselected = #() --this is a temp variable holder for a $ objects
--
struct stretchyBonesCreatorStruct 
(
--fn index
fn searchForSBCchains = (), --11.28.10, searches through all objects and finds 'SBCchain' text, then adopts the number after the text + 1
fn clickToCreateLine = (), --11.28.10, captures user input in the form of pHelpers, then calls buildCtrls fn
fn buildCtrls = (), --11.21.10, builds ctrls to user input pHelpers, or single object, then calls buildBones fn
fn buildBones = (), --11.21.10, builds bones to ctrl.pos, according to script scope var parameters, then calls chainManager fn
fn chainManager = (), --11.21.10, takes lastCreatedChain and uniquely names it, housekeeping
fn undoLastChain = (), --11.21.10, undos last chain, and mirrored chain 
fn deleteSelectedChain = (), --11.21.10, deletes entire chain, nubBones and all
fn resetSBC = (), --11.28.10, removes SBC layers + nodes
fn projectSelected = (), --10.21.10, projects array of objects onto another object via intersectRay, accepts (x, y, z)
fn linkOneToOne = (), --11.21.10, links a ctrl to another ctrl
fn quickSkin = (), --11.21.10, skins an object to a fake boundingBox
fn autoSkin = (), --11.21.10, autoSkin stretchyBones in lastCreatedChain & mirror arrays into theMesh's skin mod
fn skinWeightsToggle = (), --11.21.10, toggles the weights dialogue open and closed - buggy in most instances
--























--defs
fn searchForSBCchains = 
(	
	print "checking scene for SBC naming conventions..."
	local foundSBChainNumARRAY = #()
	select $*SBChain* --is the double wildcard necessary?
	try local SBCInScene = $ as array catch()
	clearSelection()
	if SBCInScene != undefined do
	(
		for i = 1 to SBCInScene.count do
		(
			local SBCinSceneIasString = SBCInScene[i] as string --turn each obj into string
			--parse out number after 'SBChain' naming convention
			local namingConventionSBChain = ":"
			local foundSBCnum = filterString SBCinSceneIasString namingConventionSBChain
			--
			if foundSBCnum[2] >= "SBChain" then 
				(append foundSBChainNumARRAY foundSBCnum[2]) --put found num into array to check max value later
		)
	)
	--
	--assigns bonechain numerator
	if foundSBChainNumARRAY != undefined then
	(
		local theBiggestValue
		local foundChainsGreaterThan10 = #()
		local foundChainsGreaterThan100 = #()
		local foundChainsLessThan10 = #()
		--
		for i = 1 to foundSBChainNumARRAY.count do 
		(
			--parse out number of bonechain
			local namingConventionSBChain = "SBChain"
			local foundSBChainNumARRAYiAsString = foundSBChainNumARRAY[i] as string
			local foundSBCnum = filterString foundSBChainNumARRAYiAsString namingConventionSBChain
			--print foundSBCnum[1] -- = number
			try local foundSBCnumberTemp = foundSBCnum[1] as integer catch()
			if foundSBCnumberTemp != undefined then (append foundChainsLessThan10 foundSBCnumberTemp)
			--
		)
		--			
		for i = 1 to foundChainsLessThan10.count do 
		(
			--if it's greater than a single digit, put into array
			if foundChainsLessThan10[i] > 99 then
				(append foundChainsGreaterThan100 foundChainsLessThan10[i]
			) else if foundChainsLessThan10[i] > 9 then
				(append foundChainsGreaterThan10 foundChainsLessThan10[i])
		)
		--
		sort foundChainsLessThan10
		sort foundChainsGreaterThan10
		sort foundChainsGreaterThan100
		--
		case of
			(
				(foundChainsGreaterThan100[1] != undefined): theBiggestValue = foundChainsGreaterThan100[foundChainsGreaterThan100.count]
				(foundChainsGreaterThan10[1] != undefined): theBiggestValue = foundChainsGreaterThan10[foundChainsGreaterThan10.count]
				(foundChainsLessThan10[1] != undefined): theBiggestValue = foundChainsLessThan10[foundChainsLessThan10.count]
				default: theBiggestValue = 0
			)
		--
		if theBiggestValue != undefined then
		(
			boneChainNumerator = theBiggestValue + 1
			print "Next bone chain starts with:"
			print boneChainNumerator
		)
	) --end if	
),
--
fn chainManager = 
(
	for i=1 to newSBCchain.count do
	(
		--if the boneChain to manage is addChid, then
			--make the boneChain to manage inherit the naming convention of the parent object
			if buildType == "addChild" then 
			(
				local boneChainNumeratorAsString = boneChainNumerator as string
				newSBCchain[i].name = "SBChain" + boneChainNumeratorAsString + ":" + newSBCchain[i].name
			) else (
				--if the boneChain to manage is click2create then
				--put each obj in array into unique chainNumber
				local boneChainNumeratorAsString = boneChainNumerator as string
				newSBCchain[i].name = "SBChain" + boneChainNumeratorAsString + ":" + newSBCchain[i].name
			)
	)
	--create a mirrored bone chain
	try for i=1 to newSBCchainMirror.count do
	(
		--if the boneChain to manage is addChid, then
			--make the boneChain to manage inherit the naming convention of the parent object
			if buildType == "addChild" then 
			(
				local boneChainNumeratorAsString = boneChainNumerator as string
				newSBCchainMirror[i].name = "SBChain" + boneChainNumeratorAsString + ":" + newSBCchainMirror[i].name
			) else (
				--if the boneChain to manage is click2create then
				--put each obj in array into unique chainNumber
				local boneChainNumeratorAsString = boneChainNumerator as string
				newSBCchainMirror[i].name = "SBChain" + boneChainNumeratorAsString + "M:" + newSBCchainMirror[i].name
			)
	) catch()
	--
	boneChainNumerator += 1
	--setup UNDO for last created chain & possibly mirror
	lastCreatedChain = newSBCchain
	try lastCreatedChainMirror = newSBCchainMirror catch()
	--
	--clean out all arrays and reset to 'like new' state
	newSBCchain = #()
	newSBCchainMirror = #()
	newBONESArray = #()
	newBONESArrayMirror = #()
	newCTRLSArray = #()	
	newCTRLSArrayMirror = #()	
	--do a little houseKeeping on the hiddenLayer
	local hiddenMakeLayerName = "SBC_zHidden"
	layermanager.newLayerFromName hiddenMakeLayerName
	local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
	Hiddenlayer.isHidden = true
	Hiddenlayer.isFrozen = true
	--feedback success
	print "SBC: Chain sucessfully created and organized."
	--try to give user back selected object...
	try select theCurrentOBJselected catch()
	--...then reset that array as well
	theCurrentOBJselected = #()
),
--
fn buildBones = 
(
	--buildType: "line", "addChild"	
	if buildType == "line" then 
	(
		--build first line, then build mirrored line 2nd
		for i = 1 to newCTRLSArray.count do
		(
			--check to see if i+1 is undefined, if true = end of bonechain
			if newCTRLSArray[i+1] != undefined then 
			(
				local buildPOS1 = newCTRLSArray[i].pos
				local buildPOS2 = newCTRLSArray[i+1].pos
				local freshBone = BoneSys.createBone buildPOS1 buildPOS2 [0,0,1] --upNode value:[0,0,1], Zaxis up by default
				--
				setTransformLockFlags freshBone #all
				if currentTypeOfBone == "boxMode" then (freshBone.boxMode = true)
				freshBone.boneFreezeLength = false
				freshBone.wirecolor = currentBoneColor
				--set BONE SIZE
				freshBone.width = currentBoneSize
				freshBone.height = currentBoneSize
				--boneChainPrefix
				freshBone.name = "stretchyB" + i as string
				freshBone.renderable = false
				if (boneTypeToBuild == 2) do 
					(freshBone.boxmode = on)
				--add new bones to bonesLayer
				local bonesMakeLayerName = "SBC_" + currentBoneLayerName
				layermanager.newLayerFromName bonesMakeLayerName
				local Boneslayer = layermanager.getLayerFromName bonesMakeLayerName
				BonesLayer.addnode freshBone
				append newBONESArray freshBone
				--
			)  --end if
		)--end for
		--
		--build a nubBone after last bone (last index of bone array)
		local NUBbuildPOS1 = newCTRLSArray[newCTRLSArray.count].pos
		local NUBbuildPOS2 = newCTRLSArray[newCTRLSArray.count-1].pos
		local freshNUB = BoneSys.createBone NUBbuildPOS1 NUBbuildPOS2 [0,0,1] --builds the nub from the last to the 2nd to last
		--
		append newBONESArray freshNUB
		--set nubBone properties
		setTransformLockFlags freshNUB #all
		freshNUB.name = uniqueName "nubBone"
		freshNUB.width = currentBoneSize
		freshNUB.height = currentBoneSize
		freshNUB.scale = [0.001,0.001,0.001]
		freshNUB.renderable = false
		freshNUB.boneFreezeLength = false
		freshNUB.wirecolor = currentBoneColor
		--push onto hidden layer
		local hiddenMakeLayerName = "SBC_zHidden"
		layermanager.newLayerFromName hiddenMakeLayerName
		local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
		Hiddenlayer.addnode freshNUB
		--
		--stretchy bones
		if stretchOrJoleanesType == "stretchy" then
		(
			--link up all bones including nubBone
			for i = 1 to newCTRLSArray.count do 
			(
				--link up bones
				if newBONESArray[i+1] != undefined then (newBONESArray[i+1].parent = newBONESArray[i])
			)
			--following loop constrains bones to ctrls	
			for i = 1 to newCTRLSArray.count do
			( 
				local posConstraintVariable = Position_Constraint()
				newBONESArray[i].pos.controller = posConstraintVariable
				local positionConstraintInterface = posConstraintVariable.constraints
				local tempCtrlArrayNum = newCTRLSArray[i]
				--local tempCtrlArrayNum = newCTRLSArray.count
				positionConstraintInterface.appendtarget tempCtrlArrayNum 100
			)
	 		--following loop adds lookAt controllers to bones to point at ctrls	
			for i = 1 to newCTRLSArray.count do
			(
				if newCTRLSArray[i+1] != undefined then 
				( 
					local lookAtConstraintVariable = lookAt_Constraint()
					newBONESArray[i].rotation.controller = lookAtConstraintVariable
					local positionConstraintInterface = lookAtConstraintVariable.constraints
					local tempCtrlArrayNum = newCTRLSArray[i+1]
					--local tempCtrlArrayNum = newCTRLSArray.count
					positionConstraintInterface.appendtarget tempCtrlArrayNum 100
					newBONESArray[i].rotation.controller.viewline_length_abs = off
				)
			)
			--set upnodes based on user input
			for i = 1 to newBONESArray.count do
			(
				lookAtConstraint = newBONESArray[i].rotation.controller = lookAt_constraint()
				case of
				(
					(currentBoneUpNode == [1,0,0]): newBONESArray[i].rotation.controller.upnode_axis = 0 --Xaxis upnode set
					(currentBoneUpNode == [0,1,0]): newBONESArray[i].rotation.controller.upnode_axis = 1 --Yaxis upnode set
					(currentBoneUpNode == [0,0,1]): newBONESArray[i].rotation.controller.upnode_axis = 2 --Zaxis upnode set
					default: newBONESArray[i].rotation.controller.upnode_axis = 2 --defaults to Z axis
				)
				if currentBoneUpNode == [1,1,1] then 
				(
					try if newBONESArray[i-1] != 0 then (newBONESArray[i].rotation.controller.upnode_world = off) catch()
					try newBONESArray[i].rotation.controller.pickUpNode = newBONESArray[i-1] catch()
				)
			)--end for
			--
		) else if stretchOrJoleanesType == "joleanes" then
		(
			--joleans bones
			--create script controllers for bones
			--add in variables to script controllers for object scene access
			--wrap all this in a try() block
			--**************************************************************************WIP
			
			$.rotation.controller = Euler_XYZ ()
			$.rotation.controller = TCB_rotation ()
			--
			
			
			--following loop adds lookAt controllers to bones to point at ctrls	
			for i = 1 to newBONESArray.count do
			(
				if newBONESArray[i+1] != undefined then 
				( 
									
					newBONESArray[i].rotation.controller.Z_Rotation.controller = float_script()
					newBONESArray[i].rotation.controller.Z_Rotation.controller.Available.controller = float_script()
					--
					
					/*
					$.rotation.controller = Euler_XYZ ()
					$.rotation.controller = TCB_rotation ()
					showClass "*:*controller*"
					*/
					
					(
					print "test"
					$.rotation.controller = float_script()
					print "test"
					local myRotationScript = "
					--
					print "test"
					--
											"
					$.rotation.controller.script = myRotationScript
					print "test"
					)
					
					
					
					
					--
					--define script for TCB/Quat rotation
					local myRotationScript = "
					--
					newBONESArray[i]
					--
					theTargetVector=(Target.transform.position * Inverse Parent.transform)-NodePos.value
					theAxis=Normalize (cross theTargetVector [1,0,0])
					theAngle=acos (dot (Normalize theTargetVector) [1,0,0])
					Quat theAngle theAxis"
					--
					
					--
					--assign the script to the obj
					newBONESArray[i].rotation.controller.Z_Rotation.controller[2].script = myRotationScript
					
					
					/*
					Now, to get the lookat rotation without the flipping, we're going to build up the quaternion using the AngAxis to Quat conversion. 
					If we do that we can rotate the bone from it's resting orientation to the desired lookat orientation, without getting that flip in 
					the 90 degrees Y-axis. It will only flip in that almost unreachable orientation (the bone overlaping its parent).
					
					This file has a 3ds max 2008 scene with 3 bones, and one point helper. Those are: Spine01, Spine02, Joint and Target 
					(the joint bone is used to keep the mesh volume). In this case we need the Spine02 to lookat the Target helper. 
					
					select the object "Spine02", go to the motion panel, select the rotation track and assign it a script rotation controller 
					Create a variable called "Target" and assign it the Target node 
					create a variable "Parent" and assign it the Spine01 node
					create a variable NodePos and assign it the "Spine02" position controller 
						-select the variable click "assign controller" find the Spine02 object, select the position track and press OK
					
					The code in the Expression Box will be as follows (replace the text that is already there):
					***********
					theTargetVector=(Target.transform.position * Inverse Parent.transform)-NodePos.value
					theAxis=Normalize (cross theTargetVector [1,0,0])
					theAngle=acos (dot (Normalize theTargetVector) [1,0,0])
					Quat theAngle theAxis
					***********
					In the first line we're Finding the vector that goes from the spine01 position to the target position, that vector must 
					be in respect to the spine01 parent, to get an orientation in parent space (the way that local controllers works). the 
					NodePos.value is already in parent space because that variable is referencing the local position controller of the spine01.
					
					In the second line we are finding the axis in which the node should rotate to aim that position, that vector is 
					perpendicular to the TargetVector and the x-axis (1,0,0)
					
					In the third line we're finding the amount of rotation needed to reach the desired rotation, that value is the angle 
					between the x-axis (1,0,0) and the TargetVector.
					
					In the Last line we build up our quaternion using the axis and the angle.
					*/
									
					
				)--end if
				
			













	
				
			)--end for	
		)
		
		--duplicate code for mirrored bone****
		--then build mirrored line 2nd
		for i = 1 to newCTRLSArrayMirror.count do
		(
			--check to see if i+1 is undefined, if true = end of bonechain
			if newCTRLSArrayMirror[i+1] != undefined then 
			(
				local buildPOS1 = newCTRLSArrayMirror[i].pos
				local buildPOS2 = newCTRLSArrayMirror[i+1].pos
				local freshBone = BoneSys.createBone buildPOS1 buildPOS2 [0,0,1] --upNode value:[0,0,1], Zaxis up default, 
				setTransformLockFlags freshBone #all
				if currentTypeOfBone == "BoxMode" then (freshBone.boxMode = true)
				freshBone.boneFreezeLength = false
				freshBone.wirecolor = currentBoneColor
				--set BONE SIZE
				freshBone.width = currentBoneSize
				freshBone.height = currentBoneSize
				--boneChainPrefix
				freshBone.name = "stretchyB" + i as string
				freshBone.name = freshBone.name + "M"
				freshBone.renderable = false
				--add new bones to bonesLayer
				local bonesMakeLayerName = "SBC_" + currentBoneLayerName
				layermanager.newLayerFromName bonesMakeLayerName
				local Boneslayer = layermanager.getLayerFromName bonesMakeLayerName
				BonesLayer.addnode freshBone
				append newBONESArrayMirror freshBone
			)  --end if
		)--end for
		--
		if newCTRLSArrayMirror[1] != undefined do
		(
			--build a nubBone after last bone (last index of bone array)
			local NUBbuildPOS1 = newCTRLSArrayMirror[newCTRLSArrayMirror.count].pos
			local NUBbuildPOS2 = newCTRLSArrayMirror[newCTRLSArrayMirror.count-1].pos
			local freshNUB = BoneSys.createBone NUBbuildPOS1 NUBbuildPOS2 [0,0,1]
			append newBONESArrayMirror freshNUB
			--set nubBone properties
			setTransformLockFlags freshNUB #all
			freshNUB.name = uniqueName "nubBone"
			freshNUB.name = freshNUB.name + "M"
			freshNUB.width = currentBoneSize
			freshNUB.scale = [0.001,0.001,0.001]
			freshNUB.height = currentBoneSize
			freshNUB.renderable = false
			freshNUB.boneFreezeLength = false
			freshNUB.wirecolor = currentBoneColor
			--push onto hidden layer
			local hiddenMakeLayerName = "SBC_zHidden"
			layermanager.newLayerFromName hiddenMakeLayerName
			local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
			Hiddenlayer.addnode freshNUB
			--
			--stretchy bones
			if stretchOrJoleanesType == "stretchy" then
			(
				--link up all bones including nubBone
				for i = 1 to newCTRLSArrayMirror.count do 
				(
					--link up bones
					if newBONESArrayMirror[i+1] != undefined then (newBONESArrayMirror[i+1].parent = newBONESArrayMirror[i])
				)
				--following loop constrains bones to ctrls	
				for i = 1 to newCTRLSArrayMirror.count do
				( 
					local posConstraintVariable = Position_Constraint()
					newBONESArrayMirror[i].pos.controller = posConstraintVariable
					local positionConstraintInterface = posConstraintVariable.constraints
					local tempCtrlArrayNum = newCTRLSArrayMirror[i]
					--local tempCtrlArrayNum = newCTRLSArray.count
					positionConstraintInterface.appendtarget tempCtrlArrayNum 100
				)
		 		--following loop adds lookAt controllers to bones to point at ctrls	
				for i = 1 to newCTRLSArrayMirror.count do
				(
					if newCTRLSArrayMirror[i+1] != undefined then 
					( 
						local lookAtConstraintVariable = lookAt_Constraint()
						newBONESArrayMirror[i].rotation.controller = lookAtConstraintVariable
						local positionConstraintInterface = lookAtConstraintVariable.constraints
						local tempCtrlArrayNum = newCTRLSArrayMirror[i+1]
						--local tempCtrlArrayNum = newCTRLSArray.count
						positionConstraintInterface.appendtarget tempCtrlArrayNum 100
						newBONESArrayMirror[i].rotation.controller.viewline_length_abs = off
					)
				) --end for
				--set upnodes based on user input
				for i = 1 to newBONESArrayMirror.count do
				(
					lookAtConstraint = newBONESArrayMirror[i].rotation.controller = lookAt_constraint()
					case of
					(
						(currentBoneUpNode == [1,0,0]): newBONESArrayMirror[i].rotation.controller.upnode_axis = 0 --Xaxis upnode set
						(currentBoneUpNode == [0,1,0]): newBONESArrayMirror[i].rotation.controller.upnode_axis = 1 --Yaxis upnode set
						(currentBoneUpNode == [0,0,1]): newBONESArrayMirror[i].rotation.controller.upnode_axis = 2 --Zaxis upnode set
						default: newBONESArrayMirror[i].rotation.controller.upnode_axis = 2 --defaults to Z axis
					)
					--
					if currentBoneUpNode == [1,1,1] then 
					(
						try if newBONESArrayMirror[i-1] != 0 then (newBONESArrayMirror[i].rotation.controller.upnode_world = off) catch()
						try newBONESArrayMirror[i].rotation.controller.pickUpNode = newBONESArrayMirror[i-1] catch()
					)	
					
				)--end for
				--
			) else if stretchOrJoleanesType == "joleanes" then
			(
				--joleans bones
				--create script controllers for bones
				--add in variables to script controllers for object scene access
				--wrap all this in a try() block
			)
			--
		)--end if check
	)--end "line" build
	--
	--
	if buildType == "addChild" then 
	(
		--CHILD
		--
		for i = 1 to newCTRLSArray.count do
		(
			local buildPOS1 = theCurrentOBJselected.pos
			local buildPOS2 = newCTRLSArray[i].pos
			local freshBone = BoneSys.createBone buildPOS1 buildPOS2 [0,0,1] --upnode****
			local nubBone = BoneSys.createBone buildPOS2 buildPOS1 [0,0,1] --upnode****
			nubBone.parent = freshBone --make nub parent of fresh bone
			freshBone.boneFreezeLength = false  --unfreeze the length
			--set BONE SIZEs
			freshBone.width = currentBoneSize
			freshBone.height = currentBoneSize
			nubBone.width = currentBoneSize
			nubBone.height = currentBoneSize
			nubBone.scale = [0.001,0.001,0.001]
			if currentTypeOfBone == "BoxMode" then (freshBone.boxMode = true;nubBone.boxMode = true)
			--inherit the bone color
			nubBone.wirecolor = currentBoneColor
			freshBone.wirecolor = currentBoneColor
			--stretchy check
			if stretchOrJoleanesType == "stretchy" then
			(
				--pos constrain fresh bone to original selected
				local posConstraintVariable = Position_Constraint()
				freshBone.pos.controller = posConstraintVariable
				local positionConstraintInterface = posConstraintVariable.constraints
				positionConstraintInterface.appendtarget theCurrentOBJselected 100
				--pos constrain nub to new ctrl
				local posConstraintVariable2 = Position_Constraint()
				nubBone.pos.controller = posConstraintVariable2
				local positionConstraintInterface = posConstraintVariable2.constraints
				local tempCtrlArrayNum = newCTRLSarray[i]
				positionConstraintInterface.appendtarget tempCtrlArrayNum 100
				--add lookAt constraints from freshBone to ctrl
				local lookAtConstraintVariable = lookAt_Constraint()
				freshBone.rotation.controller = lookAtConstraintVariable
				local positionConstraintInterface = lookAtConstraintVariable.constraints
				local tempCtrlArrayNum = newCTRLSarray[i]
				positionConstraintInterface.appendtarget tempCtrlArrayNum 100
				freshBone.rotation.controller.viewline_length_abs = off
				--
			) else if stretchOrJoleanesType == "joleanes" then
			(
				--joleans bones
				--create script controllers for bones
				--add in variables to script controllers for object scene access
				--wrap all this in a try() block
			)
			
			
			
			
			
			
			
			--lock nub and freshBone
			setTransformLockFlags freshBone #all
			setTransformLockFlags nubBone #all 
			--put fresh bone on right layer
			local bonesMakeLayerName = "SBC_" + currentBoneLayerName
			layermanager.newLayerFromName bonesMakeLayerName
			local Boneslayer = layermanager.getLayerFromName bonesMakeLayerName
			BonesLayer.addnode freshBone
			--rename freshBone to proper naming convention		
			freshBone.name = "stretchyB" + i as string --rename lastBone to proper naming convention
			freshBone.renderable = false --not renderable
			--put nubBone on hidden layer
			local hiddenMakeLayerName = "SBC_zHidden"
			layermanager.newLayerFromName hiddenMakeLayerName
			local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
			HiddenLayer.addnode nubBone
			--rename freshBone to proper naming convention		
			nubBone.name = "nubBone" + i as string --rename lastBone to proper naming convention
			nubBone.renderable = false --not renderable
			freeze nubBone
			--add in nub and fresh bone into bone unlinked array
			append newBONESArray freshBone --add last bone into unlinked array
			append newBONESArray nubBone --add last bone into unlinked array
			--set upnodes based on user input
			for i = 1 to newBONESArrayMirror.count do
			(
				lookAtConstraint = newBONESArray[i].rotation.controller = lookAt_constraint()
				case of
				(
					(currentBoneUpNode == [1,0,0]): newBONESArray[i].rotation.controller.upnode_axis = 0 --Xaxis upnode set
					(currentBoneUpNode == [0,1,0]): newBONESArray[i].rotation.controller.upnode_axis = 1 --Yaxis upnode set
					(currentBoneUpNode == [0,0,1]): newBONESArray[i].rotation.controller.upnode_axis = 2 --Zaxis upnode set
					default: newBONESArray[i].rotation.controller.upnode_axis = 2 --defaults to Z axis		
				)
				--
				if currentBoneUpNode == [1,1,1] then 
				(
					try if newBONESArray[i-1] != 0 then (newBONESArray[i].rotation.controller.upnode_world = off) catch()
					try newBONESArray[i].rotation.controller.pickUpNode = theCurrentOBJselected catch() --check this :(
				)
			)--end for
			--			
		) --end buildChildren for loop

	) --end of build check type
	--add new ctrls and bones arrays together into one array, newSBCchain
	join newSBCchain newCTRLSArray
	join newSBCchain newBONESArray
	--try to add the mirrors as well
	try join newSBCchainMirror newCTRLSArrayMirror catch()
	try join newSBCchainMirror newBONESArrayMirror catch()
	--call chainManager fn to finish up tasks
	chainManager()
),
--
fn buildCtrls =
(
	--build type: "line"=line, "addChild";
	--reset last chain made
	lastCreatedChain = #() --the last created chain, target for UNDO
	--variables local to this function
	local phelpSizeValue = currentControlSize*2
	--function logic below
	if buildType == "line" then 
	( --LINE
		--build a line
		for i = 1 to buildingHelpersArray.count do
		(
			if (currentTypeOfCtrl == "Spheres") then 
			(
			Sphere radius:currentControlSize smooth:on segs:10 chop:0 slice:off \
			sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
			pos:[(i*50-50),0,0] isSelected:on
			)
 			else if (currentTypeOfCtrl == "pHelpers") then
			(
			Point pos:[(i*50-50),0,0] isSelected:on size:phelpSizeValue
			$.Box = on
			$.drawontop = on
			)
			--get a handle on the selected object
			local theNewCTRL = $
			clearSelection()
			theNewCTRL.wirecolor = currentControlColor
			theNewCTRL.name = "ctrl" + i as string --unique name each ctrl
			theNewCTRL.renderable = false
			--put the ctrl into proper layer
			local ctrlsMakeLayerName = "SBC_" + currentCtrlLayerName
			layermanager.newLayerFromName ctrlsMakeLayerName  --make the ctrls layer
			local CTRLSlayer = layermanager.getLayerFromName ctrlsMakeLayerName
			CTRLSlayer.addnode theNewCTRL --add ctrl to user ctrl layer name
			CTRLSlayer.wirecolor = currentControlColor --set color for layer
			append newCTRLSArray theNewCTRL --add into array
		) --end buildLine for loop	
		--
		local mirroredCheck = false
		if mirrorC2CaxisXenabled == true then (mirroredCheck = true)
		if mirrorC2CaxisYenabled == true then (mirroredCheck = true)
		if mirrorC2CaxisZenabled == true then (mirroredCheck = true)
		if mirroredCheck == true then
		(
			--build an unmirrored line as well
			for i = 1 to buildingHelpersArrayMirrored.count do
			(
				if (currentTypeOfCtrl == "Spheres") then 
				(
				Sphere radius:currentControlSize smooth:on segs:10 chop:0 slice:off \
				sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
				pos:[(i*50-50),0,0] isSelected:on
				)
	 			else if (currentTypeOfCtrl == "pHelpers") then
				(
				Point pos:[(i*50-50),0,0] isSelected:on size:phelpSizeValue
				$.Box = on
				$.drawontop = on
				)
				--get a handle on the selected object
				local theNewCTRL = $
				clearSelection()
				theNewCTRL.wirecolor = currentControlColor
				theNewCTRL.name = "ctrl" + i as string --unique name each ctrl
				theNewCTRL.name = theNewCTRL.name + "M" --give unique ID to target later
				theNewCTRL.renderable = false
				--put the ctrl into proper layer
				local ctrlsMakeLayerName = "SBC_" + currentCtrlLayerName
				layermanager.newLayerFromName ctrlsMakeLayerName  --make the ctrls layer
				local CTRLSlayer = layermanager.getLayerFromName ctrlsMakeLayerName
				CTRLSlayer.addnode theNewCTRL --add ctrl to user ctrl layer name
				CTRLSlayer.wirecolor = currentControlColor --set color for layer
				append newCTRLSArrayMirror theNewCTRL --add into mirrored array
			) --end buildLine for loop
		)
	) else if buildType == "addChild" then
	( --CHILD
		--put $ into a variable to use later
		theCurrentOBJselected = $
		clearSelection()
		--build children onto selected
		local rotationMultiplierVAL = 360/(currentNumOfControlsToMake)
		local originallySelected = theCurrentOBJselected
		local selectedsPosition = theCurrentOBJselected.pos
		local offsetSelectedsPosition = selectedsPosition + [0,0,100]
		for i = 1 to currentNumOfControlsToMake do
		(
			if (currentTypeOfCtrl == "Spheres") then 
				(
				Sphere radius:currentControlSize smooth:on segs:10 chop:0 slice:off \
				sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
				pos:offsetSelectedsPosition isSelected:on
				)
 			else if (currentTypeOfCtrl == "pHelpers") then
				(
				Point pos:offsetSelectedsPosition isSelected:on size:phelpSizeValue
				$.Box = on
				$.drawontop = on
				)	
			--get a handle on the selected object
			local theNewCTRL = $
			clearSelection()			
			theNewCTRL.wirecolor = currentControlColor
			theNewCTRL.pivot=selectedsPosition  --offsets pivot so you can rotate $
			--
			local rotateVal = i*rotationMultiplierVAL
			rotate theNewCTRL rotateVal y_axis
			resetPivot theNewCTRL
			theNewCTRL.name = "ctrl" + i as string --unique name each ctrl
			theNewCTRL.renderable = false
			--put the ctrl into proper layer
			local ctrlsMakeLayerName = "SBC_" + currentCtrlLayerName  --get user input ctrl layer name
			layermanager.newLayerFromName ctrlsMakeLayerName  --make the ctrls layer
			local CTRLSlayer = layermanager.getLayerFromName ctrlsMakeLayerName
			CTRLSlayer.addnode theNewCTRL --add ctrl to user ctrl layer name
			CTRLSlayer.wirecolor = currentControlColor --set color for layer
			append newCTRLSArray theNewCTRL --add into array
		) --end buildChildren for loop
	)		
	--call buildBONES fn
	buildBones()
),
--
































fn clickToCreateLine = 
(
	local P1 = pickpoint prompt:"Click to create enabled..."
	format "\n%\n" P1
	if classOf P1 == Point3 then --captureUserInput if
	(
		--if the user clicked, build a pHelper at the click point
		Point pos:P1 isSelected:on size:currentC2CpHelpersSize
		--assign random name to pHelper, so you don't get name overlap with scene objs
		$.name = uniqueName "pBuilder_" + (random 1.1 1000000) as string
		$.box = true
		$.wirecolor = [255,255,255]
		join buildingHelpersArray $ 
		--
		--check to see if mirror is enabled
		if mirrorC2CaxisXenabled == true then ( --mirror the X axis
			--capture mirrored click position
			mirrorXP1 = (P1 * [-1,1,1]) --THIS DETERMINES WHAT AXIS IS MIRRORED
			Point pos:mirrorXP1 isSelected:on size:currentC2CpHelpersSize --if the user clicked, build a pHelper at the click point
			chainIsMirrored = true
		) else if mirrorC2CaxisYenabled == true then ( --mirror the Y axis
			--capture mirrored click position
			mirrorYP1 = (P1 * [1,-1,1]) --THIS DETERMINES WHAT AXIS IS MIRRORED
			Point pos:mirrorYP1 isSelected:on size:currentC2CpHelpersSize --if the user clicked, build a pHelper at the click point
			chainIsMirrored = true
		) else if mirrorC2CaxisZenabled == true then ( --mirror the Z axis
			--capture mirrored click position
			mirrorZP1 = (P1 * [1,1,-1]) --THIS DETERMINES WHAT AXIS IS MIRRORED
			Point pos:mirrorZP1 isSelected:on size:currentC2CpHelpersSize --if the user clicked, build a pHelper at the click point
			chainIsMirrored = true
		) else (chainIsMirrored = false)
		--
		if chainIsMirrored == true then
		(
			--assign random name to pHelper, so you don't get name overlap with scene objs
			$.name = uniqueName "pBuilder_" + (random 1.1 1000000) as string
			$.box = true
			$.wirecolor = [255,255,255]
			join buildingHelpersArrayMirrored $
		)
		--call fn from inside fn
		clickToCreateLine()
	) else if P1 == #rightClick then --build CTRLS and BONES to pHelpers.pos
	(
		--check to see if buildingHelpersArray is greater than 1 helper, otherwise you can't build a bone
		if buildingHelpersArray.count >= 2 then 
		(
			--check to see if the mesh object exists, otherwise you can't skin or project
			if isValidNode theMeshObjectPicked then (print "...") else (print "You have not selected a mesh to project upon.  Projection will not happen.")
			--put buildingHelpersArray.count into ctrlsArray
			local numOfPhelpers = buildingHelpersArray.count
			--
			buildCTRLS() --this calls entire SBC process, ends with chainManager and lastCreatedChain
			--after boneChain is created, take the 1st ctrl and align it to the 1st pHelper and so on
			--target lastBoneChain array			
			for i = 1 to numOfPhelpers do
			(
				--ctrls are always first in array, ctrls num = pHelpers num
				--make each ctrl.pos equal to pHelpers.pos
				try lastCreatedChain[i].pos = buildingHelpersArray[i].pos catch()		
			)
			--
			if chainIsMirrored == true then 
			(
				--build mirror
				--target lastBoneChain array			
				for i = 1 to numOfPhelpers do
				(
					--ctrls are always first in array, ctrls num = pHelpers num
					--make each ctrl.pos equal to pHelpers.pos
					lastCreatedChainMirror[i].pos = buildingHelpersArrayMirrored[i].pos	
				)
			) --end mirror check
			--
			for i = 1 to numOfPhelpers do (delete buildingHelpersArray[i])
			--
			if chainIsMirrored == true then 
			(
				--delete pHelpers in mirrored mode
				for i = 1 to numOfPhelpers do (delete buildingHelpersArrayMirrored[i])
			) --end mirror check
			--
			if autoProject then 
			(
				--
				local paddedSelectionArray = #(0)
				join paddedSelectionArray lastCreatedChain
				local paddedSelectionArrayMirror = #(0)
				try join paddedSelectionArrayMirror lastCreatedChainMirror catch()
				--
				projectSelected paddedSelectionArray theMeshObjectPicked currentProjectAxis
				try projectSelected paddedSelectionArrayMirror theMeshObjectPicked currentProjectAxis catch()
			)			
			--
			if autoSkinValue then 
			(
				autoSkin()
			)
			--clear out the arrays
			buildingHelpersArray = #() --reset the buildingHelpersArray for next batch
			buildingHelpersArrayMirrored = #() --set the mirror array empty too
		) else (
			--delete pHelpers
			for i = 1 to buildingHelpersArray.count do (try delete buildingHelpersArray[i] catch())
			for i = 1 to buildingHelpersArray.count do (try delete buildingHelpersArrayMirrored[i] catch())
			--clearArrays
			buildingHelpersArray = #() --clear out the array if the user input is invalid
			buildingHelpersArrayMirrored = #() --set the mirror array empty too
			--error
			messagebox "Canceled. You need to make at least two clicks to build a bone."
		) --end outer if/else
	) else if P1 == #escape then 
	(
		local numOfPhelpers = buildingHelpersArray.count
		--delete each pHelper in array
		for i = 1 to buildingHelpersArray.count do (try delete buildingHelpersArray[i] catch())	
		for i = 1 to buildingHelpersArray.count do (try delete buildingHelpersArrayMirrored[i] catch())
		--empty out the buildingHelpersArray for next batch
		buildingHelpersArray = #()
		buildingHelpersArrayMirrored = #()
		--error
		messagebox "Canceled by User."
	) else if P1 == undefined then
	(
		local numOfPhelpers = buildingHelpersArray.count
		--delete each pHelper in array
		for i = 1 to buildingHelpersArray.count do (try delete buildingHelpersArray[i] catch())	
		for i = 1 to buildingHelpersArray.count do (try delete buildingHelpersArrayMirrored[i] catch())
		--empty out the buildingHelpersArray for next batch
		buildingHelpersArray = #()
		buildingHelpersArrayMirrored = #()
		--error
		messagebox "Canceled by User."
	)
),
--



















fn undoLastChain = 
(
	try delete lastCreatedChain catch()
	try delete lastCreatedChainMirror catch()
	lastCreatedChain = #()
	lastCreatedChainMirror = #()
),
--
fn deleteSelectedChain = 
(
	--is the selected object a validNode, if true...
	if IsValidNode $ then 
	(
		--get naming convention of selected using string parse
		--find all other objects with the same naming convention
		--delete all other objects with the same naming convention
		local tokenStringVar = ":"
		local SelectedObjectStringArrayIndex = $ as string
		characterSplitVAR = filterString SelectedObjectStringArrayIndex tokenStringVar
		--print ": character split"
		--print characterSplitVAR[1]
		--print characterSplitVAR[2]
		--print characterSplitVAR[3] --[3] will be undefined for non SBC chains
		if characterSplitVAR[3] == undefined then 
		(print "The selected object is not recognized by StretchyBonesCreator.  Will attempt to delete anyways.")
		--get length of [2] by count
		local lengthOfcharacterSplitVAR2 = characterSplitVAR[2].count
		local NamingConventionOfSelectedsName = substring characterSplitVAR[2] 1 lengthOfcharacterSplitVAR2
		--select all the boneChains
		select $SBChain*
		local selectionAsArray = selection as array
		--print "all SBchains selected as:"
		--print selectionAsArray
		for i=1 to selectionAsArray.count do --for the total do
			(
			--turn each array index into a string
			local selectionsIndexAsString = selectionAsArray[i] as string
			--<integer>findString <string> <search_string>
			--returns num index if true, undefined if false
			local matchingStringNamingConvention = findString selectionsIndexAsString NamingConventionOfSelectedsName
			if matchingStringNamingConvention != undefined do
				(
				select selectionAsArray[i]
				--print "match found:"
				--print selectionAsArray[i]
				delete $
				)						
			)	
	) else (messagebox "Please select a ctrl or bone in a bonechain to delete.")
),
--
fn resetSBC = 
(
	--try
	--(
		--delete all bone chains and CTRLS made by SBC from the scene
		unfreeze $SBC*
		delete $SBC* --deletes all objects with the following naming convention
		--check other layers for SBC naming convention
		local layersToDeleteArray = #()
		for i = 0 to layerManager.count do 
		(
			if (layermanager.getlayer i) != undefined do 
			(
				local firstLayer = layermanager.getlayer i
				local firstLayerName = firstLayer.name
				local checkLayersForSBC = substring firstLayerName 1 4 --parse firstLayerName
				if checkLayersForSBC == "SBC_" do --if match SBC_, delete
				(
					--fix
					layerRT = firstLayer.layerAsRefTarg
					local myRefs = refs.dependents layerRT
					if myRefs != undefined then 
					try (for j = 1 to myRefs.count do (if isValidNode myRefs[j] then delete myRefs[j])) catch()
					layerManager.deleteLayerByName firstLayerName
				)
			)
		)
	--) catch()

),
--
fn projectSelected theSelection theObjToStickTo theAxisAlong = 
(
	--set axis
	local chosenAxis
	case of
		(
		(theAxisAlong == "x"): chosenAxis = [1,0,0]
		(theAxisAlong == "y"): chosenAxis = [0,1,0]
		(theAxisAlong == "z"): chosenAxis = [0,0,1]
		default: print "projectSelected function can't see theAxisAlong variable."
		)
	--shoot 'theSelection' at 'theObjToStickTo' along the 'chosenAxis'
	for i = 2 to theSelection.count do --skip the padded 0 array[1] value
		(
		--code ray search section here
		local rayToMeshPositive = ray theSelection[i].pos chosenAxis --
		local rayToMeshNegative = ray theSelection[i].pos -chosenAxis --
		local intersectPositive = intersectRay theObjToStickTo rayToMeshPositive --
		local intersectNegative = intersectRay theObjToStickTo rayToMeshNegative --
		--
		local positionCHECKvar = 100 --100 value means no rays intersect, 101=negative, 110=positive, 111=both
		--
		if intersectPositive != undefined then (positionCHECKvar += 10)
		if intersectNegative != undefined then (positionCHECKvar += 1)	
		if positionCHECKvar == 100 then (print "projectSelected's rays did not intersect with mesh.")
		if positionCHECKvar == 101 then 
			(--figure out which axis to use
			case of
				(
				(theAxisAlong == "x"): theSelection[i].pos.x = intersectNegative.pos.x
				(theAxisAlong == "y"): theSelection[i].pos.y = intersectNegative.pos.y
				(theAxisAlong == "z"): theSelection[i].pos.z = intersectNegative.pos.z
				default: print "no hit on negative"
				)
			)--end if
		if positionCHECKvar == 110 then 
			(--figure out which axis to use
			case of
				(
				(theAxisAlong == "x"): theSelection[i].pos.x = intersectPositive.pos.x
				(theAxisAlong == "y"): theSelection[i].pos.y = intersectPositive.pos.y
				(theAxisAlong == "z"): theSelection[i].pos.z = intersectPositive.pos.z
				default: print "no hit on positive"
				)
			)--end if
		if positionCHECKvar == 111 then
			(	--get absolute values
				local negCHECK
				local posCHECK
				if theAxisAlong == "x" then 
				(negCHECK = (abs(abs(intersectNegative.pos.x) - abs(theSelection[i].pos.x)))
				posCHECK = (abs(abs(intersectPositive.pos.x) - abs(theSelection[i].pos.x))))
				if theAxisAlong == "y" then 
				(negCHECK = (abs(abs(intersectNegative.pos.y) - abs(theSelection[i].pos.y)))
				posCHECK = (abs(abs(intersectPositive.pos.y) - abs(theSelection[i].pos.y))))
				if theAxisAlong == "z" then 
				(negCHECK = (abs(abs(intersectNegative.pos.z) - abs(theSelection[i].pos.z)))
				posCHECK = (abs(abs(intersectPositive.pos.z) - abs(theSelection[i].pos.z))))
				--
				if posCHECK < negCHECK then
				(--figure out which axis to use
					case of
						(
						(theAxisAlong == "x"): theSelection[i].pos.x = intersectPositive.pos.x
						(theAxisAlong == "y"): theSelection[i].pos.y = intersectPositive.pos.y
						(theAxisAlong == "z"): theSelection[i].pos.z = intersectPositive.pos.z
						default: print "projectSelected errored out... pos"
						)
				) else if posCHECK > negCHECK then
				(--figure out which axis to use
					case of
						(
						(theAxisAlong == "x"): theSelection[i].pos.x = intersectNegative.pos.x
						(theAxisAlong == "y"): theSelection[i].pos.y = intersectNegative.pos.y
						(theAxisAlong == "z"): theSelection[i].pos.z = intersectNegative.pos.z
						default: print "projectSelected errored out... neg"
						)
				)
			)--end if
		--
		) --end for loop
),
--
fn linkOneToOne incomingSelectedOBJtoShrink ParentObjectSelected = 
(
	incomingSelectedOBJtoShrink.pos = ParentObjectSelected.pos
	incomingSelectedOBJtoShrink.parent = ParentObjectSelected
	incomingSelectedOBJtoShrink.scale = [0.5,0.5,0.5]
	freeze incomingSelectedOBJtoShrink
	--
	layermanager.newLayerFromName "SBC_zHidden"
	local Hiddenlayer = layermanager.getLayerFromName "SBC_zHidden"
	Hiddenlayer.addnode incomingSelectedOBJtoShrink
	hide incomingSelectedOBJtoShrink
	Hiddenlayer.isHidden = true
	Hiddenlayer.isFrozen = true
	--
	clearSelection()
	select ParentObjectSelected
),
--
fn autoSkin = 
(
	--
	--determine if mesh has a skin modifier applied to it, if so, add bones into that skin modifier
	--if the mesh doesn't have a skin modifier, then run the quickSkin fn on it, then add bones into new skin modifier
	--	
	--check the skin mod
	local skinCheckValue = theMeshObjectPicked.modifiers[#Skin]
	--if the skin mod exists, then...
	if skinCheckValue != undefined then
	(
		for i = 1 to lastCreatedChain.count do 
		(
			local newStretchyBones = undefined
			local lastChainCheck = lastCreatedChain[i] as string
			newStretchyBones = findString lastChainCheck "stretchyB"
			if newStretchyBones != undefined then 
			(
			try (modPanel.setCurrentObject theMeshObjectPicked.modifiers[#Skin]) catch()
			try (skinOps.addBone theMeshObjectPicked.modifiers[#Skin] lastCreatedChain[i] 1) catch()
			try (skinOps.addBone theMeshObjectPicked.modifiers[#Skin] lastCreatedChainMirror[i] 1) catch()
			--print "auto skin complete... didn't skin?  does the mesh have a skin modifier applied to it?"
			)
		)
	)
	--if the skin mod isn't there...
	if skinCheckValue == undefined then
	(
		--select theMeshObjectPicked
		--modPanel.addModToSelection (Skin ()) ui:on
		if quickSkin() then
		(
			for i = 1 to lastCreatedChain.count do 
			(
				local newStretchyBones = undefined
				local lastChainCheck = lastCreatedChain[i] as string
				newStretchyBones = findString lastChainCheck "stretchyB"
				if newStretchyBones != undefined then 
				(
				try (modPanel.setCurrentObject theMeshObjectPicked.modifiers[#Skin]) catch()
				try (skinOps.addBone theMeshObjectPicked.modifiers[#Skin] lastCreatedChain[i] 1) catch()
				try (skinOps.addBone theMeshObjectPicked.modifiers[#Skin] lastCreatedChainMirror[i] 1) catch()
				--print "auto skin complete... didn't skin?  does the mesh have a skin modifier applied to it?"
				)
			)
		)
	)
	
	
	
	--IDEA
	--is there a way to flood the weights in the skin mod using math, possibly by averaging neighboring vert weights?
	--
	/*
	modPanel.setCurrentObject theMeshObjectPicked.modifiers[#Skin]
	local theMeshsVertCount = skinOps.GetNumberVertices theMeshObjectPicked.modifiers[#Skin]
	for i = 1 to theMeshsVertCount do
	(
		skinOps.GetVertexWeight theMeshObjectPicked.modifiers[#Skin] [i] <vertex_bone_integer>
		--Returns the influence of the Nth bone affecting the specified vertex.
		skinOps.GetVertexWeightCount theMeshObjectPicked.modifiers[#Skin] [i]
		--Returns the number of bones influencing the specified vertex.
	)
	*/
	--
	clearSelection()

),
--








fn quickSkin = 
(
	try 
	(
	local objToQuickSkinBBsize = theMeshObjectPicked.max - theMeshObjectPicked.min
	--build a helper box to the BB of the object
	quickSkinBBboxHelper = Box lengthsegs:1 widthsegs:1 heightsegs:1 \
	length:objToQuickSkinBBsize[2] width:objToQuickSkinBBsize[1] height:objToQuickSkinBBsize[3] \
	mapcoords:on pos:[0,0,0] isSelected:off
	CenterPivot quickSkinBBboxHelper
	quickSkinBBboxHelper.pos = theMeshObjectPicked.pos
	quickSkinBBboxHelper.renderable = off
	quickSkinBBboxHelper.boxmode = on
	quickSkinBBboxHelper.name = "SBC_meshCTRL"
	--put the meshctrl into proper layer
	local meshctrlsMakeLayerName = "SBC_meshCTRL"
	layermanager.newLayerFromName meshctrlsMakeLayerName  --make the ctrls layer
	local meshCTRLSlayer = layermanager.getLayerFromName meshctrlsMakeLayerName
	meshCTRLSlayer.addnode quickSkinBBboxHelper --add ctrl to user ctrl layer name
	--
	convertToMesh quickSkinBBboxHelper
	--add in the skin modifier to objToQuickSkin and set all weights to quickSkinBBboxHelper
	select theMeshObjectPicked
	modPanel.addModToSelection (Skin ()) ui:on
	skinOps.addBone theMeshObjectPicked.modifiers[#Skin] quickSkinBBboxHelper 1
	theMeshObjectPicked.modifiers[#Skin].cross_radius = 20
	theMeshObjectPicked.modifiers[#Skin].filter_vertices = on
	subobjectLevel = 1
	theMeshObjectPicked.modifiers[#Skin].mirrorEnabled = off
	clearSelection()
	return true
	) catch (messagebox "Error:quickSkin fn")
),
--
fn skinWeightsToggle =
(
	local skinWeightsToggleValue = undefined
	--
	try
	(
	skinOps.weightTool theMeshObjectPicked.modifiers[#Skin]
	subobjectLevel = 0 --close
	theMeshObjectPicked.modifiers[#Skin].mirrorEnabled = off
	skinWeightsToggleValue = "closed"
	) catch()
	--
	if skinWeightsToggleValue != "closed" then 
	(
		try
		(
		/*
		skinOps.isWeightToolOpen <Skin>
		--Returns 1 if the Weight Tool of the specified Skin modifier is open, 0 if it is closed.
		*/

		unfreeze theMeshObjectPicked --unfreeze mesh
		modPanel.setCurrentObject theMeshObjectPicked.modifiers[#Skin]
		skinOps.weightTool theMeshObjectPicked.modifiers[#Skin]
		subobjectLevel = 1 --open
		theMeshObjectPicked.modifiers[#Skin].mirrorEnabled = off
		) catch(messagebox "Weight Toggle had a problem.  Try again.")
	)
)
) --close struct definition











--declare structInstance in script scope, so clickToCreateLine can call itself (recursion)
local stretchyBonesCreatorStructInstance = stretchyBonesCreatorStruct()












































--UI
rollout SBCcontainerRollout " Stretchy Bones Creator v2.2"
(subrollout SBC_SUB) --end SBCcontainer rollout
--
rollout SBCpickedMesh "The Mesh or Poly Object to skin and project onto:    "
(
	--UI
	pickbutton SBCtheMeshBTN "The Mesh" pos:[10,5] width:262 height:30 autoDisplay:true
	--EVENTS
	on SBCtheMeshBTN picked obj do 
	(
		if isValidNode obj do 
		(
			theMeshObjectPicked = SBCtheMeshBTN.object
		)
	)
) --end SBCpickedMesh rollout
--
rollout ctrlOptions "Ctrl Options                                                                "
(
	--UI
	radioButtons ctrlTypeBTN "" pos:[5,5] width:180 height:16 labels:#("Spheres", "P.Helpers") columns:2 default:1
	colorPicker ctrlColorPicker "" pos:[230,6] width:45 height:16 color:(color 0 114 255)
	spinner ctrlSizeSPN "Size: " pos:[168,6] width:50 height:16 type:#float range:[0.01,10000,1]
	label layerLabel "Layer:" pos:[7,32] width:80 height:17
	editText ctrlsLayerNameEditText "" pos:[40,31] width:235 height:17 text:"controls"
	--EVENTS
	on ctrlTypeBTN changed theState do 
	(
		if ctrlTypeBTN.state == 1 then (currentTypeOfCtrl = "spheres")
		if ctrlTypeBTN.state == 2 then (currentTypeOfCtrl = "pHelpers")
	)
	on ctrlColorPicker changed theState do (currentControlColor = ctrlColorPicker.color)
	on ctrlSizeSPN entered do (currentControlSize = ctrlSizeSPN.value)
	on ctrlsLayerNameEditText changed theState do (currentCtrlLayerName = ctrlsLayerNameEditText.text)
) --end ctrl options rollout
--
rollout boneOptions "Bone Options                                                            "
(
	--UI
	radioButtons boneTypeBTN "" pos:[5,5] width:158 height:16 labels:#("Bone", "BoxMode") columns:2
	colorPicker boneColorPicker "" pos:[230,6] width:45 height:16 color:(color 114 114 114)
	spinner boneSizeSPN "Size: " pos:[168,6] width:50 height:16 type:#float range:[0.01,10000,1]
	label layerLabel "Layer:" pos:[7,32] width:80 height:17
	editText bonesLayerNameEditText "" pos:[40,31] width:235 height:17 text:"bones"
	--
	label upnodeLabel "UpNode:" pos:[43,56] width:200 height:17
	checkbox upnodeXCheck "X" checked:false pos:[95,55]
	checkbox upnodeYCheck "Y" checked:false pos:[125,55]
	checkbox upnodeZCheck "Z" checked:true pos:[155,55]
	checkbox upnodeLastCheck "Parent Bone" checked:false pos:[185,55]
	--	
	checkbox autoProjectCheck " AutoStick and Skin" checked:false pos:[43,75]	
	--EVENTS
	on upnodeXCheck changed theState do 
	(
		currentBoneUpNode = [1,0,0]
		upnodeYCheck.checked=false
		upnodeZCheck.checked=false
		upnodeLastCheck.checked=false
		try upnodeXCheck.checked=true catch()
	)
	on upnodeYCheck changed theState do 
	(
		currentBoneUpNode = [0,1,0]
		upnodeXCheck.checked=false
		upnodeZCheck.checked=false
		upnodeLastCheck.checked=false
		try upnodeYCheck.checked=true catch()
	)
	on upnodeZCheck changed theState do 
	(
		currentBoneUpNode = [0,0,1]
		upnodeXCheck.checked=false
		upnodeYCheck.checked=false
		upnodeLastCheck.checked=false
		try upnodeZCheck.checked=true catch()
	)
	on upnodeLastCheck changed theState do 
	(
		currentBoneUpNode = [1,1,1] --special case denoting lastBone
		upnodeXCheck.checked=false
		upnodeYCheck.checked=false
		upnodeZCheck.checked=false
		try upnodeLastCheck.checked=true catch()
	)
	--	
	--
	on autoProjectCheck changed theState do (autoProject = theState;autoSkinValue = theState)
	on boneTypeBTN changed theState do 
	(
		if boneTypeBTN.state == 1 then (currentTypeOfBone = "Bone")
		if boneTypeBTN.state == 2 then (currentTypeOfBone = "BoxMode")
	)
	on boneColorPicker changed theState do (currentBoneColor = boneColorPicker.color)
	on boneSizeSPN entered do (currentBoneSize = boneSizeSPN.value)
	on bonesLayerNameEditText entered theState do (currentBoneLayerName = bonesLayerNameEditText.text;print currentBoneLayerName)
	
) --end boneOptions rollout
--
rollout createOptions "Create Options                                                          "
(
	--UI
	button clickToCreateBTN "Enable Click to Create Line" pos:[5,5] width:180 height:50
	groupBox mirrorOptionsGrp "Mirror:" pos:[204,2] width:70 height:80
	checkbox XmirrorCheck "X axis" checked:false pos:[215,20]
	checkbox YmirrorCheck "Y axis" checked:false pos:[215,40]
	checkbox ZmirrorCheck "Z axis" checked:false pos:[215,60]
	spinner CtoCpHelperSizeSPN "pHelper Size:  " pos:[45,65] width:95 height:16 range:[0.001,1000000,1] type:#float
	label separatorLabel "-----------------------------------------------------------------------------------------" pos:[7,82] width:300 height:17
	--
	spinner numOfCTRLStoMakeSPN "# of CTRLs to make:  " pos:[70,97] width:95 height:16 range:[1,20,5] type:#integer
	button addChildrenBTN "ADD # of ctrls to selected" pos:[5,120] width:270 height:24
	--EVENTS 
	on XmirrorCheck changed theState do 
	(
		mirrorC2CaxisXenabled = theState
		YmirrorCheck.checked=false;ZmirrorCheck.checked=false
		mirrorC2CaxisYenabled=false;mirrorC2CaxisZenabled=false
	)
	on YmirrorCheck changed theState do 
	(
		mirrorC2CaxisYenabled = theState;XmirrorCheck.checked=false;ZmirrorCheck.checked=false
		XmirrorCheck.checked=false;ZmirrorCheck.checked=false
		mirrorC2CaxisXenabled=false;mirrorC2CaxisZenabled=false
	)
	on ZmirrorCheck changed theState do 
	(
		mirrorC2CaxisZenabled = theState;YmirrorCheck.checked=false;XmirrorCheck.checked=false
		YmirrorCheck.checked=false;XmirrorCheck.checked=false
		mirrorC2CaxisYenabled=false;mirrorC2CaxisXenabled=false
	)
	on CtoCpHelperSizeSPN entered do (currentC2CpHelpersSize = CtoCpHelperSizeSPN.value)
	on numOfCTRLStoMakeSPN entered do (currentNumOfControlsToMake = numOfCTRLStoMakeSPN.value)
	on clickToCreateBTN pressed do (buildType="line";stretchyBonesCreatorStructInstance.clickToCreateLine())
	on addChildrenBTN pressed do 
	(
		if isValidNode $ then
		(
			buildType="addChild"
			stretchyBonesCreatorStructInstance.buildCtrls()
		) else (messagebox "Please select an object to add ctrls to.")
	)
) --end createOptions rollout
--
rollout deleteOptions "Undo, Delete, Reset                                                 "
(
	--UI
	button UNDOBTN "UNDO last chain" pos:[5,5] width:120 height:53
	button deleteSelectedBTN "DELETE selected chain" pos:[135,5] width:140 height:24
	button resetSBCbtn "RESET SBC" pos:[194,40] width:80 height:19
	--EVENTS
	--
	on resetSBCbtn pressed do (stretchyBonesCreatorStructInstance.resetSBC())
	on UNDOBTN pressed do (stretchyBonesCreatorStructInstance.undoLastChain())
	on deleteSelectedBTN pressed do (stretchyBonesCreatorStructInstance.deleteSelectedChain())
) --end deleteOptions rollout
--
rollout weldOptions "Weld Ctrls                                                                "
(
	--UI
	button linkSelectedBTN "weld selected CTRL" pos:[5,5] width:130 height:24
	label lbl2 "to:" pos:[144,10] width:17 height:17
	pickbutton linkSingle2ParentBTN "CTRL" pos:[164,5] width:110 height:24
	--EVENTS
	--fn linkOneToOne incomingSelectedOBJtoShrink ParentObjectSelected
	on linkSelectedBTN pressed do (try stretchyBonesCreatorStructInstance.linkOneToOne $ linkSingle2ParentBTN.object catch())
) --end weldOPtions rollout
--
rollout projectOptions "Project Options                                                         "
(
	--UI
	button projectStickBTN "Click to project selected CTRLs or OBJs" pos:[5,5] tooltip:"Press to stick it." width:270
	label lbl3 "along World" pos:[10,37] width:140 height:16
	radioButtons axisToProjectRDO "" pos:[78,38] width:120 height:16 labels:#("X", "Y", "Z") columns:3 default:2
	label lbl4 "axis onto The Mesh" pos:[175,37] width:140 height:16
	--EVENTS
	--
	on projectStickBTN pressed do 
	(
		--check to see if obj to stick to is valid node
			--setup params out
			--put selection into array with padded 0 value
			local selectionAsArray = selection as array
			local paddedSelectionArray = #(0)
			join paddedSelectionArray selectionAsArray
			--check to see which axis to project onto
			if axisToProjectRDO.state == 1 then
				(
				currentProjectAxis = "x"
				stretchyBonesCreatorStructInstance.projectSelected paddedSelectionArray theMeshObjectPicked currentProjectAxis --project onto X
			) else if axisToProjectRDO.state == 2 then
				(
				currentProjectAxis = "y"
				stretchyBonesCreatorStructInstance.projectSelected paddedSelectionArray theMeshObjectPicked currentProjectAxis --project onto Y
			) else if axisToProjectRDO.state == 3 then
				(
				currentProjectAxis = "z"
				stretchyBonesCreatorStructInstance.projectSelected paddedSelectionArray theMeshObjectPicked currentProjectAxis --project onto Z
			)
	) --end on

) --end project rollout
--
rollout skinOptions "Skinning Options                                                       "
(
	--UI
	button quickSkinBTN "QuickSkin The Mesh" pos:[5,5] width:270 height:20
	--
	button meshXrayToggleBTN "Xray" pos:[5,28] width:65 height:24
	button turboSmoothToggleBTN "T.Smooth" pos:[73,28] width:65 height:24
	button freezeToggleBTN "Freeze" pos:[142,28] width:65 height:24
	button toggleSkinBTN "Weights" pos:[210,28] width:65 height:24
	--
	button launchBTN "Launch GrakScripts" pos:[5,55] width:252 height:20
	on launchBTN pressed do	(try(fileIn "grakscripts.ms")catch(messagebox "Cannot find GrakScripts.ms"))
	button whoIsBTN "?" pos:[260,55] width:15 height:20
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
	
	--EVENTS
	--
	on freezeToggleBTN pressed do 
	(
		if theMeshObjectPicked != undefined then (
			--toggle freeze
			if theMeshObjectPicked.isNodeFrozen != true then (freeze theMeshObjectPicked) else (unfreeze theMeshObjectPicked)
		) else (messagebox "Please pick a mesh to use QuickSkin on.")
	)--end on
	--
	on meshXrayToggleBTN pressed do 
	(
		if theMeshObjectPicked != undefined then (
			--toggle xray mode
			if theMeshObjectPicked.xray == true then (theMeshObjectPicked.xray = false) else (theMeshObjectPicked.xray = true)
		) else (messagebox "Please pick a mesh to use QuickSkin on.")
	)--end on
	--
	on turboSmoothToggleBTN pressed do 
	(
		if theMeshObjectPicked != undefined then (
			try 
			(
				modPanel.setCurrentObject theMeshObjectPicked.modifiers[#TurboSmooth]
				theMeshObjectPicked.modifiers[#TurboSmooth].useRenderIterations = true
				theMeshObjectPicked.modifiers[#TurboSmooth].isolineDisplay = true
				if theMeshObjectPicked.modifiers[#TurboSmooth].iterations >= 1 then
				(
					theMeshObjectPicked.modifiers[#TurboSmooth].iterations = 0
				) else if theMeshObjectPicked.modifiers[#TurboSmooth].iterations == 0 then
				(
					theMeshObjectPicked.modifiers[#TurboSmooth].iterations = 1
				)
				clearSelection()
	
			) catch (
						select theMeshObjectPicked
						modPanel.addModToSelection (TurboSmooth ()) ui:on
						clearSelection()
						theMeshObjectPicked.modifiers[#TurboSmooth].useRenderIterations = true
						theMeshObjectPicked.modifiers[#TurboSmooth].isolineDisplay = true
						theMeshObjectPicked.modifiers[#TurboSmooth].iterations = 1
						theMeshObjectPicked.modifiers[#TurboSmooth].renderIterations = 2
						clearSelection()
					)
					
		) else (messagebox "Please pick a mesh to use QuickSkin on.")
	)--end on
	--
	on quickSkinBTN pressed do 
	(
		if IsValidNode theMeshObjectPicked then --check to see that mesh exists
		(	--check to see if mesh already has skin modifier on it, if so, messagebox
			if theMeshObjectPicked.modifiers[#skin] != undefined then
			(messagebox "The object already has a skin modifier applied to it.") else (stretchyBonesCreatorStructInstance.quickSkin())
		) else (messagebox "Please pick a mesh to use QuickSkin on.")
	)--end on
	--
	on toggleSkinBTN pressed do (
		if IsValidNode theMeshObjectPicked then --check to see if picked obj exists
		(
			if theMeshObjectPicked.modifiers[#skin] != undefined then
			(
			stretchyBonesCreatorStructInstance.skinWeightsToggle()
			) else (messagebox "The object does not have a skin modifier applied.")
		)
	)--end on
) --end rollout skinning options






















--create dialog and add subrollouts + their properties
createDialog SBCcontainerRollout 320 750 10 100 lockWidth:true lockHeight:true style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
--add subrollouts to main rollout
AddSubRollout SBCcontainerRollout.SBC_SUB SBCpickedMesh rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB ctrlOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB boneOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB createOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB deleteOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB weldOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB projectOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB skinOptions rolledUp:false
--styles for sub rollouts
SBCcontainerRollout.SBC_SUB.height = 740
SBCcontainerRollout.SBC_SUB.width = 300
SBCcontainerRollout.SBC_SUB.pos = [10,1]
--init
stretchyBonesCreatorStruct.searchForSBCchains()
) --end script