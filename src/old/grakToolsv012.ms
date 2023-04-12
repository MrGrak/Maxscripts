--GrakTools v1
--Garrick Campsey 2010

--not sure if these need to be global
global AnimCTRLSbuildingArray = #()
global BoneCreatedUnlinkedArray = #()
global LastCreatedBoneChain = #(0)
global radioLabels5_name_array = #()
global SelectedObjectStringArray = #()
global typeOfCTRLtoMake = 0
global typeOfBONEtoMake = 0
global MasterListOfBoneChains = #()
global boneChainNumerator = 1000
global layerColorVAR1 = (color 255 120 0)
global layerColorVAR2 = (color 0 48 255)
global layerColorHidden = (color 0 0 0)
global selectedMesh = 0
global selectedOBJasArrayStartIndex2 = #(0)
global outOrigCTRL = 0
global newCTRLbonesUnlinkedArray = #()
global globalBoneCreateName = "stretchyB"
global globalBoneLayerName = "bones"
global layersToDeleteArray = #()
global sphereRadiusValue = 10
global phelpSizeValue = sphereRadiusValue*2

--functions


--setup StretchyBones layers on layerManager
function buildSBlayers =
	(
		--INIT SB LAYERS
		--creates new layers named stretchyBones and bones_CTRLS
		bonesInitLayerName = "SBC_" + globalBoneLayerName
		layermanager.newLayerFromName bonesInitLayerName
		layermanager.newLayerFromName "SBC_ctrls"
		layermanager.newLayerFromName "SBC_hidden"
		--sets layers into names
		Boneslayer = layermanager.getLayerFromName bonesInitLayerName
		CTRLSlayer = layermanager.getLayerFromName "SBC_ctrls"
		shrinkAndLinklayer = layermanager.getLayerFromName "SBC_hidden"
		--sets layer colors, bones and boneCTRLS inherit layer colors
		shrinkAndLinklayer.wireColor = layerColorHidden
		BonesLayer.wireColor = layerColorVAR1
		CTRLSlayer.wireColor = layerColorVAR2
		shrinkAndLinklayer.isHidden = true
		shrinkAndLinklayer.isFrozen = true
	)


function shrinkAndLink incomingSelectedOBJtoShrink ParentObjectSelected = 
	(
	incomingSelectedOBJtoShrink.pos = ParentObjectSelected.pos
	incomingSelectedOBJtoShrink.parent = ParentObjectSelected
	incomingSelectedOBJtoShrink.scale = [0.5,0.5,0.5]
	freeze incomingSelectedOBJtoShrink
	--put incoming object onto new shrink and link layer
	--creates new layers named stretchyBones and bones_CTRLS
	layermanager.newLayerFromName "SBC_hidden"
	--sets layers into names
	shrinkAndLinklayer = layermanager.getLayerFromName "SBC_hidden"
	
	--add new bones to bonesLayer <node>
	shrinkAndLinklayer.addnode incomingSelectedOBJtoShrink
	hide incomingSelectedOBJtoShrink
	clearSelection()
	shrinkAndLinklayer.isHidden = true
	shrinkAndLinklayer.isFrozen = true
	)

function stickObjToMesh =
	(		
		--accept array as input and check count
		currentlySelectedObjectCount = selectedOBJasArrayStartIndex2.count
		for i=2 to currentlySelectedObjectCount do
		(
		print selectedOBJasArrayStartIndex2[i]
		select selectedOBJasArrayStartIndex2[i]
		--create rays
		
			--CHECK y
			--shoot out ray from $'s current position
			rayToMeshCheckDownY = ray selectedOBJasArrayStartIndex2[i].pos [0,-1,0] --shoots ray yAxis
			--find where the ray intersects the mesh to stick to
			YpositionDWN = intersectRay selectedMesh rayToMeshCheckDownY
			--shoot out ray from $'s current position
			rayToMeshCheckUpY = ray selectedOBJasArrayStartIndex2[i].pos [0,1,0] --shoots ray yAxis
			--find where the ray intersects the mesh to stick to
			YpositionUP = intersectRay selectedMesh rayToMeshCheckUpY

			--print out values
				--y ray check
				positionCHECKvar = 900 --900 value means no rays intersect, 
				--901=negative, 910=positive, 911=both
				--check up
				if YpositionUP != undefined do
				(
				print "y axis ray intersect up = true"
				positionCHECKvar = positionCHECKvar + 10  --set Var to 2 for top
				)
				--check down
				if YpositionDWN != undefined do  
				(
				print "y axis ray intersect down = true"
				positionCHECKvar = positionCHECKvar + 1  --set Var to 1 for bottom
				)
				--checks to move
				if positionCHECKvar == 900 do
				(
				print "Rays emitted from selected on World Yaxis do not intersect with selected mesh."
				)
				--check and compare both y axis top and bottom
				if positionCHECKvar == 901 do
				(
				selectedOBJasArrayStartIndex2[i].pos.y = YpositionDWN.pos.y
				)
				--check and compare both y axis top and bottom
				if positionCHECKvar == 910 do
				(
				selectedOBJasArrayStartIndex2[i].pos.y = YpositionUP.pos.y
				)
 				--check and compare both y axis top and bottom
				if positionCHECKvar == 911 do
				(
					--compare the UP and DWN values, see which is closest $.pos.y value
					print "distance from selected to bottom intersect"
					YdwnCHECK = (abs(abs(YpositionDWN.pos.y) - abs($.pos.y))) --get abs distance value back
					print YdwnCHECK
					print "distance from selected to top intersect"
					YupCHECK = (abs(abs(YpositionUP.pos.y) - abs($.pos.y))) --get abs distance value back
					print YupCHECK
						--compare y
						if YupCHECK < YdwnCHECK then
						(
						selectedOBJasArrayStartIndex2[i].pos.y = YpositionUP.pos.y --move selected
						) else if YupCHECK > YdwnCHECK then
						(
						selectedOBJasArrayStartIndex2[i].pos.y = YpositionDWN.pos.y --move selected
						)
				)--end if
			
			
				
		)
		
		--when its done, clean out the selectedOBJasArrayStartIndex2 array
		selectedOBJasArrayStartIndex2 = #(0)

			

		
	)







--cleans out arrays used to track boneChain creation
function cleanArrays =
	(
		AnimCTRLSbuildingArray = #(0)
		BoneCreatedUnlinkedArray = #(0)
	)

function cleanLastCreatedBoneChain = 
	(
		LastCreatedBoneChain = #(0)
	)
	
function CLEANnewCTRLbonesUnlinkedArray = 
	(
		newCTRLbonesUnlinkedArray = #(0)
	)

function cleanOutMasterListArray = 
	(
		MasterListOfBoneChains = #()
	)









--chainManager
function chainManager chainToManageArray =
	(
	--print "CHAIN MANAGER SAYS...."
	--print "incoming array as is:"
	--print chainToManageArray
	--print "cleaning array of 0 values...."
	incomingChainCount = chainToManageArray.count
		for i=1 to incomingChainCount do --for the count of the array, do
			( 
			zeroValueFound = findItem chainToManageArray 0
			--print "zeroValueFound: "
			--print zeroValueFound
			if zeroValueFound != 0 then 
				(
				deleteItem chainToManageArray zeroValueFound
				)
			)
	--print "array cleaned..."
	--print "array now is:"
	--print chainToManageArray
		cleanedChainCount = chainToManageArray.count
		for i=1 to cleanedChainCount do
		(
			--print "renamer loop active !"
			--rename each item in chainToManageArray to unique prefix
			--print chainToManageArray[i]
			select chainToManageArray[i]
			boneChainNumeratorAsString = boneChainNumerator as string
			$.name = "SBC" + boneChainNumeratorAsString + $.name
			clearSelection()
		)
		boneChainNumerator = boneChainNumerator +1
	
	cleanArrays()
	
	--turn on Scene Redraw
	--enableSceneRedraw()
	
	
 
	)
















--newCTRLSbuilder
function newCTRLSBoneBuilder incomingNEWAnimCTRLSarray origCTRLanchor =
	(
	--clean the array to hold the new bones
	CLEANnewCTRLbonesUnlinkedArray()
	
	--print incomingNEWAnimCTRLSarray
	--print "orig:"
	--print origCTRLanchor
	
	incomingNEWAnimCTRLSarrayCOUNT = incomingNEWAnimCTRLSarray.count
	for i = 2 to incomingNEWAnimCTRLSarrayCOUNT do
	(
		buildPOS3 = incomingNEWAnimCTRLSarray[i].pos
		buildPOS4 = origCTRLanchor.pos
		nubBoneBuildPOS5 = incomingNEWAnimCTRLSarray[i].pos + [0,0,10]
		freshBone2 = BoneSys.createBone buildPOS4 buildPOS3 [0,0,1] --the stretchy bone
		freshBone3 = BoneSys.createBone buildPOS3 nubBoneBuildPOS5 [0,0,1] --the nubBone
		
		
		
		--position constrain freshBone3 to newCTRLs
		posConstraintVariable9 = Position_Constraint()
		freshBone3.pos.controller = posConstraintVariable9
		positionConstraintInterface = posConstraintVariable9.constraints
		positionConstraintInterface.appendtarget incomingNEWAnimCTRLSarray[i] 100
		
		--link up each pair of new bones
		freshBone3.parent = freshBone2
		
		--position constrain freshBone2 to origCTRL
		posConstraintVariable10 = Position_Constraint()
		freshBone2.pos.controller = posConstraintVariable10
		positionConstraintInterface = posConstraintVariable10.constraints
		positionConstraintInterface.appendtarget origCTRLanchor 100
		clearSelection()
		
		
		--add new bones to bonesLayer
		bonesInitLayerName = "SBC_" + globalBoneLayerName
		Boneslayer = layermanager.getLayerFromName bonesInitLayerName
		BonesLayer.addnode freshBone2
		
		--put nubBone on hiddenlayer
		shrinkAndLinklayer = layerManager.getLayerFromName "SBC_hidden"
		shrinkAndLinklayer.addnode freshBone3
		shrinkAndLinklayer.isHidden = true
		shrinkAndLinklayer.isFrozen = true
		
		
		--perform ops on stretchBone
		--select freshBone2 
		freshBone2.boneFreezeLength = false
		freshBone2.wirecolor = layerColorVAR1
		--boneChainPrefix
		freshBone2.name = uniqueName "stretchyB"
		freshBone3.name = uniqueName "nubB"
		freshBone3.scale = [0.2,0.2,0.2]
		
		freshBone2.renderable = false
		if (typeOfBONEtoMake == 1) do 
				(
				--sets bones to boxMode
				freshBone2.boxmode = on
				)


		--lookAt constraints
		--select BoneCreatedUnlinkedArray[i]
		lookAtConstraintVariable = lookAt_Constraint()
		freshBone2.rotation.controller = lookAtConstraintVariable
		positionConstraintInterface = lookAtConstraintVariable.constraints
		--tempSphereArrayNum = AnimCTRLSbuildingArray[i+1]
		positionConstraintInterface.appendtarget incomingNEWAnimCTRLSarray[i] 100
		freshBone2.rotation.controller.viewline_length_abs = off

		--perform ops on nubBone
		select freshBone3
		$.renderable = false
		hide $
		clearSelection()
		
		--registerChain into currentChain's naming convention
		--print "original control $:"
		--print origCTRLanchor
		tokenStringVar = ":_"
		origCTRLanchorAsString = origCTRLanchor as string
		characterSplitVAR2 = filterString origCTRLanchorAsString tokenStringVar
		--print ": character split"
		--print characterSplitVAR2[1]
		--print characterSplitVAR2[2]

		NamingConventionOfSelectedsName2 = substring characterSplitVAR2[2] 1 7
		NamingConventionString2 = NamingConventionOfSelectedsName2
		--print NamingConventionOfSelectedsName2
		
		
		
		
		--name new bones after naming convention
		--$.name = "SBchain" + boneChainNumeratorAsString + $.name
		freshBone2.name = NamingConventionOfSelectedsName2 + freshBone2.name	
		--print freshBone2
		--and 3
		freshBone3.name = NamingConventionOfSelectedsName2 + freshBone3.name	
		--print freshBone3
		
		--append bones into newCTRLbonesUnlinkedArray
		append newCTRLbonesUnlinkedArray freshBone2
		append newCTRLbonesUnlinkedArray freshBone3
		
		
		
	)
	
	--append these bones into lastCreated array
	join incomingNEWAnimCTRLSarray newCTRLbonesUnlinkedArray
	--print "*********************THIS IS LAST CREATED BONECHAIN STRING:"
	--print incomingNEWAnimCTRLSarray
	
	--get the last bone chain array ready
	cleanLastCreatedBoneChain()
	deleteItem LastCreatedBoneChain 1
		
	--remove zeros from array
	LastCreatedBoneChainCOUNT2 = incomingNEWAnimCTRLSarray.count
	for i = 1 to LastCreatedBoneChainCOUNT2 do
		(
		--print incomingNEWAnimCTRLSarray[i]
		--remove all zero values
		zeroValueFound2 = findItem incomingNEWAnimCTRLSarray 0
		if zeroValueFound2 != 0 then 
				(
				deleteItem incomingNEWAnimCTRLSarray zeroValueFound2
				)
		
		
		--remove <Deleted scene node> possibility 
		TempCHAINcheck = isValidNode incomingNEWAnimCTRLSarray[i]
		if TempCHAINcheck == true then
			(
			--then it is a scene node
			--print "Is a scene node:"
			--print incomingNEWAnimCTRLSarray[i]
			--if it is a valid scene node, then add it into the last created BC array
			append LastCreatedBoneChain incomingNEWAnimCTRLSarray[i]
			) else (
					--it isn't a scene node (is deleted scene node)
					--print "Deleted Scene Node:"
					--print incomingNEWAnimCTRLSarray[i]
					)			
		
	
		)
		
	--print LastCreatedBoneChain

	--clean arrays
	cleanArrays()
		
	
)







function genNewCTRLS origCTRL newCTRLSnum =
		(
			--print "genNewCTRLS: origCTRL, newCTRLSnum..."
			--print origCTRL
			--print newCTRLSnum
			
			--print "original CTRLs position:"
			origCTRLPosition = origCTRL.pos
			--print origCTRLPosition
			
			newCTRLPosition = origCTRLPosition + [0,0,30]
			--print "newCTRLPosition:"
			--print newCTRLPosition
			
			rotation180VAL = -360/(newCTRLSnum) --180 variable
			--variable to hold origCTRL position
			--build spheres offset 100 up
			
			for i = 1 to newCTRLSnum do
				(
					if (typeOfCTRLtoMake == 0) then 
					(
					Sphere radius:sphereRadiusValue smooth:on segs:10 chop:0 slice:off \
					sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
					pos:newCTRLPosition isSelected:on
					$.wirecolor = layerColorVAR2
					)
	 				else if (typeOfCTRLtoMake == 1) then
					(
					Point pos:newCTRLPosition isSelected:on size:phelpSizeValue
					$.Box = on
					$.wirecolor = layerColorVAR2
					$.drawontop = on
					)
				
				$.pivot = origCTRLPosition
				rotateVal = i*rotation180VAL
				rotate $ rotateVal y_axis
				resetPivot $
				
				$.name = ".child"
				$.renderable = false
				CTRLSlayer = layermanager.getLayerFromName "SBC_ctrls"
				CTRLSlayer.addnode $ 
				append AnimCTRLSbuildingArray $
				
				
				--registerChain into currentChain's naming convention
				--print "original control $:"
				--print origCTRL
				tokenStringVar2 = ":_"
				origCTRLAsString = origCTRL as string
				characterSplitVAR3 = filterString origCTRLAsString tokenStringVar2
				--print ": character split"
				--print characterSplitVAR3[1]
				--print characterSplitVAR3[2]
				
				
				--determine bonechain number
				NamingConventionOfSelectedsName3 = substring characterSplitVAR3[2] 1 7 
				NamingConventionString3 = NamingConventionOfSelectedsName3
				print NamingConventionOfSelectedsName3
				
				--determine bonechain number
				NamingConventionOfSelectedsName9 = substring characterSplitVAR3[2] 8 6 
				NamingConventionString3 = NamingConventionOfSelectedsName9
				print NamingConventionOfSelectedsName9
				
				--print NamingConventionOfSelectedsName3
				
				--name new bones after naming convention
				--$.name = "SBchain" + boneChainNumeratorAsString + $.name
				$.name = NamingConventionOfSelectedsName3 + NamingConventionOfSelectedsName9 + $.name	
				--print $
				






				)
			--print "......building done"
		

		
		--send out array of animCTRL spheres
		newCTRLSBoneBuilder AnimCTRLSbuildingArray origCTRL
		
		)








--boneBuilder
function boneBuilder incomingAnimCTRLSarray TypeOfBuild2 =
	(
	incomingTotCount = incomingAnimCTRLSarray.count
	
	--following loop builds bone sys to sphere's position
	for i = 2 to incomingTotCount-1 do
		(
		buildPOS1 = incomingAnimCTRLSarray[i].pos
		buildPOS2 = incomingAnimCTRLSarray[i+1].pos
		freshBone = BoneSys.createBone buildPOS1 buildPOS2 [0,0,1]
		select freshBone 
		setTransformLockFlags $ #all
		freshBone.boneFreezeLength = false
		freshBone.wirecolor = layerColorVAR1
		--boneChainPrefix
		freshBone.name = uniqueName "stretchyB"
		$.renderable = false
		if (typeOfBONEtoMake == 1) do 
				(
				--sets bones to boxMode
				$.boxmode = on
				)
		--add new bones to bonesLayer
		bonesInitLayerName = "SBC_" + globalBoneLayerName
		Boneslayer = layermanager.getLayerFromName bonesInitLayerName
		BonesLayer.addnode $
		append BoneCreatedUnlinkedArray $
		clearSelection()
		)
		
	--following loop parents bones to each other
	for i = 2 to incomingTotCount-2 do
		(
		tempChildBone = BoneCreatedUnlinkedArray[i+1]
		tempParentBone = BoneCreatedUnlinkedArray[i]
		tempChildBone.parent = tempParentBone --links up bone system
		)
	
	--following loop constrains bones to spheres	
	for i = 2 to incomingTotCount-1 do
		(
		select BoneCreatedUnlinkedArray[i] 
		posConstraintVariable = Position_Constraint()
		$.pos.controller = posConstraintVariable
		positionConstraintInterface = posConstraintVariable.constraints
		tempSphereArrayNum = AnimCTRLSbuildingArray[i]
		positionConstraintInterface.appendtarget tempSphereArrayNum 100
		clearSelection()
		)
		
 	--following loop adds lookAt controllers to bones to see spheres	
	for i = 2 to incomingTotCount-1 do
		(
		select BoneCreatedUnlinkedArray[i] 
		lookAtConstraintVariable = lookAt_Constraint()
		$.rotation.controller = lookAtConstraintVariable
		positionConstraintInterface = lookAtConstraintVariable.constraints
		tempSphereArrayNum = AnimCTRLSbuildingArray[i+1]
		positionConstraintInterface.appendtarget tempSphereArrayNum 100
		$.rotation.controller.viewline_length_abs = off
		clearSelection()
		)
	
			if TypeOfBuild2 == 1 then 
			(
				--clean up end sphere and nubBone
				_theLastBone = BoneCreatedUnlinkedArray.count
				BoneCreatedUnlinkedArrayLastBone = BoneCreatedUnlinkedArray[_theLastBone]
				
				
				select BoneCreatedUnlinkedArrayLastBone
				$.name = uniqueName "nubB"
				BoneCreatedUnlinkedArrayLastBone.scale = [0.02,0.02,0.02]
				--put nubBone on hiddenlayer
				shrinkAndLinklayer = layermanager.getLayerFromName "SBC_hidden"
				shrinkAndLinklayer.addnode $
				shrinkAndLinklayer.isHidden = true
				shrinkAndLinklayer.isFrozen = true
				hide $
				clearSelection()
				
				_theLastSphere = AnimCTRLSbuildingArray.count
				_theNext2LastSphere = AnimCTRLSbuildingArray.count-1
				 
				--shrink it and link it back to the 2nd to last sphere, taking the nubBone with it
				AnimCTRLSbuildingArray[_theLastSphere].pos = AnimCTRLSbuildingArray[_theNext2LastSphere].pos
				AnimCTRLSbuildingArray[_theLastSphere].parent = AnimCTRLSbuildingArray[_theNext2LastSphere]
				
				--grab last sphere
				clearSelection()
				select AnimCTRLSbuildingArray[_theLastSphere]
				
				--lock all the transforms
				setTransformLockFlags $ #all 
				AnimCTRLSbuildingArray[_theLastSphere].scale = [0.5,0.5,0.5]
				--put sphere on hiddenlayer
				shrinkAndLinklayer = layermanager.getLayerFromName "SBC_hidden"
				shrinkAndLinklayer.addnode $
				shrinkAndLinklayer.isHidden = true
				shrinkAndLinklayer.isFrozen = true
				hide $
				clearSelection()
				
				--let go of sphere
				clearSelection()
				
				
				
				
				
			) 
			else if TypeOfBuild2 == 2 then
			(
				--rename last bone and hide it
				_theLastBone = BoneCreatedUnlinkedArray.count 
				BoneCreatedUnlinkedArray[_theLastBone].name = uniqueName "nubB"
				--scale the nubBone down to nothin
				BoneCreatedUnlinkedArray[_theLastBone].scale = [0.02,0.02,0.02]
				BoneCreatedUnlinkedArrayLastBone = BoneCreatedUnlinkedArray[_theLastBone]
				--put nubBone on hiddenlayer
				shrinkAndLinklayer = layermanager.getLayerFromName "SBC_hidden"
				select BoneCreatedUnlinkedArrayLastBone
				shrinkAndLinklayer.addnode $
				shrinkAndLinklayer.isHidden = true
				shrinkAndLinklayer.isFrozen = true
				hide $
				clearSelection()
				
				--select last sphere and shrink and link it to 2nd to last
				_theLastSphere = AnimCTRLSbuildingArray.count
				_the2ndToLastSphere = AnimCTRLSbuildingArray.count-1
				
				AnimCTRLSbuildingArray[_theLastSphere].pos = AnimCTRLSbuildingArray[_the2ndToLastSphere].pos
				AnimCTRLSbuildingArray[_theLastSphere].parent = AnimCTRLSbuildingArray[_the2ndToLastSphere]
				print "last control in build"
				print AnimCTRLSbuildingArray[_theLastSphere]
				
				--pos constrain AnimCTRLSbuildingArray[_theLastSphere]
				
				select AnimCTRLSbuildingArray[_theLastSphere] 
				--setup position constraint
				posConstraintVariable = Position_Constraint()
				$.pos.controller = posConstraintVariable
				positionConstraintInterface = posConstraintVariable.constraints
				positionConstraintInterface.appendtarget AnimCTRLSbuildingArray[_the2ndToLastSphere] 100
				hide $ --last sphere doesn't need to be visible
				--put last sphere on hidden layer
				shrinkAndLinklayer.addnode $
				clearSelection()
				
				AnimCTRLSbuildingArray[_theLastSphere].scale = [0.1,0.1,0.1]
				AnimCTRLSbuildingArray[_the2ndToLastSphere].scale = [0.2,0.2,0.2]
				

				--shrinkAndLink AnimCTRLSbuildingArray[_theLastSphere] AnimCTRLSbuildingArray[_the2ndToLastSphere]
				
				--select 2nd to last sphere and link it to first sphere
				_theNextLastSphere = AnimCTRLSbuildingArray.count-1
				_theFirstSphere = AnimCTRLSbuildingArray.count+2-AnimCTRLSbuildingArray.count
				--
				select AnimCTRLSbuildingArray[_theNextLastSphere] 
				--setup position constraint
				posConstraintVariable = Position_Constraint()
				$.pos.controller = posConstraintVariable
				positionConstraintInterface = posConstraintVariable.constraints
				positionConstraintInterface.appendtarget AnimCTRLSbuildingArray[_theFirstSphere] 100
				hide $ --last sphere doesn't need to be visible
				--put last sphere on hidden layer
				shrinkAndLinklayer.addnode $
								
				clearSelection()			
			)
		
		--clean out last created bone chain array
		cleanLastCreatedBoneChain()
		--remove 0 value from array
		deleteItem LastCreatedBoneChain 1
				
		--append freshly created bones and spheres to unique array
		join LastCreatedBoneChain BoneCreatedUnlinkedArray
		join LastCreatedBoneChain AnimCTRLSbuildingArray
		--print "last created bone chain array: "
		--print LastCreatedBoneChain
		
		--send last chain to chainManager
		chainManager(LastCreatedBoneChain)
	)









--generate animation controls, type, and position
function genAnimCTRLS boneNumToBuild TypeOfBuild =
	(
		--logic check, what type to build? 1=line, 2=circle
		if TypeOfBuild == 1 then
		(
		--build spheres in line
		undo off
		for i = 1 to boneNumToBuild+1 do
			(
				if (typeOfCTRLtoMake == 0) then 
				(
				Sphere radius:sphereRadiusValue smooth:on segs:10 chop:0 slice:off \
				sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
				pos:[(i*50-50),0,0] isSelected:on
				$.wirecolor = layerColorVAR2
				)
 				else if (typeOfCTRLtoMake == 1) then
				(
				Point pos:[(i*50-50),0,0] isSelected:on size:phelpSizeValue
				$.Box = on
				$.wirecolor = layerColorVAR2
				$.drawontop = on
				)
				
				$.name = uniqueName "ctrl"
				$.renderable = false
				CTRLSlayer = layermanager.getLayerFromName "SBC_ctrls"
				CTRLSlayer.addnode $ 
				append AnimCTRLSbuildingArray $
			)
		
		--send out array of animCTRL spheres
		boneBuilder AnimCTRLSbuildingArray 1
		) 
		
		--logic check, what type to build? 1=line, 2=circle
		else if TypeOfBuild == 2 then
		(
		--get tot count of incoming array
		rotationMultiplierVAL = 360/(boneNumToBuild-1)
		--build spheres in circle
		for i = 1 to boneNumToBuild+1 do
			(
				if (typeOfCTRLtoMake == 0) then 
				(
				Sphere radius:sphereRadiusValue smooth:on segs:10 chop:0 slice:off \
				sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
				pos:[0,0,100] isSelected:on
				$.wirecolor = layerColorVAR2
				)
 				else if (typeOfCTRLtoMake == 1) then
				(
				Point pos:[0,0,100] isSelected:on size:phelpSizeValue
				$.Box = on
				$.wirecolor = layerColorVAR2
				$.drawontop = on
				)
			
			$.pivot=[0,0,0]
			rotateVal = i*rotationMultiplierVAL
			rotate $ rotateVal y_axis
			resetPivot $

			$.name = uniqueName "ctrl"
			$.renderable = false
			CTRLSlayer = layermanager.getLayerFromName "SBC_ctrls"
			CTRLSlayer.addnode $ 
			append AnimCTRLSbuildingArray $
			)
		
		
		
		--send out array of animCTRL spheres
		boneBuilder AnimCTRLSbuildingArray 2
		)
	)

































--rollOut structures
--theSticker DEV
rollout theSticker "The Sticker v0.02" category:2
	(	
				
		button _callFunc "  Stick along World yAxis to:  " pos:[5,10] tooltip:"Select an object, then press to stick it."
		on _callFunc pressed do 
		(
		if $ != undefined then --is selected a valid node?
			(
			--SelectedNodeTest = IsValidNode $
			--if SelectedNodeTest == true then
				--(
					--logic to check if pick'd mesh is still valid scene node
					--print selectedMesh
					selectedMeshCheck = isValidNode selectedMesh
					if selectedMeshCheck == true then
					(
						--take selection and put it into array starting as index2
						theStuffSelected = selection as array
						join selectedOBJasArrayStartIndex2 theStuffSelected
						--print "button pressed, outgoing array:"
						--print selectedOBJasArrayStartIndex2
						--then call function
						stickObjToMesh()
					) else (
					messagebox "No target defined for the projection."
					)
					
					
					
					
					
					
				--) else (
				--messagebox "Please select only ONE object."
				--)	
			) else (
			messagebox "Please select a valid scene node."
			)
		
		)
		
		

		pickbutton meshToStickToBTN "object" tooltip:"Pick a scene object to stick stuff to." autoDisplay:true \
		width:70 pos:[162,10]
		on meshToStickToBTN picked obj do 
		if isValidNode obj do 
		(
		meshToStickToBTN.tooltip = "You picked " + obj.name
		selectedMesh = meshToStickToBTN.object
		)
		
		
		
	)


























rollout StretchyBonesCreator "Stretchy Bones Creator v0.12" category:1
	(
	
	label ctrlsLabel "Control Object parameters:" pos:[2,5]
	
	--control object radio buttons
	radiobuttons CTRLobjPicker labels:#("Spheres ", "P.Helpers") default:1 pos:[10,22]
	radiobuttons which_obj labels:radioLabels5_name_array -- computed label array
	--print CTRLobjPicker
	--print CTRLobjPicker.label[0]
	on CTRLobjPicker changed state do (
        case state of
        (
            1: (typeOfCTRLtoMake = 0)
            2: (typeOfCTRLtoMake = 1)
        )
	)
	
	--color picker for control objects
	colorpicker controlObjectsColor "" color:[0,48,255] modal:false pos:[164,15] fieldWidth:65
 	on controlObjectsColor changed new_col do layerColorVAR2 = new_col
	
	--spheres radius size
	spinner sphereRadius "Size:" range:[0.01,1000,10] type:#integer pos:[10,43] fieldwidth:35
	on sphereRadius entered do
	( 
		sphereRadiusValue = sphereRadius.value
		phelpSizeValue = sphereRadiusValue*2
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	label bonesLabel "Bone Object parameters:" pos:[2,70]
	
	
	--control object radio buttons
	radiobuttons BONEobjPicker labels:#("Bone      ", "BoxMode") default:1 pos:[10,85]
	radiobuttons which_obj2 labels:radioLabels5_name_array -- computed label array
	on BONEobjPicker changed state do (
        case state of
        (
            1: (typeOfBONEtoMake = 0)
            2: (typeOfBONEtoMake = 1)
        )
	)
	
	--color picker for bone objects
	colorpicker boneObjectsColor "" color:[255,120,0] modal:false pos:[164,78] fieldWidth:65
 	on boneObjectsColor changed new_col do layerColorVAR1 = new_col
		
	--bone name input field
	edittext boneLayerTxt fieldWidth:120 text:"bones" pos:[0,114]	
	on boneLayerTxt entered txt do
	(
		--And the name is not the empty string,
		if txt != "" do 
			(
			globalBoneLayerName = boneLayerTxt.text
			)

	)
	
	button _setBoneLayer "> Set Bone Layer" width:105 pos:[128,112] tooltip:"Sets the layer for the newly created bones."
		on _setBoneLayer pressed do 
		(
		globalBoneLayerName = boneLayerTxt.text 
		)




















	
	--num of bones spinner
	spinner bones_amt "# of Stretchy Bones to create:  " range:[1,10,1] type:#integer pos:[15,160] fieldwidth:50
	
	--generate bones in a line button
	button _callFunc "Generate Bones In a Line" width:230 pos:[3,188] tooltip:"Creates a line of bones in a chain based on the input above."
		on _callFunc pressed do 
		(
		buildSBlayers()
		cleanLastCreatedBoneChain()
		outGoingBonesAmt = bones_amt.value+1
		genAnimCTRLS outGoingBonesAmt 1  
		)
	--generate bones in a circle button
	button _callFunc2 "Generate Bones In a Circle" width:230 pos:[3,210] tooltip:"Creates a closed ring of bones in a chain based on the input above."
		on _callFunc2 pressed do 
		(
		if bones_amt.Value > 2 then
			(
			buildSBlayers()
			cleanLastCreatedBoneChain()
			outGoingBonesAmt = bones_amt.value+1
			genAnimCTRLS outGoingBonesAmt 2
			)
			else 
			(
			messagebox "Requires minimum of 3 bones"
			)

		)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--Adding CTRLS
		--num of CTRLs spinner
		spinner CTRLS_amt2 "" range:[1,20,1] type:#integer pos:[80,248] fieldwidth:20
		--ADD single control
		button _addSingleControl " > ADD < " width:70 pos:[5,245] tooltip:"Adds a CTRL and bone to the selected CTRL."
		--CTRLS to:		
		label Labelto2 " CTRLS to selected OBJ" pos:[115,250]
		
		
		on _addSingleControl pressed do 
				(
				--check to see if CTRL pickbutton OBJ is valid scene node if true ( 
				if isValidNode $ then 
					(
					--call function
					genNewCTRLS $ CTRLS_amt2.value
					) else (
					messagebox "Please only one object to ADD to."
					)
				)
		
	
	
	--SHRINK AND LINK
	label LabelShrinkAndLink1 "Shrink+Link selected to:" pos:[5,280]
	--parent obj pickBUTTON
	pickbutton ShrinkAndLinkParentBTN "PARENT" tooltip:"Pick a scene object for the PARENT." autoDisplay:true \
	width:110 pos:[123,277]
	on ShrinkAndLinkParentBTN picked obj do 
	if isValidNode obj do 
	(
	ShrinkAndLinkParentBTN.tooltip = "You picked " + obj.name
	--ShrinkAndLinkParentMesh = ShrinkAndLinkParentBTN.object
	)
	--DO IT button
	button DOITBTN " > Shrink + Link < " width:110 pos:[123,301] tooltip:"ShrinkAndLinks the Selected object to the PARENT object."
	on DOITBTN pressed do 
				(
				--check to see if CTRL pickbutton OBJ is valid scene node if true ( 
				if isValidNode $ then 
					(
						--check to see if parent is validNode
						--print ShrinkAndLinkParentBTN.object
						if isValidNode ShrinkAndLinkParentBTN.object then
						(
						--call shrink and link function
						shrinkAndLink $ ShrinkAndLinkParentBTN.object
						
						--clear out ShrinkAndLinkParentBTN.object
						ShrinkAndLinkParentBTN.object = undefined
						
						
						
						
						) else (
								messagebox "Please select a valid PARENT object."
								)
					) else (
					messagebox "Please only one object to ADD to."
					)
				
				)

	
	
	
	
	
	

	--delete last created button
	button deleteLastCreatedBTN "UNDO create last boneChain" width:230 pos:[3,350] tooltip:"An UNDO button for the last created bone chain."
		on deleteLastCreatedBTN pressed do 
			(
			--logic check to see if lastCreated chain still exists
			LastCreatedBoneChainCount = LastCreatedBoneChain.count
			--print "**************UNDO PRESSED****************last created bonechain:"
			--print LastCreatedBoneChain
			
			
			--for the count do
			--check if node is real
			--if real, delete
			--else, print 'node is not real'
			
			for i = 1 to LastCreatedBoneChainCount do
				(
				local isNodeRealCheck = IsValidNode LastCreatedBoneChain[i]
				if isNodeRealCheck == true then
					(
						select LastCreatedBoneChain[i]
						delete $
					) else (
							--print "***********UNDO Selected is not a valid scene node:"
							--print LastCreatedBoneChain[i]
							)
				)
			cleanLastCreatedBoneChain()
			)
			
		
	
	--delete selected button
	button DeleteSelectedBTN "Delete SELECTED object and chain" width:230 pos:[3,374] tooltip:"Deletes the currently selected bone chain."
		on DeleteSelectedBTN pressed do 
			(
				--check that something is selected
				if ($ != undefined) then
				(
				IsSelectionSingle = selection as array
				selectionAsArrayCount = IsSelectionSingle.count
					if selectionAsArrayCount == 1 then
						(
				

								tokenStringVar = ":_"
								SelectedObjectStringArrayIndex = $ as string
								characterSplitVAR = filterString SelectedObjectStringArrayIndex tokenStringVar
								--print ": character split"
								--print characterSplitVAR[1]
								--print characterSplitVAR[2]
								
								
																
								
								NamingConventionOfSelectedsName = substring characterSplitVAR[2] 1 7
								NamingConventionString = NamingConventionOfSelectedsName
								print "delete by:"
								print NamingConventionString
								
								
								
								
								--select all the boneChains
								select $SBC*
								selectionAsArray = selection as array
								--print "all SBchains selected as:"
								--print selectionAsArray
								
								selectionAsArrayCount = selectionAsArray.count
								--print "matching Naming Convention..."
								for i=1 to selectionAsArrayCount do --for the total do
									(
									--turn each array index into a string
									selectionsIndexAsString = selectionAsArray[i] as string
									--<integer>findString <string> <search_string>
									--returns num index if true, undefined if false
									matchingStringNamingConvention = findString selectionsIndexAsString NamingConventionString
									if matchingStringNamingConvention != undefined do
										(
										select selectionAsArray[i]
										--print "match found:"
										--print selectionAsArray[i]
										delete $
										)						
									)
						) else
						(
						messagebox "Please select only one object."
						)					
							
				) else 
				(
				messagebox "Nothing Selected. Please select one object."
				)
			)
			
			
			
			
	--delete all button
	button deleteAllBTN "Reset StretchyBones Creator" width:150 pos:[83,415] tooltip:"Deletes ALL stretchy bones and controls from the scene."
		on deleteAllBTN pressed do 
			(
			--deletes all objects with the following naming convention
			delete $SBC*
			
			--check other layers for SBC naming convention
			checkLayerCount = layerManager.count
			print "layer count"
			print checkLayerCount
			for i = 0 to checkLayerCount+1 do
			(
				firstLayer = layermanager.getlayer i
				--is getLayer i undefined?
				if (layermanager.getlayer i) != undefined do
				(
					
					firstLayerName = firstLayer.name
					print "layer targeting"
					print firstLayerName
					
					
					
					checkLayersForSBC = substring firstLayerName 1 4
					print checkLayersForSBC
					--parse firstLayerName
					--if match SBC_, delete
					if checkLayersForSBC == "SBC_" do
						(
						print "match found - should delete layer!!!!"
						
						--append layer name into layersToDeleteArray
						append layersToDeleteArray firstLayerName
						)
				)
			
				
			)
			
			--get all layersToDeleteArray count
			--for the count
			--delete the layer by name
			
			print layersToDeleteArray
			layersToDeleteArrayCount = layersToDeleteArray.count
			for i = 1 to layersToDeleteArrayCount do
			(
				theLayerBeingDeleted = layersToDeleteArray[i]
				layerManager.deleteLayerByName theLayerBeingDeleted
			)

			--clear out layer to delete array
			layersToDeleteArray = #()
			--clean out arrays
			cleanArrays()
			--clean out masterList too
			cleanOutMasterListArray()
			
				
			)
)






--easyPlanes
rollout easyPlanesRollout "easyPlanes v0.01" category:3
	(
	--set max to modeling mode
	button _onModelingBTN "easyPlanes ON" width:90 pos:[15,5]
		on _onModelingBTN pressed do 
			(
				--modeling environment actions
				layermanager.newLayerFromName "easyPlanes"
				ModelingENVlayer = layermanager.getLayerFromName "easyPlanes"
				Plane length:200 width:200 pos:[0,100,100] isSelected:on
				rotateVal = 90
				rotate $ rotateVal x_axis
				$.name = "easyPlanes_Front_Plane"
				$.lengthsegs = 20
				$.widthsegs = 20
				$.backfacecull = on
				$.material = meditMaterials[23]
				ModelingENVlayer.addnode $
				clearSelection()
				--2
				Plane length:200 width:200 pos:[100,0,100] isSelected:on
				rotateVal = 90
				rotate $ rotateVal y_axis
				rotate $ (angleaxis -180 [0,0,1])
				$.name = "easyPlanes_Left_Plane"
				$.lengthsegs = 20
				$.widthsegs = 20
				$.backfacecull = on
				$.material = meditMaterials[24]
				ModelingENVlayer.addnode $
				clearSelection()
				--setup mats
				meditMaterials[23].selfIllumAmount = 100
				meditMaterials[23].diffuseMap = Bitmaptexture fileName:""
				meditMaterials[24].selfIllumAmount = 100
				meditMaterials[24].diffuseMap = Bitmaptexture fileName:""
					
			)
			
	--turn off modeling mode
	button _offModelingBTN "easyPlanes OFF" width:90 pos:[130,5]
		on _offModelingBTN pressed do 
			(
				--remove IMG planes
				select $easyPlanes_*
				if $ != undefined do
				(
				delete $
				)
				--remove layer
				layermanager.deleteLayerByName "easyPlanes"
				--reset materials
				meditMaterials[23].selfIllumAmount = 0
				meditMaterials[23].diffuseMap = undefined
				meditMaterials[24].selfIllumAmount = 0
				meditMaterials[24].diffuseMap = undefined	
					
			)
			

	)



--support
rollout support "Support" category:4
	(
	label WhoWroteIt "Email: Garrick@GarrickCampsey.com" pos:[31,10]
	)

--onRunScript actions
cleanArrays()



--finally, create the Dialog
grakToolsDEV = newRolloutFloater "GrakTools v0.1" 250 610
--add the rollOuts
addRollout StretchyBonesCreator grakToolsDEV rolledUp:false
addRollout easyPlanesRollout grakToolsDEV rolledUp:true
addRollout theSticker grakToolsDEV rolledUp:false
addRollout support grakToolsDEV rolledUp:false
