--CleanCopyV3
--fixes scaling and preps meshes for rigging and skinning, based in part on garps voroni fracture script 1.1
--by garrickcampsey (JAN.2011) - garrick@garrickcampsey.com
( --start script
global cleanCopy
try destroyDialog cleanCopy catch()
local outputColorValue = (color 0 114 255) --default color value
local randomColorBit = false --decides random color or userPicked
local keepColorBit = false --true = copy inherits paddedSelectionArray[i].wirecolor
local codeBlockCounter --tracks the fn, if error happens, user can send the code block #
local introFeedbackText = "CleanCopy says:
Select some objects, then press the 'Create'
button above. CleanCopy will copy the selected 
objects, reset the Xforms, color code the copies, 
and inherit names and layers.
'Random' assigns random colors to copies." --init feedback text
local feedbackUpdate = undefined --string for feedback/stats update
fn cleanCopyFn = (
	try (
		if $ != undefined then --check for valid selection
		(
			codeBlockCounter = 0
			local geoClassInSelection = #()
			local selectionAsArray = selection as array
			--filter selection by geometryClass
			for i = 1 to selectionAsArray.count do
			(if superclassof selectionAsArray[i] == GeometryClass then (join geoClassInSelection selectionAsArray[i]))
			local paddedSelectionArray = #(0)
			join paddedSelectionArray geoClassInSelection --join geoClassInSelection into padded array
			local PSAcount = paddedSelectionArray.count
			--**1
			codeBlockCounter += 1
			for i = 2 to PSAcount do --skip the padded 0 value
			(
				unfreeze paddedSelectionArray[i] --must unfreeze
				--clean copy paddedSelectionArray[i]
				local theCopy = copy paddedSelectionArray[i]
				theCopy.name = "toto"
				resetXForm theCopy
				convertToPoly theCopy
				local theMesh = editable_mesh()
				theMesh.mesh = theCopy.mesh
				theMesh.transform = theCopy.transform
				resetXForm theMesh
				convertToPoly theMesh
				delete theCopy
				--theMesh inherits name and pivot
				theMesh.name = paddedSelectionArray[i].name
				theMesh.pivot = paddedSelectionArray[i].pivot
				--color inheritance
				if keepColorBit == true then (theMesh.wirecolor = paddedSelectionArray[i].wirecolor)
				if randomColorBit == true then (
					--theMesh inherits a random color 
					fn randomColValue = (return random 44 222);	theMesh.wirecolor = [randomColValue(),randomColValue(),randomColValue()]
				)
				if keepColorBit == false and randomColorBit == false then (theMesh.wirecolor = outputColorValue)
				--theMesh inherits paddedSelectionArray[i]'s layer
				local thePSAiLayer = paddedSelectionArray[i].layer.name
				local layerFound = LayerManager.getLayerFromName thePSAiLayer
				layerFound.addnode theMesh
				--theMesh inherits paddedSelectionArray[i]'s material
				theMesh.material = paddedSelectionArray[i].material
			)
			--**2
			codeBlockCounter += 1
			--delete objs in paddedSelectionArray
			for obj in paddedSelectionArray do try(delete obj) catch()
			--prep values for feedback
			local realPSAcount = (PSAcount - 1) as string --remove padded 0 value for accurate count
			local totalInputCount = selectionAsArray.count as string
			local unrecognizedObjs = (selectionAsArray.count - (PSAcount - 1))
			--**3
			codeBlockCounter += 1
			--format string value for feedback
			feedbackUpdate = "CleanCopy says :\nTotal objs input = " + totalInputCount + "\nTotal objs not recognized = " + unrecognizedObjs as string + "\nTotal objs cleaned = " + realPSAcount + "\n\nCompleted " + codeBlockCounter as string + " of " + codeBlockCounter as string +" code blocks."
		) else (messagebox "You must select at least one object to cleanCopy.")
	) catch(feedbackUpdate = "Error in code block: " + codeBlockCounter as string)
)
--UI
rollout cleanCopy " CleanCopy v3"
(
	--UI
	button runCCBTN "Create clean copies of selected objs" pos:[5,5] width:240 height:20
	label outputColLabel "Color :" pos:[7,32] width:90 height:18
	colorPicker copyColorPicker "" pos:[36,32] width:96 height:13 color:(color 0 114 255)
	checkbox keepColorCheck "Keep" checked:false pos:[137,31]
	checkbox randomColorCheck "Random" checked:false pos:[185,31]
	edittext feedbackBox text:introFeedbackText fieldWidth:235 height:100 pos:[4,52]
	button launchBTN "Launch GrakScripts" pos:[5,156] width:222 height:20
	button whoIsBTN "?" pos:[229,156] width:15 height:20
	on launchBTN pressed do	(try(fileIn "grakscripts.ms")catch(messagebox "Cannot find GrakScripts.ms"))
	--Events
	on copyColorPicker changed theState do (randomColorCheck.state=false; keepColorCheck.state=false; randomColorBit=false; keepColorBit=false; outputColorValue=copyColorPicker.color)
	on randomColorCheck changed theState do (randomColorCheck.state=true; keepColorCheck.state=false; randomColorBit=true; keepColorBit=false; outputColorValue=copyColorPicker.color)
	on keepColorCheck changed theState do (randomColorCheck.state=false; keepColorCheck.state=true; randomColorBit=false; keepColorBit=true; outputColorValue=copyColorPicker.color)
	--
	on runCCBTN pressed do (cleanCopyFn();try(feedbackBox.text = feedbackUpdate) catch())
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
)
createDialog cleanCopy 250 180 100 100 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script
