--Template
--by garrickcampsey (JAN.2011) - garrick@garrickcampsey.com
( --start script
global TemplateRollout
try destroyDialog TemplateRollout catch()
--
local codeBlockCounter --tracks the fn, if error happens, user can send the code block #
local introFeedbackText = "Template says:\nI am a template." --init feedback text
local feedbackUpdate = undefined --string for feedback/stats update
fn TemplateFn = (
--try (
	codeBlockCounter = 0
	--
	
	
	--build the file
	f=createFile "test2.objekt"
	format "Name:%" "myName\n" to:f
	format "Type:%" "myType\n" to:f
	format "Size:%" "155.548\n" to:f
	format "Created:%" "10.12.23\n" to:f
	close f
	--open the file and parse data
	o=openFile "test2.objekt" mode:"r+"
	skipToString o "Size:"
	myReadData = readLine o
	close o
	
	
	--**1
	codeBlockCounter += 1
	--
	--format string value for feedback
	feedbackUpdate = myReadData
	--feedbackUpdate = "Template says:\nCompleted " + codeBlockCounter as string + " of " + codeBlockCounter as string +" code blocks."
--) catch(feedbackUpdate = "Error in code block: " + codeBlockCounter as string)
)
--UI
rollout TemplateRollout " Template"
(
	--UI
	button buildTxtBTN "Build textfile" pos:[5,20] width:222 height:20

	edittext feedbackBox text:introFeedbackText fieldWidth:236 height:100 pos:[3,72]
	button launchBTN "Launch GrakScripts" pos:[5,176] width:222 height:20
	on launchBTN pressed do	(try(fileIn "grakscripts.ms")catch(messagebox "Cannot find GrakScripts.ms"))
	button whoIsBTN "?" pos:[229,176] width:15 height:20
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
	--Events
	on buildTxtBTN pressed do (TemplateFn();try(feedbackBox.text = feedbackUpdate) catch())
)
createDialog TemplateRollout 250 200 10 100 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script
