--Template
--fixes scaling and preps meshes for rigging and skinning, based in part on garps voroni fracture script 1.1
--by garrickcampsey (JAN.2011) - garrick@garrickcampsey.com
( --start script
global TemplateRollout
try destroyDialog TemplateRollout catch()
--
local codeBlockCounter --tracks the fn, if error happens, user can send the code block #
local introFeedbackText = "Template says:\nI am a template." --init feedback text
local feedbackUpdate = undefined --string for feedback/stats update
fn TemplateFn = (
try (
	codeBlockCounter = 0
	--
	--**1
	codeBlockCounter += 1
	--
	--format string value for feedback
	feedbackUpdate = "Template says:\nCompleted " + codeBlockCounter as string + " of " + codeBlockCounter as string +" code blocks."
) catch(feedbackUpdate = "Error in code block: " + codeBlockCounter as string)
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
	--on runCCBTN pressed do (Projektor();try(feedbackBox.text = feedbackUpdate) catch())
)
createDialog TemplateRollout 250 200 10 100 lockWidth:true lockHeight:false style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script
