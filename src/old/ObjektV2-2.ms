--Template
--by garrickcampsey (JAN.2011) - garrick@garrickcampsey.com
( --start script
global OBJKTcontainerRollout
try destroyDialog OBJKTcontainerRollout catch()
--SCRIPT VALUES
local codeBlockCounter --tracks the fn, if error happens, user can send the code block #
local feedbackUpdate = undefined --string for feedback/stats update
local initbuildObjektDDarray = #("Temp1", "Temp2","Temp3", "Temp4",\
"Temp5", "Temp6", "Temp7")






























fn buildObjekt = (
--try (
	codeBlockCounter = 0
	--
	
	
	
	--**1
	codeBlockCounter += 1
	--
	--build the file
	f=createFile "test2.objekt"
	format "Name:%" "myName\n" to:f
	format "Type:%" "myType\n" to:f
	format "Size:%" "mySize\n" to:f
	format "Created:%" "10.12.23\n" to:f
	close f
	--open the file and parse data
	o=openFile "test2.objekt" mode:"r+"
	skipToString o "Size:"
	myReadData = readLine o
	close o
	
	
	
	--format string value for feedback
	feedbackUpdate = myReadData
	--feedbackUpdate = "Template says:\nCompleted " + codeBlockCounter as string + " of " + codeBlockCounter as string +" code blocks."
--) catch(feedbackUpdate = "Error in code block: " + codeBlockCounter as string)
)




























rollout OBJKTcontainerRollout " Objekt v2"
(subrollout OBJKT_SUB)
rollout saveAndLoadRollout " Save and Load"
(
	label lab1 "Load Objekt file :" pos:[15,15]
	checkbutton openObjektFileCB "Click Here" checked:false pos:[98,12] width:210 height:20
	--
	label lab2 "Build Objekt :" pos:[32,42]
	dropdownlist buildObjektDD items:initbuildObjektDDarray selection:1 pos:[98,37] width:210 enabled:true
	--
	label lab3 "Save Name :" pos:[33,69]
	edittext saveObjektNameET text:"..." fieldWidth:208 height:20 pos:[95,64]
	checkbox saveRanValuesCHK "Save Random Values" checked:true pos:[98,90]
	button saveObjektFileBTN "Save" checked:false pos:[238,88] width:70 height:20
	--
	label lab4 "Delete Objekt :" pos:[24,117]
	dropdownlist buildObjektDD2 items:initbuildObjektDDarray selection:1 pos:[98,112] width:210 enabled:true
)
rollout buildObjektRollout " Objekt Properties"
(
	edittext feedbackBox text:"Objekt says: Let's make some objekts." fieldWidth:303 height:20 pos:[2,550]
	local syncTheRollout --declare in rollout scope
	--
	
	--Box Properties
	spinner widthSPN "Width:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[13,10] enabled:true
	checkbutton widthranBTN "random" checked:false pos:[106,10] width:45 height:16 enabled:true
	spinner widthranminSPN "min:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[155,10] enabled:true
	spinner widthranmaxSPN "max:" range:[0,1000,200.00] type:#float fieldwidth:45 pos:[232,10] enabled:true
	spinner heightSPN "Height:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[10,30] enabled:true
	checkbutton heightranBTN "random" checked:false pos:[106,30] width:45 height:16 enabled:true
	spinner heightranminSPN "min:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[155,30] enabled:true
	spinner heightranmaxSPN "max:" range:[0,1000,200.00] type:#float fieldwidth:45 pos:[232,30] enabled:true
	spinner lengthSPN "Length:" range:[0,1000,1.00] type:#float fieldwidth:45 pos:[8,50] enabled:true
	checkbutton lengthranBTN "random" checked:false pos:[106,50] width:45 height:16 enabled:true
	spinner lengthranminSPN "min:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[155,50] enabled:true
	spinner lengthranmaxSPN "max:" range:[0,1000,200.00] type:#float fieldwidth:45 pos:[232,50] enabled:true
	--editPoly properties
	checkbox hasTopFaceCHK "Remove Top Face" checked:true pos:[30,70]
	checkbox hasBotFaceCHK "Remove Bottom Face" checked:true pos:[155,70]
	--editPoly properties
	checkbox hasWidthELCHK "Width Edgeloops" checked:true pos:[30,90]
	spinner widthELSPN "Pinch Amount:" range:[0,1000,1.00] type:#float fieldwidth:50 pos:[145,91] enabled:true
	checkbutton widthELranBTN "random" checked:false pos:[56,111] width:45 height:16 enabled:true
	spinner widthELranminSPN "min:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[105,111] enabled:true
	spinner widthELranmaxSPN "max:" range:[0,1000,200.00] type:#float fieldwidth:45 pos:[182,111] enabled:true
	checkbox hasHeightELCHK "Height Edgeloops" checked:true pos:[30,131]
	spinner HeightELSPN "Pinch Amount:" range:[0,1000,1.00] type:#float fieldwidth:50 pos:[145,132] enabled:true
	checkbutton HeightELranBTN "random" checked:false pos:[56,152] width:45 height:16 enabled:true
	spinner HeightELranminSPN "min:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[105,152] enabled:true
	spinner HeightELranmaxSPN "max:" range:[0,1000,200.00] type:#float fieldwidth:45 pos:[182,152] enabled:true
	checkbox hasLengthELCHK "Length Edgeloops" checked:true pos:[30,172]
	spinner LengthELSPN "Pinch Amount:" range:[0,1000,1.00] type:#float fieldwidth:50 pos:[145,173] enabled:true
	checkbutton LengthELranBTN "random" checked:false pos:[56,193] width:45 height:16 enabled:true
	spinner LengthELranminSPN "min:" range:[0,1000,100.00] type:#float fieldwidth:45 pos:[105,193] enabled:true
	spinner LengthELranmaxSPN "max:" range:[0,1000,200.00] type:#float fieldwidth:45 pos:[182,193] enabled:true
	--turbosmooth 1 properties
	spinner tsmoothOneItrsSPN "TurboSmooth #1 Iterations:" range:[0,1000,200.00] type:#float fieldwidth:45 pos:[60,213] enabled:true
	
	
	
	
	
	
	
	
	--
	button buildTxtBTN "Build Objekt" pos:[5,507] width:305 height:40
	on buildTxtBTN pressed do (buildObjekt();try(syncTheRollout())catch(feedbackBox.text="Objekt says: Update UI failed."))
	button launchBTN "Launch GrakScripts" pos:[5,574] width:287 height:20
	on launchBTN pressed do	(try(fileIn "grakscripts.ms")catch(messagebox "Cannot find GrakScripts.ms"))
	button whoIsBTN "?" pos:[295,574] width:15 height:20
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
	--
	fn syncTheRollout = (  --define update UI fn after UI items have been declared
		feedbackBox.text = "Objekt says: " + feedbackUpdate
		--all UI elements are updated with script values
	)
)		
		
		
		
		
	

createDialog OBJKTcontainerRollout 355 700 1315 50 lockWidth:true lockHeight:true style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
AddSubRollout OBJKTcontainerRollout.OBJKT_SUB saveAndLoadRollout rolledUp:true
AddSubRollout OBJKTcontainerRollout.OBJKT_SUB buildObjektRollout rolledUp:false
OBJKTcontainerRollout.OBJKT_SUB.height = 690
OBJKTcontainerRollout.OBJKT_SUB.width = 333
OBJKTcontainerRollout.OBJKT_SUB.pos = [8,1]
) --close script
