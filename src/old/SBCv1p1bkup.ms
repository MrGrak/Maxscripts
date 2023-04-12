--GrakTools V0.13
--includes SBC v0.13, theSticker v0.03, theLinker v0.02, theSpliner v0.01
--last update 09/18/10
--contact: garrick@garrickcampsey.com

struct projectSelected (
	fn alongZaxis theSelection theObjToStickTo = (
			local theSelectionCount = theSelection.count --get array count
			for i = 2 to theSelectionCount do --setting the i = 2 means we skip the padded 0 array value in this loop
			(
				local rayToMeshCheckDownY = ray theSelection[i].pos [0,0,-1] --shoots ray negative zAxis
				local YpositionDWN = intersectRay theObjToStickTo rayToMeshCheckDownY --find where the ray intersects the mesh to stick to
				local rayToMeshCheckUpY = ray theSelection[i].pos [0,0,1] --shoots ray positive zAxis
				local YpositionUP = intersectRay theObjToStickTo rayToMeshCheckUpY --find where the ray intersects the mesh to stick to
				local positionCHECKvar = 100 --100 value means no rays intersect, 101=negative, 110=positive, 111=both
					if YpositionUP != undefined do  --check up
					(
						positionCHECKvar = positionCHECKvar + 10
					)  --set Var to 2 for top
					if YpositionDWN != undefined do  --check down
					(
						positionCHECKvar = positionCHECKvar + 1
					) --set Var to 1 for bottom
					--checks to move
					if positionCHECKvar == 100 do
						(print "Rays emitted from selected on World Zaxis do not intersect with selected mesh.")
					--check and compare both z axis top and bottom
					if positionCHECKvar == 101 do
						(theSelection[i].pos.z = YpositionDWN.pos.z)
					--check and compare both z axis top and bottom
					if positionCHECKvar == 110 do
						(theSelection[i].pos.z = YpositionUP.pos.z)
	 				--check and compare both z axis top and bottom
					if positionCHECKvar == 111 do
					(
						--compare the UP and DWN values, see which is closest $.pos.z value
						local YdwnCHECK = (abs(abs(YpositionDWN.pos.z) - abs(theSelection[i].pos.z))) --get abs distance value back
						local YupCHECK = (abs(abs(YpositionUP.pos.z) - abs(theSelection[i].pos.z))) --get abs distance value back
							if YupCHECK < YdwnCHECK then --compare z
							(
								theSelection[i].pos.z = YpositionUP.pos.z --move selected
							) else if YupCHECK > YdwnCHECK then
							(
								theSelection[i].pos.z = YpositionDWN.pos.z --move selected
							)
					)--end if
			) --end for loop
	), --end alongZaxis
		
		
	fn alongXaxis theSelection theObjToStickTo = (
			local theSelectionCount = theSelection.count --get array count
			for i = 2 to theSelectionCount do --setting the i = 2 means we skip the padded 0 array value in this loop
			(
				local rayToMeshCheckDownY = ray theSelection[i].pos [-1,0,0] --shoots ray negative xAxis
				local YpositionDWN = intersectRay theObjToStickTo rayToMeshCheckDownY --find where the ray intersects the mesh to stick to
				local rayToMeshCheckUpY = ray theSelection[i].pos [1,0,0] --shoots ray positive xAxis
				local YpositionUP = intersectRay theObjToStickTo rayToMeshCheckUpY --find where the ray intersects the mesh to stick to
				local positionCHECKvar = 100 --100 value means no rays intersect, 101=negative, 110=positive, 111=both
					if YpositionUP != undefined do --check up
					(
						positionCHECKvar = positionCHECKvar + 10
					)  --set Var to 2 for top
					if YpositionDWN != undefined do  --check down
					(
						positionCHECKvar = positionCHECKvar + 1
					) --set Var to 1 for bottom
					--checks to move
					if positionCHECKvar == 100 do
						(print "Rays emitted from selected on World Xaxis do not intersect with selected mesh.")
					--check and compare both x axis top and bottom
					if positionCHECKvar == 101 do
						(theSelection[i].pos.x = YpositionDWN.pos.x)
					--check and compare both x axis top and bottom
					if positionCHECKvar == 110 do
						(theSelection[i].pos.x = YpositionUP.pos.x)
	 				--check and compare both x axis top and bottom
					if positionCHECKvar == 111 do
					(
						--compare the UP and DWN values, see which is closest $.pos.x value
						local YdwnCHECK = (abs(abs(YpositionDWN.pos.x) - abs(theSelection[i].pos.x))) --get abs distance value back
						local YupCHECK = (abs(abs(YpositionUP.pos.x) - abs(theSelection[i].pos.x))) --get abs distance value back
							--compare x
							if YupCHECK < YdwnCHECK then
							(
								theSelection[i].pos.x = YpositionUP.pos.x --move selected
							) else if YupCHECK > YdwnCHECK then
							(
								theSelection[i].pos.x = YpositionDWN.pos.x --move selected
							)
					) --end if
			) --end for loop
	), --end fn alongxAxis
		
		
	fn alongYaxis theSelection theObjToStickTo = (
			local theSelectionCount = theSelection.count --get array count
			for i = 2 to theSelectionCount do --setting the i = 2 means we skip the padded 0 array value in this loop
			(
				local rayToMeshCheckDownY = ray theSelection[i].pos [0,-1,0] --shoots ray negative yAxis
				local YpositionDWN = intersectRay theObjToStickTo rayToMeshCheckDownY --find where the ray intersects the mesh to stick to
				local rayToMeshCheckUpY = ray theSelection[i].pos [0,1,0] --shoots ray positive yAxis
				local YpositionUP = intersectRay theObjToStickTo rayToMeshCheckUpY --find where the ray intersects the mesh to stick to
				local positionCHECKvar = 100 --100 value means no rays intersect, 101=negative, 110=positive, 111=both
					if YpositionUP != undefined do --check up
					(
						positionCHECKvar = positionCHECKvar + 10
					)  --set Var to 2 for top
					if YpositionDWN != undefined do --check down 
					(
						positionCHECKvar = positionCHECKvar + 1
					) --set Var to 1 for bottom
					--checks to move
					if positionCHECKvar == 100 do
						(print "Rays emitted from selected on World Yaxis do not intersect with selected mesh.")
					--check and compare both y axis top and bottom
					if positionCHECKvar == 101 do
						(theSelection[i].pos.y = YpositionDWN.pos.y)
					--check and compare both y axis top and bottom
					if positionCHECKvar == 110 do
						(theSelection[i].pos.y = YpositionUP.pos.y)
	 				--check and compare both y axis top and bottom
					if positionCHECKvar == 111 do
					(
						--compare the UP and DWN values, see which is closest $.pos.y value
						local YdwnCHECK = (abs(abs(YpositionDWN.pos.y) - abs(theSelection[i].pos.y))) --get abs distance value back
						local YupCHECK = (abs(abs(YpositionUP.pos.y) - abs(theSelection[i].pos.y))) --get abs distance value back
							--compare y
							if YupCHECK < YdwnCHECK then
							(
								theSelection[i].pos.y = YpositionUP.pos.y --move selected
							) else if YupCHECK > YdwnCHECK then
							(
								theSelection[i].pos.y = YpositionDWN.pos.y --move selected
							)
					)--end if
			) --end for loop
		) --end alongYaxis function
		
) --end struct projectSelected


struct theLinkerFunction (
	fn linkOneToOne incomingSelectedOBJtoShrink ParentObjectSelected = ( --link one ctrl to another
		incomingSelectedOBJtoShrink.pos = ParentObjectSelected.pos
		incomingSelectedOBJtoShrink.parent = ParentObjectSelected
		incomingSelectedOBJtoShrink.scale = [0.5,0.5,0.5]
		freeze incomingSelectedOBJtoShrink
		--put incoming object onto new shrink and link layer
		--creates new layers named stretchyBones and bones_CTRLS
		layermanager.newLayerFromName "SBC_zHidden"
		--sets layers into names
		local Hiddenlayer = layermanager.getLayerFromName "SBC_zHidden"
		--add new bones to bonesLayer <node>
		Hiddenlayer.addnode incomingSelectedOBJtoShrink
		hide incomingSelectedOBJtoShrink
		clearSelection()
		Hiddenlayer.isHidden = true
		Hiddenlayer.isFrozen = true
	), --end fn LinkOneToOne
	fn theSpliner incomingNodes splineSizeVAL2 theSplineColor2 xrayVAL theSplineLayer = ( --builds spline along incoming nodes.pos
		local incomingNodesCount = incomingNodes.count --get the tot count
		--build the spline from the incoming nodes .pos
		local theFirstNodePOS = incomingNodes[1].pos
		local theSplineShape = SplineShape pos:theFirstNodePOS
		addNewSpline theSplineShape
		addKnot theSplineShape 1 #corner #line incomingNodes[1].pos
		addKnot theSplineShape 1 #corner #line incomingNodes[2].pos
		--spliner needs at least 2 inputs, so check for more than 2
		if incomingNodesCount >= 3 then 
		(
			for i = 3 to incomingNodesCount do
			(
				addKnot theSplineShape 1 #corner #line incomingNodes[i].pos --build em'
			)
		)
		--set properties of spline just built
		theSplineShape.render_displayRenderMesh = true
		theSplineShape.render_viewport_rectangular = false
		theSplineShape.render_thickness = splineSizeVAL2
		theSplineShape.render_sides = 6
		--perform housekeeping on spline
		select theSplineShape
		--get naming convention of objects to buildThru
		local tokenStringVar = ":"
		local firstNodeIncomingAsString = incomingNodes[1] as string
		characterSplitVAR = filterString firstNodeIncomingAsString tokenStringVar
		--print characterSplitVAR[1]
		--print characterSplitVAR[2] --this is the naming convention for SBC chains
		--print characterSplitVAR[3] --[3] will be undefined for non SBC chains
		if characterSplitVAR[3] == undefined then 
			(messagebox "The 1st object is not recognized as a SBC created chain.  Will attempt to inherit naming convention anyways.")
		
		--if naming convention matches SBC, then match naming convention with spline
		$.name = characterSplitVAR[2] + ":spline"
		$.name = uniqueName $.name
				
		CenterPivot $
		if xrayVAL == 1 then ($.xray = true)
		$.wirecolor = theSplineColor2
		--push spline onto user input layer
		local splineMakeLayerName = "SBC_" + theSplineLayer
		layermanager.newLayerFromName splineMakeLayerName
		local splineLayer = layermanager.getLayerFromName splineMakeLayerName
		splineLayer.addnode $
		--link nodes to spline just made
		for i = 1 to incomingNodesCount do
		(
			incomingNodes[i].parent = $
		)
		clearSelection()
		--MUST CALL UPDATESHAPE to prevent max from crashing
		updateShape theSplineShape
	) --end fn theSpliner
)--end struct theLinker



struct SBC (
	layerColorHidden = (color 0 0 0), --this variable determines the hidden layer color values
	layersToDeleteArray = #(), --this array holds the layer names for SBC reset button
	CTRLSbuildingArray = #(), --created ctrls go into this array
	BoneCreatedUnlinkedArray = #(), --created bones go into this array, but they are not linked together yet
	lastCreatedChain = #(), --this is a temp array to hold last created chain, is reset in many functions, do not target it to get last chain
	boneChainNumerator = 1, --this number determines the starting chain name, SBChain1 will be default for example
	UNDOboneChainArray = #(), --an array containing the last chain created by SBC, target this to get last chain
	buildingHelpersArray = #(), --used in the clickToCreate fn, this holds the temp helpers in an array
	theCurrentOBJselectedSTORE = #(), --this is a temp variable holder for a $ object
	
	
	
	fn searchForSBCchains = ( 
		print "checking scene for SBC naming conventions..."
		--declare array to put found SBChain#s into
		local foundSBChainNumARRAY = #()
		--declare : delimiter
		local tokenStringVar = ":"		
		--get all objects in scene
		select $*
		local everythingInScene
		local everythingInSceneCOUNT
		--logic to check if what just got selected actually exists
		if $ != undefined then 
		(
			everythingInScene = $ as array --if its real, turn it into an array
			everythingInSceneCOUNT = everythingInScene.count --and figure out how many there are
			clearSelection()
			
			for i = 1 to everythingInSceneCOUNT do
			(
				local everythingInSceneIasString = everythingInScene[i] as string --turn each obj's address into string
				local characterSplitVAR = filterString everythingInSceneIasString tokenStringVar --break up the name by the ':' delimiter
				--print characterSplitVAR[1]
				--print characterSplitVAR[2] --this is SBChainXXXX in SBC objs
				--print characterSplitVAR[3]
				--check to see if characterSplitVAR[2] == undefined
				if characterSplitVAR[2] != undefined then 
				(
				--check to see if characterSplitVAR[2] equals 'SBChain' naming convention
					--convert characterSplitVAR[2] into a string
					characterSplitVAR2asString = characterSplitVAR[2] as string
					local whereIsSBChainName = findString characterSplitVAR2asString "SBChain"  --finds SBChain text in characterSplitVAR[2]
					
					if whereIsSBChainName == 1 then --it's an SBC obj
					(
						--if true, then obj is SBC made obj, so parse out number after 'SBChain' naming convention
						local namingConventionSBChain = "SBChain"
						local characterSplitVAR2 = filterString characterSplitVAR[2] namingConventionSBChain
						append foundSBChainNumARRAY characterSplitVAR2[1] --put found num into array to check max value later
					)
				) --end if
			) --end for
			--assigns bonechain numerator
			if foundSBChainNumARRAY != undefined then
			(
				local theBiggestValue = amax foundSBChainNumARRAY
				if theBiggestValue != undefined then
				(
					theBiggestValueAsINT = theBiggestValue as integer
					boneChainNumerator = theBiggestValueAsINT+1
					print "SBC objs found, next bone chain starts with:"
					print boneChainNumerator
				)
			) --end if
		) else (print "no SBC objs found.....") --end check if $ is real
		--**could be possible misinterpretation of chain# if SBC spline ctrls exist in scene
	), --end search for SBC chains function
	
	
		
	fn chainManager lastMadeChain typeOfBUILD3 = ( 
			lastMadeChainCount = lastMadeChain.count
			for i=1 to lastMadeChainCount do
			(
				select lastMadeChain[i]
				--if the boneChain to manage is addChid, then
					--make the boneChain to manage inherit the naming convention of the parent object
					if typeOfBUILD3 == "addToSelected" then 
					(
						local tokenStringVar = ":"
						local theCurrentOBJselectedSTOREasString = theCurrentOBJselectedSTORE as string
						local characterSplitVAR = filterString theCurrentOBJselectedSTOREasString tokenStringVar
						--print characterSplitVAR[1]
						--print characterSplitVAR[2] --this is naming convention
						--print characterSplitVAR[3] --[3] will be undefined for non SBC chains
						if characterSplitVAR[3] == undefined then 
						(messagebox "The selected object is not recognized by StretchyBonesCreator.  Will attempt to match naming convention anyways.")
						--make each new obj inherit chain naming convention
						$.name = characterSplitVAR[2] + ":" + $.name
						clearSelection()
					) else (
						--if the boneChain to manage is line, circle, or click2create then
						--put each obj in array into unique chainNumber
						local boneChainNumeratorAsString = boneChainNumerator as string
						$.name = "SBChain" + boneChainNumeratorAsString + ":" + $.name --if you change "SBChain" to user input, user can set chain names
						clearSelection()
					)
			)
			boneChainNumerator = boneChainNumerator + 1
			--setup UNDO for last created chain
			UNDOboneChainArray = lastMadeChain
			--clean out all arrays and reset to 'like new' state
			lastMadeChain = #()
			CTRLSbuildingArray = #()
			BoneCreatedUnlinkedArray = #()
			lastCreatedChain = #()			
			--do a little houseKeeping on the hiddenLayer
			local hiddenMakeLayerName = "SBC_zHidden"
			layermanager.newLayerFromName hiddenMakeLayerName
			local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
			Hiddenlayer.isHidden = true
			Hiddenlayer.isFrozen = true
			print "SBC: Chain sucessfully created and managed."	
	), --end fn chainManager
	


	

	fn buildBONES boneTypeToBuild boneColorToSet newCTRLSarray typeOfBUILD2 USRsetBoneLayer = (
		--build type: 1=line, 2=circle, 3=makeChildren; newCTRLSarray=array containing new CTRLS
		--determine CTRL build type
		local numOfCTRLS2 = newCTRLSarray.count
		
		if typeOfBUILD2 == "line" then 
		(
			for i = 1 to numOfCTRLS2 do
			(
				--check to see if i+1 is undefined, if true = end of bonechain
				if newCTRLSarray[i+1] != undefined then 
				(
					local buildPOS1 = newCTRLSarray[i].pos
					local buildPOS2 = newCTRLSarray[i+1].pos
					local freshBone = BoneSys.createBone buildPOS1 buildPOS2 [0,0,1]
					select freshBone 
					setTransformLockFlags $ #all
					freshBone.boneFreezeLength = false
					freshBone.wirecolor = boneColorToSet
					--boneChainPrefix
					freshBone.name = uniqueName "stretchyB"
					freshBone.renderable = false
					if (boneTypeToBuild == 2) do 
						(freshBone.boxmode = on)
					--add new bones to bonesLayer
					local bonesMakeLayerName = "SBC_" + USRsetBoneLayer
					layermanager.newLayerFromName bonesMakeLayerName
					local Boneslayer = layermanager.getLayerFromName bonesMakeLayerName
					BonesLayer.addnode $
					append BoneCreatedUnlinkedArray $
					clearSelection()
				)  --end if statement
			) --end buildLine for loop	
			
			--build a nubBone after last bone (last index of bone array)
				local NUBbuildPOS1 = newCTRLSarray[numOfCTRLS2].pos
				local NUBbuildPOS2 = newCTRLSarray[numOfCTRLS2-1].pos
				local freshNUB = BoneSys.createBone NUBbuildPOS1 NUBbuildPOS2 [0,0,1]
				select freshNUB
				append BoneCreatedUnlinkedArray $
				--set nubBone properties
				setTransformLockFlags $ #all
				freshNUB.name = uniqueName "nubBone"
				freshNUB.scale = [0.05,0.05,0.05]
				freshNUB.renderable = false
				freshNUB.boneFreezeLength = false
				freshNUB.wirecolor = boneColorToSet
				--push onto hidden layer
				local hiddenMakeLayerName = "SBC_zHidden"
				layermanager.newLayerFromName hiddenMakeLayerName
				local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
				Hiddenlayer.addnode $
				clearSelection()
			--link up all bones including nubBone
			for i = 1 to numOfCTRLS2 do 
				(
					--check to see if BoneCreatedUnlinkedArray[i+1] is undefined, if true end
					if BoneCreatedUnlinkedArray[i+1] != undefined then 
					( 
						local tempChildBone = BoneCreatedUnlinkedArray[i+1]
						local tempParentBone = BoneCreatedUnlinkedArray[i]
						tempChildBone.parent = tempParentBone --links up bone system
						print "parent:"
						print tempParentBone
						print "child:"
						print tempChildBone
						
					)
				)
			--following loop constrains bones to ctrls	
			for i = 1 to numOfCTRLS2 do
				(
				select BoneCreatedUnlinkedArray[i] 
				local posConstraintVariable = Position_Constraint()
				$.pos.controller = posConstraintVariable
				local positionConstraintInterface = posConstraintVariable.constraints
				local tempCtrlArrayNum = newCTRLSarray[i]
				positionConstraintInterface.appendtarget tempCtrlArrayNum 100
				clearSelection()
				)
	 		--following loop adds lookAt controllers to bones to point at ctrls	
			for i = 1 to numOfCTRLS2 do
				(
				if newCTRLSarray[i+1] != undefined then 
					(
						select BoneCreatedUnlinkedArray[i] 
						local lookAtConstraintVariable = lookAt_Constraint()
						$.rotation.controller = lookAtConstraintVariable
						local positionConstraintInterface = lookAtConstraintVariable.constraints
						local tempCtrlArrayNum = newCTRLSarray[i+1]
						positionConstraintInterface.appendtarget tempCtrlArrayNum 100
						$.rotation.controller.viewline_length_abs = off
						clearSelection()
					)
				)
			
			--end build line commands
		
		
	
		) else if typeOfBUILD2 == "circle" then ( --CIRCLE
			--build a circle
			for i = 1 to numOfCTRLS2 do
			(
				--build bones in a circle
				--check to see if i+1 is undefined, if true = end of bonechain (for now)
				if newCTRLSarray[i+1] != undefined then 
				(
					local buildPOS1 = newCTRLSarray[i].pos
					local buildPOS2 = newCTRLSarray[i+1].pos
					local freshBone = BoneSys.createBone buildPOS1 buildPOS2 [0,0,1]
					select freshBone
					--boneChainPrefix
					freshBone.name = uniqueName "stretchyB"
					freshBone.renderable = false
					--add new bones to bonesLayer
					local bonesMakeLayerName = "SBC_" + USRsetBoneLayer
					layermanager.newLayerFromName bonesMakeLayerName
					local Boneslayer = layermanager.getLayerFromName bonesMakeLayerName
					BonesLayer.addnode $
					append BoneCreatedUnlinkedArray $
					clearSelection()
				) --end if
			) --end buildCircle for loop
		
			--build bone from last sphere to first sphere
			local NubBuildPOS1 = newCTRLSarray[numOfCTRLS2].pos
			local NubBuildPOS2 = newCTRLSarray[1].pos
			local FreshLastBone = BoneSys.createBone NubBuildPOS1 NubBuildPOS2 [0,0,1] --build bone from last to first ctrl
			append BoneCreatedUnlinkedArray FreshLastBone --add last bone into unlinked array
			--add lastBone to right layer
			local bonesMakeLayerName = "SBC_" + USRsetBoneLayer
			layermanager.newLayerFromName bonesMakeLayerName
			local Boneslayer = layermanager.getLayerFromName bonesMakeLayerName
			BonesLayer.addnode FreshLastBone						
			FreshLastBone.name = uniqueName "stretchyB"--rename lastBone to proper naming convention
			FreshLastBone.renderable = false --not renderable
			FreshLastBone.wirecolor = boneColorToSet
			local NubBone = BoneSys.createBone NubBuildPOS2 NubBuildPOS1 [0,0,1] --build nub bone from first sphere to last sphere
			append BoneCreatedUnlinkedArray NubBone --add NubBone into unlinked array
			NubBone.name = uniqueName "nubBone" --rename nubBone
			--put NubBone on hidden layer
				local hiddenMakeLayerName = "SBC_zHidden"
				layermanager.newLayerFromName hiddenMakeLayerName
				local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
				HiddenLayer.addnode NubBone
			NubBone.scale = [0.05,0.05,0.05]--scale nubBone down
			freeze NubBone
		--assign controllers using for loop and BoneCreatedUnlinkedArray
			--link up all bones including nubBone
			for i = 1 to numOfCTRLS2 do 
				(
					--check to see if BoneCreatedUnlinkedArray[i+1] is undefined, if true end
					if BoneCreatedUnlinkedArray[i+1] != undefined then 
					( 
						local tempChildBone = BoneCreatedUnlinkedArray[i+1]
						local tempParentBone = BoneCreatedUnlinkedArray[i]
						tempChildBone.parent = tempParentBone --links up bone system
					)
				)
			--following loop constrains bones to ctrls	
			for i = 1 to numOfCTRLS2 do
				(
					select BoneCreatedUnlinkedArray[i] 
					local posConstraintVariable = Position_Constraint()
					$.pos.controller = posConstraintVariable
					local positionConstraintInterface = posConstraintVariable.constraints
					local tempCtrlArrayNum = newCTRLSarray[i]
					positionConstraintInterface.appendtarget tempCtrlArrayNum 100
					clearSelection()
				)
			--constrain nubBone to 1st ctrl
			select NubBone
			local posConstraintVariable2 = Position_Constraint()
			$.pos.controller = posConstraintVariable2
			local positionConstraintInterface = posConstraintVariable2.constraints
			local tempCtrlArrayNum2 = newCTRLSarray[1] --constrain it to the 1st ctrl
			positionConstraintInterface.appendtarget tempCtrlArrayNum2 100
			clearSelection()
	 		--following loop adds lookAt controllers to bones to point at ctrls	
			for i = 1 to numOfCTRLS2 do
				(
					select BoneCreatedUnlinkedArray[i] 
					local lookAtConstraintVariable = lookAt_Constraint()
					$.rotation.controller = lookAtConstraintVariable
					local positionConstraintInterface = lookAtConstraintVariable.constraints
					local tempCtrlArrayNum
					if newCTRLSarray[i+1] != undefined then ( --if there is a ctrl to link to,
					tempCtrlArrayNum = newCTRLSarray[i+1] --then we will link to it
					) else (
					tempCtrlArrayNum = newCTRLSarray[1] --if not, we will link back to first ctrl
					)
					positionConstraintInterface.appendtarget tempCtrlArrayNum 100
					$.rotation.controller.viewline_length_abs = off
					BoneCreatedUnlinkedArray[i].boneFreezeLength = false  --unfreezes all bones in the chain
					setTransformLockFlags $ #all --lock all transforms on all bones
					$.wirecolor = boneColorToSet
					if (boneTypeToBuild == 2) do --check to see if user wants bones in boxMode
						(
							BoneCreatedUnlinkedArray[i].boxmode = on --set all bones to boxMode
						)
					clearSelection()
			) --end build circle commands
			

		) else if typeOfBUILD2 == "addToSelected" then ( --CHILD
			--clear out theCurrentOBJselectedSTORE array
			theCurrentOBJselectedSTORE = #()
			--put $ into a struct variable to use later
			join theCurrentOBJselectedSTORE $
			
			for i = 1 to numOfCTRLS2 do
			(
			local buildPOS1 = $.pos
			local buildPOS2 = newCTRLSarray[i].pos
			local freshBone = BoneSys.createBone buildPOS1 buildPOS2 [0,0,1] --build bone from selected to new ctrl
			local nubBone = BoneSys.createBone buildPOS2 buildPOS1 [0,0,1] --build nub from ctrl to selected
			nubBone.scale = [0.05,0.05,0.05] --scale nubBone down
			nubBone.parent = freshBone --make nub parent of fresh bone
			freshBone.boneFreezeLength = false  --unfreeze the length!
			
			--inherit the bone color
			nubBone.wirecolor = boneColorToSet
			freshBone.wirecolor = boneColorToSet
			
			--pos constrain fresh bone to original selected
			local posConstraintVariable = Position_Constraint()
			freshBone.pos.controller = posConstraintVariable
			local positionConstraintInterface = posConstraintVariable.constraints
			positionConstraintInterface.appendtarget $ 100
			
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
			
			--lock nub and freshBone
			setTransformLockFlags freshBone #all
			setTransformLockFlags nubBone #all 
			--put fresh bone on right layer
			local bonesMakeLayerName = "SBC_" + USRsetBoneLayer
			layermanager.newLayerFromName bonesMakeLayerName
			local Boneslayer = layermanager.getLayerFromName bonesMakeLayerName
			BonesLayer.addnode freshBone
			--rename freshBone to proper naming convention		
			freshBone.name = uniqueName "stretchyB"--rename lastBone to proper naming convention
			freshBone.renderable = false --not renderable
			--put nubBone on hidden layer
			local hiddenMakeLayerName = "SBC_zHidden"
			layermanager.newLayerFromName hiddenMakeLayerName
			local Hiddenlayer = layermanager.getLayerFromName hiddenMakeLayerName
			HiddenLayer.addnode nubBone
			--rename freshBone to proper naming convention		
			nubBone.name = uniqueName "nubBone"--rename lastBone to proper naming convention
			nubBone.renderable = false --not renderable
			freeze nubBone
			--determine if boxMode should be enabled
			if (boneTypeToBuild == 2) do --check to see if user wants bones in boxMode
				(
				freshBone.boxmode = on
				nubBone.boxmode = on
				)
			
			--add in nub and fresh bone into bone unlinked array
			append BoneCreatedUnlinkedArray freshBone --add last bone into unlinked array
			append BoneCreatedUnlinkedArray nubBone --add last bone into unlinked array
			) --end buildChildren for loop

		) --end of build check type
		
		--add new ctrls and bones arrays together into one array, lastCreatedBoneChain
		join lastCreatedChain newCTRLSarray
		join lastCreatedChain BoneCreatedUnlinkedArray
		--cleanout old arrays
		newCTRLSarray = #()
		BoneCreatedUnlinkedArray = #()
		--send lastCreatedBoneChain to chainManager
		chainManager lastCreatedChain typeOfBUILD2
	),	--end buildBones function
		
		
		
	fn buildCTRLS BONEbuildType CTRLbuildType numOfCTRLS typeOfBUILD ctrlColor boneColor ctrlSize USRinputCtrlLayerName USRinputBoneLayerName = (
		--build type: "line"=line, "circle"=circle, "addToSelected"=makeChildren; numOfCTRLS=total amount of controls to be built
		--reset last chain made
		UNDOboneChainArray = #()

		--determine CTRL build type
		if typeOfBUILD == "line" then ( --LINE
			--build a line
			for i = 1 to numOfCTRLS do
			(
				if (CTRLbuildType == 1) then 
				(
				Sphere radius:ctrlSize smooth:on segs:10 chop:0 slice:off \
				sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
				pos:[(i*50-50),0,0] isSelected:on
				)
 				else if (CTRLbuildType == 2) then
				(
				local phelpSizeValue = ctrlSize*2
				Point pos:[(i*50-50),0,0] isSelected:on size:phelpSizeValue
				$.Box = on
				$.drawontop = on
				)
				$.wirecolor = ctrlColor
				$.name = uniqueName "ctrl" --unique name each ctrl
				$.renderable = false
				--put the ctrl into proper layer
				local ctrlsMakeLayerName = "SBC_" + USRinputCtrlLayerName  --get user input ctrl layer name
				layermanager.newLayerFromName ctrlsMakeLayerName  --make the ctrls layer
				local CTRLSlayer = layermanager.getLayerFromName ctrlsMakeLayerName
				CTRLSlayer.addnode $ --add ctrl to user ctrl layer name
				CTRLSlayer.wirecolor = ctrlColor --set color for layer
				append CTRLSbuildingArray $ --add into array
				clearSelection()
			) --end buildLine for loop	
		) else if typeOfBUILD == "circle" then ( --CIRCLE
			--build a circle
			local rotationMultiplierVAL = 360/(numOfCTRLS)
			for i = 1 to numOfCTRLS do
				(
					if (CTRLbuildType == 1) then 
					(
					Sphere radius:ctrlSize smooth:on segs:10 chop:0 slice:off \
					sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
					pos:[0,0,100] isSelected:on
					)
	 				else if (CTRLbuildType == 2) then
					(
					local phelpSizeValue = ctrlSize*2
					Point pos:[0,0,100] isSelected:on size:phelpSizeValue
					$.Box = on
					$.drawontop = on
					)				
					$.wirecolor = ctrlColor
					$.pivot=[0,0,0]  --offsets pivot so you can rotate $
					local rotateVal = i*rotationMultiplierVAL
					rotate $ rotateVal y_axis
					resetPivot $
					$.name = uniqueName "ctrl" --unique name each ctrl
					$.renderable = false
					--put the ctrl into proper layer
					local ctrlsMakeLayerName = "SBC_" + USRinputCtrlLayerName  --get user input ctrl layer name
					layermanager.newLayerFromName ctrlsMakeLayerName  --make the ctrls layer
					local CTRLSlayer = layermanager.getLayerFromName ctrlsMakeLayerName
					CTRLSlayer.addnode $ --add ctrl to user ctrl layer name
					CTRLSlayer.wirecolor = ctrlColor --set color for layer
					append CTRLSbuildingArray $ --add into array
					clearSelection()
	
				) --end buildCircle for loop
		) else if typeOfBUILD == "addToSelected" then ( --CHILD
			--build children onto selected
			local rotationMultiplierVAL = 360/(numOfCTRLS)
			local originallySelected = $
			local selectedsPosition = $.pos
			local offsetSelectedsPosition = selectedsPosition + [0,0,100]
			clearSelection()
			for i = 1 to numOfCTRLS do
			(
				if (CTRLbuildType == 1) then 
				(
				Sphere radius:ctrlSize smooth:on segs:10 chop:0 slice:off \
				sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
				pos:offsetSelectedsPosition isSelected:on
				)
 				else if (CTRLbuildType == 2) then
				(
				local phelpSizeValue = ctrlSize*2
				Point pos:offsetSelectedsPosition isSelected:on size:phelpSizeValue
				$.Box = on
				$.drawontop = on
				)				
				$.wirecolor = ctrlColor
				$.pivot=selectedsPosition  --offsets pivot so you can rotate $
				
				local rotateVal = i*rotationMultiplierVAL
				rotate $ rotateVal y_axis
				resetPivot $
				$.name = uniqueName "ctrl" --unique name each ctrl
				$.renderable = false
				--put the ctrl into proper layer
				local ctrlsMakeLayerName = "SBC_" + USRinputCtrlLayerName  --get user input ctrl layer name
				layermanager.newLayerFromName ctrlsMakeLayerName  --make the ctrls layer
				local CTRLSlayer = layermanager.getLayerFromName ctrlsMakeLayerName
				CTRLSlayer.addnode $ --add ctrl to user ctrl layer name
				CTRLSlayer.wirecolor = ctrlColor --set color for layer
				append CTRLSbuildingArray $ --add into array
				clearSelection()
			) --end buildChildren for loop
		select originallySelected --make sure to select the original obj again, so the boneBuilder function can use it
		)		
		--call buildBONES function and send parameters
		--fn buildBONES boneTypeToBuild boneColorToSet newCTRLSarray typeOfBUILD2 USRsetBoneLayer 
		buildBONES BONEbuildType boneColor CTRLSbuildingArray typeOfBUILD USRinputBoneLayerName
	), --end buidlCTRLs
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

	fn clickToCreateChain BONEbuildType2 CTRLbuildType2 numOfCTRLS2 typeOfBUILD2 ctrlColor2 boneColor2 ctrlSize2 USRinputCtrlLayerName2 USRinputBoneLayerName2 = ( 
		--
		local P1 = pickpoint prompt:"Capturing user LMB click position..."
		format "\n%\n" P1
		if classOf P1 == Point3 then --captureUserInput if
		(
			clearSelection()
			--if the user clicked, build a pHelper at the click point
			Point pos:P1 isSelected:on
			--assign random name to pHelper, so you don't get name overlap with scene objs
			$.name = uniqueName "pBuilder_" + (random 1.1 1000000) as string
			$.box = true
			$.wirecolor = [255,255,255]
			join buildingHelpersArray $ 
			clearSelection()
			--call recursion
			clickToCreateChain BONEbuildType2 CTRLbuildType2 numOfCTRLS2 typeOfBUILD2 ctrlColor2 boneColor2 ctrlSize2 USRinputCtrlLayerName2 USRinputBoneLayerName2
		) --endCaptureUserInput if
		if P1 == #rightClick then --buildIf
		(
			--put buildingHelpersArray.count into ctrlsArray
			local numOfPhelpers = buildingHelpersArray.count
			--call ctrl builder fn with buildType = line + add. params
			buildCTRLS BONEbuildType2 CTRLbuildType2 numOfPhelpers typeOfBUILD2 ctrlColor2 boneColor2 ctrlSize2 USRinputCtrlLayerName2 USRinputBoneLayerName2
			--after boneChain is created, take the 1st ctrl and align it to the 1st pHelper and so on
			--target lastBoneChain array			
			for i = 1 to numOfPhelpers do
			(
				--ctrls are always first in array, ctrls num = pHelpers num
				--make each ctrl.pos equal to pHelpers.pos
				UNDOboneChainArray[i].pos = buildingHelpersArray[i].pos				
			)
			--delete each pHelper in array, houseKeeping!
			for i = 1 to numOfPhelpers do
			(
				select buildingHelpersArray[i]
				delete $
			)
			--reset the buildingHelpersArray for next batch
			buildingHelpersArray = #()
		) --end buildIf
		else if P1 == #escape then 
		(
			--don't build the bone
			messagebox "SBC chain creation canceled by user."
			local numOfPhelpers = buildingHelpersArray.count
			--delete each pHelper in array
			for i = 1 to numOfPhelpers do
			(
				select buildingHelpersArray[i]
				delete $
			)
			--empty out the buildingHelpersArray for next batch
			buildingHelpersArray = #()
		) --end if
	), --end clickToCreateChain fn	
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
	fn undoLastChain = (
		--get and delete the last made chain
	), --end UNDO last chain
		
		
		
	fn deleteSelectedChain = (
		--is the selected object a validNode?, if true
		if IsValidNode $ then 
		(
			--get naming convention of selected using string parse
			--find all other objects with the same naming convention
			--delete all other objects with the same naming convention
			print $
			local tokenStringVar = ":"
			local SelectedObjectStringArrayIndex = $ as string
			characterSplitVAR = filterString SelectedObjectStringArrayIndex tokenStringVar
			print ": character split"
			print characterSplitVAR[1]
			print characterSplitVAR[2]
			print characterSplitVAR[3] --[3] will be undefined for non SBC chains
			if characterSplitVAR[3] == undefined then 
			(messagebox "The selected object is not recognized by StretchyBonesCreator.  Will attempt to delete anyways.")
			--get length of [2] by count
			local lengthOfcharacterSplitVAR2 = characterSplitVAR[2].count
			local NamingConventionOfSelectedsName = substring characterSplitVAR[2] 1 lengthOfcharacterSplitVAR2
			print "delete by:"
			print NamingConventionOfSelectedsName
			
			--select all the boneChains
			select $SBC*
			local selectionAsArray = selection as array
			--print "all SBchains selected as:"
			--print selectionAsArray
			
			local selectionAsArrayCount = selectionAsArray.count
			--print "matching Naming Convention..."
			for i=1 to selectionAsArrayCount do --for the total do
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
	), --end function deleteSelectedChain
		
		
		
	fn resetSBC = (
	--delete all bone chains and CTRLS made by SBC from the scene
		delete $SBC* --deletes all objects with the following naming convention
		--check other layers for SBC naming convention
		local checkLayerCount = layerManager.count
		for i = 0 to checkLayerCount+1 do (
			local firstLayer = layermanager.getlayer i
			--check to see if layer i is undefined
			if (layermanager.getlayer i) != undefined do (
				local firstLayerName = firstLayer.name
				local checkLayersForSBC = substring firstLayerName 1 4 --parse firstLayerName
				if checkLayersForSBC == "SBC_" do --if match SBC_, delete
					(
					--append layer name into layersToDeleteArray
					append layersToDeleteArray firstLayerName
					)
			)
		)	
		layersToDeleteArrayCount = layersToDeleteArray.count --get all layersToDeleteArray count
		for i = 1 to layersToDeleteArrayCount do --for the count
		(
			theLayerBeingDeleted = layersToDeleteArray[i]
			layerManager.deleteLayerByName theLayerBeingDeleted --delete the layer by name
		)
		--reset layerToDeleteArray for next time
		layersToDeleteArray = #()	
	)--end fn resetSBC
	
)--end struct SBC


--rollOuts
rollout StretchyBonesCreator "Stretchy Bones Creator v0.13" category:1
	(
	--UI and layout
	groupBox grp1 "CTRL options" pos:[2,8] width:271 height:70
	radioButtons ctrlTypeBTN "" pos:[10,24] width:180 height:16 labels:#("Spheres", "P.Helpers") columns:2 default:1
	colorPicker ctrlColorPicker "" pos:[222,25] width:45 height:16 color:(color 0 114 255)
	spinner ctrlSizeSPN "Size: " pos:[170,25] width:50 height:16 type:#integer range:[0.01,1000,10]
	editText ctrlsLayerNameEditText "" pos:[6,50] width:190 height:18 text:"controls"
	button setCtrlLayerBTN "Set Layer" pos:[203,50] width:64 height:18
		--
	groupBox grp2 "BONE options" pos:[2,85] width:271 height:68
	radioButtons boneTypeBTN "" pos:[10,101] width:158 height:16 labels:#("Bone", "BoxMode") columns:2
	colorPicker boneColorPicker "" pos:[222,102] width:45 height:16 color:(color 114 114 114)
	editText bonesLayerNameEditText "" pos:[6,125] width:190 height:18 text:"bones"
	button setBoneLayerBTN "Set Layer" pos:[203,125] width:64 height:18
		--
	groupBox grp3 "CREATE options" pos:[2,160] width:271 height:125
	button clickToCreateBTN "Enable Click to Create Chain" pos:[10,180] width:257 height:18
	spinner numOfCTRLStoMakeSPN "# of CTRLs to make:  " pos:[120,210] width:100 height:16 range:[1,20,1] type:#integer
	button makeLineBTN "MAKE a line" pos:[10,235] width:125 height:18
	button makeCircleBTN "MAKE a circle" pos:[142,235] width:125 height:18
	button addChildrenBTN "ADD # of ctrls to selected" pos:[10,260] width:257 height:18 
		--
	groupBox grp5 "DELETE options" pos:[2,293] width:271 height:80
	button UNDOBTN "UNDO last chain" pos:[10,313] width:120 height:53
	button deleteSelectedBTN "DELETE selected chain" pos:[137,313] width:130 height:24
	button resetSBCbtn "RESET SBC" pos:[197,348] width:70 height:18
		--
	--button checkForSBCchains "Check scene for SBC created Objects" pos:[2,380] width:271 height:20

	
	--declarations
	local SBCstruct = SBC()
	--on open/init, check for SBChains
	on StretchyBonesCreator open do
	(
		SBCstruct.searchForSBCchains()
	)
	
	
	--click to create button
	on clickToCreateBTN pressed do
	(
		--gather together all params to send to ctrl and bone build fn, after clickToCreate fn builds pHelpers
		local boneLayerNameSet = bonesLayerNameEditText.text
		local ctrlLayerNameSet = ctrlsLayerNameEditText.text
		local ctrlTypeVAL = ctrlTypeBTN.state
		local boneTypeVAL = boneTypeBTN.state
		local outGoingCTRLSAmt = numOfCTRLStoMakeSPN.value
		local typeOfBuildOut = "line"
		local ctrlColorVAL = ctrlColorPicker.color
		local boneColorVAL = boneColorPicker.color
		local ctrlSizeVAL = ctrlSizeSPN.value
		SBCstruct.clickToCreateChain boneTypeVAL ctrlTypeVAL outGoingCTRLSAmt typeOfBuildOut ctrlColorVAL boneColorVAL ctrlSizeVAL ctrlLayerNameSet boneLayerNameSet
	)
	
	--undo button
	on UNDOBTN pressed do 
	(
		--remove all items in UNDOboneChainArray
		local UNDOboneChainArrayCOUNT = SBCstruct.UNDOboneChainArray.count
		for i = 1 to UNDOboneChainArrayCOUNT do
		(
			select SBCstruct.UNDOboneChainArray[i]
			delete $
		) 
	)

	--delete selected button
	on deleteSelectedBTN pressed do
	(
		SBCstruct.deleteSelectedChain()
	)

	--OPTIONS event statements
	--CTRL layerName setup
	on setCtrlLayerBTN pressed do (
		if ctrlsLayerNameEditText.text != "" then (
			print ctrlsLayerNameEditText.text
		) else (
			messagebox "Please enter a layer name for the controls."
		)
	)
	--BONE layerName setup
	on setBoneLayerBTN pressed do (
		if bonesLayerNameEditText.text != "" then (
			print bonesLayerNameEditText.text
		) else (
			messagebox "Please enter a layer name for the bones."
		)
	)

	--CREATE event statements --
	on makeLineBTN pressed do ( --make line button
		if ctrlsLayerNameEditText.text != "" then ( --check to see if bone and ctrls layers have names
			if bonesLayerNameEditText.text != "" then ( 
				if numOfCTRLStoMakeSPN.value >= 2 then ( --check to see if num of ctrls is greater than 1, can't build line with 1 ctrl
					--get user set bone and ctrl names, send to SBC function
					--setup values to send to build function
					local boneLayerNameSet = bonesLayerNameEditText.text
					local ctrlLayerNameSet = ctrlsLayerNameEditText.text
					local ctrlTypeVAL = ctrlTypeBTN.state
					local boneTypeVAL = boneTypeBTN.state
					local outGoingCTRLSAmt = numOfCTRLStoMakeSPN.value
					local typeOfBuildOut = "line"
					local ctrlColorVAL = ctrlColorPicker.color
					local boneColorVAL = boneColorPicker.color
					local ctrlSizeVAL = ctrlSizeSPN.value
					--send values to build function
					--fn buildCTRLS BONEbuildType CTRLbuildType numOfCTRLS typeOfBUILD ctrlColor boneColor ctrlSize USRinputCtrlLayerName USRinputBoneLayerName =
					SBCstruct.buildCTRLS boneTypeVAL ctrlTypeVAL outGoingCTRLSAmt typeOfBuildOut ctrlColorVAL boneColorVAL ctrlSizeVAL ctrlLayerNameSet boneLayerNameSet
					--sending over, print complete
					print "send complete, all functions processed..."
					) else (messagebox "Can't make a line with 1 ctrl.  Needs minimum of 2.") --end num>1 check
			) else (messagebox "No bone layer name entered.")
		) else (messagebox "No ctrl layer name entered.")	
	) --end makeLineBTN
	on makeCircleBTN pressed do ( --make circle button addChildrenBTN
		if ctrlsLayerNameEditText.text != "" then ( --check to see if bone and ctrls layers have names
			if bonesLayerNameEditText.text != "" then (
				if numOfCTRLStoMakeSPN.value >= 3 then ( --check to see if number of ctrls to build is 3 or more (can't build a circle with 2 points)
					--get user set bone and ctrl names, send to SBC function
					--setup values to send to build function
					local boneLayerNameSet = bonesLayerNameEditText.text
					local ctrlLayerNameSet = ctrlsLayerNameEditText.text
					local ctrlTypeVAL = ctrlTypeBTN.state
					local boneTypeVAL = boneTypeBTN.state
					local outGoingCTRLSAmt = numOfCTRLStoMakeSPN.value
					local typeOfBuildOut = "circle"
					local ctrlColorVAL = ctrlColorPicker.color
					local boneColorVAL = boneColorPicker.color
					local ctrlSizeVAL = ctrlSizeSPN.value
					--send values to build function
					--fn buildCTRLS BONEbuildType CTRLbuildType numOfCTRLS typeOfBUILD ctrlColor boneColor ctrlSize USRinputCtrlLayerName USRinputBoneLayerName =
					SBCstruct.buildCTRLS boneTypeVAL ctrlTypeVAL outGoingCTRLSAmt typeOfBuildOut ctrlColorVAL boneColorVAL ctrlSizeVAL ctrlLayerNameSet boneLayerNameSet
					--sending over, print complete
					print "send complete, all functions processed..."
				) else (messagebox "You need at least 3 ctrls to build a circle.  Increase the # of ctrls to make.")
			) else (messagebox "No bone layer name entered.")
		) else (messagebox "No ctrl layer name entered.")	
	) --end makeCircleBTN
	on addChildrenBTN pressed do ( --addChildren button 
		if ctrlsLayerNameEditText.text != "" then ( --check to see if bone and ctrls layers have names
			if bonesLayerNameEditText.text != "" then (
				if selection.count == 1 then ( --check to see if selection is only 1, can't add many to many
					--get user set bone and ctrl names, send to SBC function
					--setup values to send to build function
					local boneLayerNameSet = bonesLayerNameEditText.text
					local ctrlLayerNameSet = ctrlsLayerNameEditText.text
					local ctrlTypeVAL = ctrlTypeBTN.state
					local boneTypeVAL = boneTypeBTN.state
					local outGoingCTRLSAmt = numOfCTRLStoMakeSPN.value
					local typeOfBuildOut = "addToSelected"
					local ctrlColorVAL = ctrlColorPicker.color
					local boneColorVAL = boneColorPicker.color
					local ctrlSizeVAL = ctrlSizeSPN.value
					--send values to build function
					--fn buildCTRLS BONEbuildType CTRLbuildType numOfCTRLS typeOfBUILD ctrlColor boneColor ctrlSize USRinputCtrlLayerName USRinputBoneLayerName =
					SBCstruct.buildCTRLS boneTypeVAL ctrlTypeVAL outGoingCTRLSAmt typeOfBuildOut ctrlColorVAL boneColorVAL ctrlSizeVAL ctrlLayerNameSet boneLayerNameSet
					--sending over, print complete
					print "send complete, all functions processed..."
				) else (messagebox "Please select only one object to add ctrls to.")
			) else (messagebox "No bone layer name entered.")
		) else (messagebox "No ctrl layer name entered.")	
	) --end addChildrenBTN

	
	--DELETE statement events
	on resetSBCbtn pressed do (
		--call reset function on SBC struct
		SBCstruct = SBC()
		SBCstruct.resetSBC()	
	)	
)--end SBC rollout



rollout theLinker "The Linker v0.01" category:2
	(
	--UI and layout
	groupBox grp4 "LINK 1 to 1 options" pos:[2,8] width:271 height:56
	button linkSelectedBTN "link selected" pos:[10,28] width:110 height:24
	label lbl2 "to:" pos:[133,33] width:17 height:17
	pickbutton linkSingle2ParentBTN "PARENT" pos:[157,27] width:110 height:24
	--declarations
	local theLinkerStruct
	--event statements
	on linkSelectedBTN pressed do (
		--check to see if parent object is validNode
		local isNodeRealCheck = IsValidNode linkSingle2ParentBTN.object
		if isNodeRealCheck == true then (
			print "parent is valid node..."
			--check to see if current selection is single
			if selection.count == 1 then (
				--fn linkOneToOne incomingSelectedOBJtoShrink ParentObjectSelected --REF of fn
				local ParentGoingout = linkSingle2ParentBTN.object
				theLinkerStruct = theLinkerFunction() --declare SBC instance
				theLinkerStruct.linkOneToOne $ ParentGoingout --call function linkOneToOne, send params
				) else ( messagebox "Please select only one object, then try again." )
			) else ( messagebox "The parent object is invalid." )	
		)	
) --end the Linker rollout



rollout theSticker "The Sticker v0.02" category:3
	(
		--UI and layout	
		button projectStickBTN "STICK" pos:[5,10] tooltip:"Press to stick it." width:60
		label lbl3 "selected along World" pos:[74,14] width:140 height:16
		radioButtons axisToProjectRDO "" pos:[185,13] width:120 height:16 labels:#("X", "Y", "Z") columns:3
		label lbl4 "axis to:" pos:[213,35] width:140 height:16
		pickbutton meshToStickToBTN "object" tooltip:"Pick a scene object" autoDisplay:true width:70 pos:[200,55]
		--button _callFunc2 "Stick along viewport axis to:" pos:[5,55] tooltip:"Press to stick it." width:190
		
		--declarations
		local projectSelectedStruct
		
		--event statements
		on projectStickBTN pressed do
		(
			--check to see if obj to stick to is valid node
			if IsValidNode meshToStickToBTN.object then 
			(
				--setup params out
					--put selection into array with padded 0 value
					local selectionAsArray = selection as array
					local paddedSelectionArray = #(0)
					join paddedSelectionArray selectionAsArray
					local theObjToStick2 = meshToStickToBTN.object
					projectSelectedStruct = projectSelected() --declare SBC instance
				--check to see which axis to project onto
				local axisToProject = axisToProjectRDO.state --state = 1X, 2Y, 3Z
				if axisToProject == 1 then
				(
					print "x axis selected"
					--project onto X
					projectSelectedStruct.alongXaxis paddedSelectionArray theObjToStick2 --call function, send params
				) else if axisToProject == 2 then
				(
					print "y axis selected"
					--project onto Y
					projectSelectedStruct.alongYaxis paddedSelectionArray theObjToStick2 --call function, send params
				) else if axisToProject == 3 then
				(
					print "z axis selected"
					--project onto Z
					projectSelectedStruct.alongZaxis paddedSelectionArray theObjToStick2 --call function, send params
				)
				--fn alongYaxis theSelection theObjToStickTo --	REF OF FUNCTION TO CALL
				
			) else (messagebox "Please select a valid object to stick other objects to.") --end if
		) --end on
)--end theSticker rollout



rollout theSpliner "The Spliner v0.01" category:5
	(
	--UI and layout
	
	spinner splineSizeSPN "Size: " pos:[25,160] width:50 height:16 type:#integer range:[0.01,1000,10]
	label seeThruLabel "See thru?" pos:[85,160] width:50 height:17
	radioButtons xrayRadioBTN "" pos:[140,160] width:200 height:16 labels:#("Yes", "No") columns:2
	colorPicker splineColorPicker "" pos:[225,160] width:45 height:16 color:(color 0 114 255)
	button makeSplineBTN "Make the Spline" pos:[5,180] width:265 height:24
	editText splineLayerNameEditText "" pos:[2,210] width:200 height:18 text:"SplineControls"
	button setSplineLayerBTN "Set Layer" pos:[206,210] width:64 height:18
		--
	button resetSplineBTN "Reset Spliner" pos:[180,250] width:90 height:18
		--
	label lbl1 "1. " pos:[5,18] width:17 height:17
	pickbutton target1 "object" pos:[20,12] width:110 height:24 autoDisplay:true
	label lbl2 "2. " pos:[5,44] width:17 height:17 --+26
	pickbutton target2 "object" pos:[20,38] width:110 height:24 autoDisplay:true
	label lbl3 "3. " pos:[5,70] width:17 height:17 --+26
	pickbutton target3 "object" pos:[20,64] width:110 height:24 autoDisplay:true
	label lbl4 "4. " pos:[5,94] width:17 height:17 --+26
	pickbutton target4 "object" pos:[20,90] width:110 height:24 autoDisplay:true
	label lbl5 "5. " pos:[5,122] width:17 height:17 --+26
	pickbutton target5 "object" pos:[20,116] width:110 height:24 autoDisplay:true
		--
	label lbl6 "6. " pos:[140,18] width:17 height:17
	pickbutton target6 "object" pos:[160,12] width:110 height:24 autoDisplay:true
	label lbl7 "7. " pos:[140,44] width:17 height:17 --+26
	pickbutton target7 "object" pos:[160,38] width:110 height:24 autoDisplay:true
	label lbl8 "8. " pos:[140,70] width:17 height:17 --+26
	pickbutton target8 "object" pos:[160,64] width:110 height:24 autoDisplay:true
	label lbl9 "9. " pos:[140,94] width:17 height:17 --+26
	pickbutton target9 "object" pos:[160,90] width:110 height:24 autoDisplay:true
	label lbl10 "10. " pos:[140,122] width:17 height:17 --+26
	pickbutton target10 "object" pos:[160,116] width:110 height:24 autoDisplay:true
		--
	--event statements
	local theLinkerStruct
	
	on makeSplineBTN pressed do 
	(
	--fn theSpliner incomingNodes = REF
		--load target objects into array if they are valid nodes
		local NodesToSend = #()
		if IsValidNode target1.object then (append NodesToSend target1.object)
		if IsValidNode target2.object then (append NodesToSend target2.object)
		if IsValidNode target3.object then (append NodesToSend target3.object)
		if IsValidNode target4.object then (append NodesToSend target4.object)
		if IsValidNode target5.object then (append NodesToSend target5.object)
		if IsValidNode target6.object then (append NodesToSend target6.object)
		if IsValidNode target7.object then (append NodesToSend target7.object)
		if IsValidNode target8.object then (append NodesToSend target8.object)
		if IsValidNode target9.object then (append NodesToSend target9.object)
		if IsValidNode target10.object then (append NodesToSend target10.object)
		--send nodes, size, color, and layer name to the structFunction
		local splineSizeVAL = splineSizeSPN.value
		local theSplineColor = splineColorPicker.color
		local xrayVAL = xrayRadioBTN.state
		local theSplineLayer = splineLayerNameEditText.text
		theSplinerStruct = theLinkerFunction()
		--perform check to make sure NodesToSend has atleast 2 values
		if NodesToSend.count >= 2 then 
		(
			--send the parameters to the function
			theSplinerStruct.theSpliner NodesToSend splineSizeVAL theSplineColor xrayVAL theSplineLayer
		) else (messagebox "You must have at least 2 objects picked for theSpliner to work.")	
	)
	
	on resetSplineBTN pressed do 
	(
		target1.object = undefined
		target2.object = undefined
		target3.object = undefined
		target4.object = undefined
		target5.object = undefined
		target6.object = undefined
		target7.object = undefined
		target8.object = undefined
		target9.object = undefined
		target10.object = undefined
	)
) --end theLinker rollout




rollout support "Support" category:6
	(
	label supportLabel "Errors?  Email: Garrick@GarrickCampsey.com" pos:[30,10] width:250 height:20
)--end Support rollout
	


	
--create floater
grakToolsDEV = newRolloutFloater "GrakTools v0.13" 290 750
--add rollOuts
addRollout StretchyBonesCreator grakToolsDEV rolledUp:false
addRollout theLinker grakToolsDEV rolledUp:true
addRollout theSticker grakToolsDEV rolledUp:true
addRollout theSpliner grakToolsDEV rolledUp:true
addRollout support grakToolsDEV rolledUp:true