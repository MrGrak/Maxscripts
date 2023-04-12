--set pivot points
--animate parts to a loop
startTime = timeStamp()
agentArray = #()
agentHealthArray = #()
envArray = #()
maxNumAgents = 10
max select all
if $ != undefined do (delete $)
for i = 1 to maxNumAgents do
(
	--build agent, put into array
	Box lengthsegs:1 widthsegs:1 heightsegs:1 length:10 width:20 height:30 \
		mapcoords:on pos:[0,0,0] isSelected:on wirecolor:[0,0,0]
		$.name = uniqueName "Agent"
		randomNumber2 = random 1 2
		if randomNumber2 == 1 then ( $.wirecolor = [0,0,255])
		if randomNumber2 == 2 then ( $.wirecolor = [255,0,0])
		convertToMesh $
		append agentArray $
	Box lengthsegs:1 widthsegs:1 heightsegs:1 length:10 width:10 height:10 \
		mapcoords:on pos:[0,0,32] isSelected:on
		attach agentArray[i] $
	Box lengthsegs:1 widthsegs:1 heightsegs:1 length:3 width:20 height:3 \
		mapcoords:on pos:[0,0,55] isSelected:on wirecolor:[0,255,0]
		append agentHealthArray $
	$.parent = agentArray[i]
	$.name = uniqueName "AgentHealth"
	clearSelection()
	agentArray[i].pos = [(random -170 170),(random -170 170),0] --random pos
	agentArray[i].rotation.z_rotation = (random -200 200) --random z axis orientation
)
--build the goal using planes
Plane length:5 width:420 pos:[0,-20,0] isSelected:on lengthsegs:1 widthsegs:8 wirecolor:[150,150,150]
modPanel.addModToSelection (Shell ()) ui:on
$.modifiers[#Shell].outerAmount = 50
convertToMesh $
rotate $ 90 z_axis
$.pos = [-200,0,0]
join envArray $
copy envArray[1] isSelected:on --copy
$.pos = [200,0,0]
attach envArray[1] $
CenterPivot envArray[1]
copy envArray[1] isSelected:on --copy
$.pos = [0,0,25]
rotate $ 90 z_axis
attach envArray[1] $
--end
endTime = timeStamp()
format "Simulation took % seconds\n" ((endTime - startTime) / 1000.0)
--the arrays
agentArray[5].scale = [1,1,1]
agentHealthArray[5].scale = [.1,1,1]

