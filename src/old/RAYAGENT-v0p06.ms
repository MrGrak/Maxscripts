--RayAgent v0.05
--by Garrick Campsey 2010
--garrick@garrickcampsey.com




--TODO
/*

-- local checkRayhitA = intersectRay $*prey* checkRaypost1 --Is this wildcard possible?


*/







(
--globals
global SBCcontainerRollout
global stretchyBonesCreatorStruct
--destroy any currently open SBCcontainerRollout
try destroyDialog SBCcontainerRollout catch()
--predeclared functions and variables for game
local maxNumAgents = 20
local agentArray = #()
local agentHealthArray = #()
local envArray = #()
local numOfRays = 4
local agilityVar = (random 20 40)
local agentSpeedMultiplier = 2
local predatorSpeedMultiplier = 3
local BringMeBackNumODDS = 500
--
fn initFunction = ()
fn SIMgame = ()







--functions definitions
fn initGame =
	(
		disableSceneRedraw()
		--housekeeping
		--resetMaxFile #noPrompt
		delete $*predator*
		delete $*prey*
		delete $*Agent*
		delete $*Shape*
		delete $*boundary*
		delete $*Circle*
		agentArray = #()
		agentHealthArray = #()
		envArray = #()
		
		--build the prey
		Sphere radius:25 smooth:on segs:10 chop:0 slice:off \
		sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
		pos:[500,500,0] isSelected:on
		$.name = "prey"
		$.wirecolor = [0,255,0]
		--$.boxMode = true
		clearSelection()
		--build a predator
		Sphere radius:25 smooth:on segs:10 chop:0 slice:off \
		sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
		pos:[-1000,-1000,0] isSelected:on
		$.name = "predator"
		$.wirecolor = [255,0,0]
		--$.boxMode = true
		clearSelection()

		--build the boundaries using planes
		Plane length:5 width:1600 pos:[0,-800,0] isSelected:on lengthsegs:1 widthsegs:8 wirecolor:[150,150,150]
		modPanel.addModToSelection (Shell ()) ui:on
		$.modifiers[#Shell].outerAmount = 50
		convertToMesh $
		rotate $ 90 z_axis
		$.pos = [-800,0,0]
		join envArray $
		copy envArray[1] isSelected:on --copy
		$.pos = [800,0,0]
		attach envArray[1] $
		CenterPivot envArray[1]
		copy envArray[1] isSelected:on --copy
		$.pos = [0,0,25]
		rotate $ 90 z_axis
		attach envArray[1] $
		envArray[1].name = "boundary"
		clearSelection()
		/* --code to build ground
		Plane length:1600 width:1600 pos:[0,0,0] isSelected:on lengthsegs:1 widthsegs:8 wirecolor:[150,150,150]
		$.name = "boundary"
		*/

	
		
		
		--build the agents
		for i = 1 to maxNumAgents do
		(
			--build agent, put into array
			Box lengthsegs:1 widthsegs:1 heightsegs:1 length:10 width:20 height:30 \
				mapcoords:on pos:[0,0,0] isSelected:on wirecolor:[0,0,0]
				$.name = uniqueName "Agent"
				$.wirecolor = [0,0,255]
				convertToMesh $
				append agentArray $
			Box lengthsegs:1 widthsegs:1 heightsegs:1 length:10 width:10 height:10 \
				mapcoords:on pos:[0,0,32] isSelected:on
				attach agentArray[i] $
				-- make healthBar
			Box lengthsegs:1 widthsegs:1 heightsegs:1 length:3 width:20 height:3 \
				mapcoords:on pos:[0,0,55] isSelected:on wirecolor:[0,255,0]
				append agentHealthArray $
			$.parent = agentArray[i]
			$.name = uniqueName "AgentHealth"
			clearSelection()
			-- randomize agents
			SIMgame()
		) --end for loop
		enableSceneRedraw()


	)
	
	
	
	
fn SIMgame =
	(
	disableSceneRedraw()
		--SIM GAME
		--clean up previous SIMs rays
		delete $*Shape*
		--SHOOT RAYS for each agent
		for j = 1 to maxNumAgents do
		(
			local isAgentDead = false
			if agentArray[j] != undefined do --and if the agent can be selected...
			(
				-- check to see if agent is dead
				if agentHealthArray[j].scale.x < 0.2 then
				(
					agentArray[j].wirecolor = [200,200,200]
					isAgentDead = true
					try if intersects agentArray[j] $prey then --check to see if the agent intersects the prey
					(
						agentHealthArray[j].scale = [1,1,1]
						isAgentDead = false
						agentArray[j].wirecolor = [0,0,255]
					) catch()
					
					--randomly bring them back to life
					local randomBringMeBackNum = (random 1 BringMeBackNumODDS)
					if randomBringMeBackNum == 1 then
					(
						scale agentHealthArray[j] [10,10,10]
						isAgentDead = false
						agentArray[j].wirecolor = [0,0,255]
						-- move .pos
						try $agentArray[j].pos += [(random -100 100),(random -100 100),0] catch() --zombie spawn
					)
				)
				-- end check to see if agent is dead
				if isAgentDead == false then --if the agent isn't dead...
				(
						--***************************
						--scope of each agent's 'turn'
						local checkRayhitPrey = undefined 
						local checkRayhitPredator = undefined
												
						
						-- check to see if the predator is intersecting the agent
						try if intersects agentArray[j] $predator then
						(
							-- the predator attacks
							-- scale health bar down by percentage
							-- agentHealthArray[j].scale -= 1
							agentHealthArray[j].scale += [-0.1,-0.1,-0.1]
						) catch()


































--************************************************************************************************RAY ENGINE******************************************
						local checkRayhitPrey
						local checkRayhitPredator
						--ray casting algorithm
						try for i = 1 to numOfRays do 
						(
							--randomize negative and positive on the ray direction
							local randomNum = (random 1 4)
							local rayXcontroller1 = (random 0.0 1.0) --0.478232 ex.
							local rayYcontroller1 = 1 - rayXcontroller1 --get whats left of 1, assign
							local checkRaypost1 = undefined
							--
								case of --algorithm that randomizes ray views in all directions
								(
									(randomNum == 1): checkRaypost1 = ray agentArray[j].pos [rayXcontroller1,rayYcontroller1,0]
									(randomNum == 2): checkRaypost1 = ray agentArray[j].pos [-rayXcontroller1,rayYcontroller1,0]
									(randomNum == 3): checkRaypost1 = ray agentArray[j].pos [rayXcontroller1,-rayYcontroller1,0]
									(randomNum == 4): checkRaypost1 = ray agentArray[j].pos [-rayXcontroller1,-rayYcontroller1,0]
								)
								
							--checking for intersections for following objects:
							try checkRayhitPrey = intersectRay $prey checkRaypost1 catch()--ObjToFind **************************************************
							try checkRayhitPredator = intersectRay $predator checkRaypost1 catch()--ObjToFind ******************************************
							-- local checkRayhitA = intersectRay $*prey* checkRaypost1 --Is this wildcard possible?
							-- local checkRayhitA = intersectRay $*predator* checkRaypost1 --Is this wildcard possible?

						) catch() --end for
--************************************************************************************************START BRAINS******************************************
						--HIT TESTS
						if checkRayhitPredator != undefined then --if a ray hit the predator, then document ray and runaway
						(
							--build a spline showing where agent saw predator
							local theSplineShape = SplineShape pos:agentArray[j].pos
							--
							if checkRayhitPredator.pos != undefined then 
							(
								addNewSpline theSplineShape
								addKnot theSplineShape 1 #corner #line agentArray[j].pos
								addKnot theSplineShape 1 #corner #line checkRayhitPredator.pos
								--set properties of spline just built
								theSplineShape.render_displayRenderMesh = true
								theSplineShape.render_viewport_rectangular = false
								theSplineShape.render_thickness = 0.4
								theSplineShape.render_sides = 4
								theSplineShape.wirecolor = [255,0,0]
								--MUST CALL UPDATESHAPE to prevent max from crashing
								updateShape theSplineShape
								--
								--if the new agent position is not outside the game boundaries, move the agent away from the predator
								local theXposOfAgent = copy agentArray[j].pos.x
								local theYposOfAgent = copy agentArray[j].pos.y
								--algorithm to move the agents away from the predator			
								slopeOfY = (checkRayhitPredator.pos.y - theYposOfAgent)/agilityVar --this moves the object divided by the agility variable
								slopeOfX = (checkRayhitPredator.pos.x - theXposOfAgent)/agilityVar --this moves the object divided by the agility variable
								--
								local newAgentPosX = (theXposOfAgent += -(slopeOfX * agentSpeedMultiplier))
								local newAgentPosY = (theYposOfAgent += -(slopeOfY * agentSpeedMultiplier))
								--rotate the agent
								agentArray[j].rotation.z_rotation += (random -10 10) --random z axis orientation
								--
								agentArray[j].pos.x += -(slopeOfX * agentSpeedMultiplier)
								agentArray[j].pos.y += -(slopeOfY * agentSpeedMultiplier)
							)
							--
							--
						) else if checkRayhitPrey != undefined then ( -- of a ray hit the prey...
							--build a spline showing where agent saw prey
							local theSplineShape = SplineShape pos:agentArray[j].pos
							--
							addNewSpline theSplineShape
							addKnot theSplineShape 1 #corner #line agentArray[j].pos
							addKnot theSplineShape 1 #corner #line checkRayhitPrey.pos
							--set properties of spline just built
							theSplineShape.render_displayRenderMesh = true
							theSplineShape.render_viewport_rectangular = false
							theSplineShape.render_thickness = 0.4
							theSplineShape.render_sides = 4
							theSplineShape.wirecolor = [0,255,0]
							--MUST CALL UPDATESHAPE to prevent max from crashing
							updateShape theSplineShape
							--
							--algorithm to move the agents to the prey			
							slopeOfY = (checkRayhitPrey.pos.y - agentArray[j].pos.y)/agilityVar --this moves the object divided by the agility variable
							slopeOfX = (checkRayhitPrey.pos.x - agentArray[j].pos.x)/agilityVar --this moves the object divided by the agility variable
							--rotate the agent
							agentArray[j].rotation.z_rotation += (random -10 10) --random z axis orientation
							--move the agent to the target
							agentArray[j].pos.x += slopeOfX * agentSpeedMultiplier
							agentArray[j].pos.y += slopeOfY * agentSpeedMultiplier
							--
							--
						) else (  --the agent did not see the prey, or the predator, (the agent could evaluate an environment here) but the agent 'wanders'...
							try for i = 1 to maxNumAgents do
							(
								agentArray[j].pos += [(random -1 1),(random -1 1),0] * agentSpeedMultiplier/4 --random pos, low movement
								agentArray[j].rotation.z_rotation += (random -10 10) --random z axis orientation
							) catch() --end for
--************************************************************************************************END BRAINS******************************************
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
							
						-- check to see if agent position exceeds game bounds
						try if agentArray[j].pos.x > 800 then
						(
							agentArray[j].pos.x = 800
						) catch()
						try if agentArray[j].pos.x < -800 then
						(
							agentArray[j].pos.x = -800
						) catch()
						try if agentArray[j].pos.y > 800 then
						(
							agentArray[j].pos.y = 800
						) catch()
						try if agentArray[j].pos.y < -800 then
						(
							agentArray[j].pos.y = -800
						) catch()
						)--ends HIT TESTS
				) --ends isAgentDead?
			)--ends can be selected?
		) --end for
	enableSceneRedraw()
	) --end fn simgame








/*CODE GRAVEYARD-----------------
if newAgentPosX < 800 then
(
	if newAgentPosX > -800 then
	(
		agentArray[j].pos.x += -(slopeOfX * agentSpeedMultiplier)
	)
)

if newAgentPosY < 800 then
(
	if newAgentPosY > -800 then
	(
		agentArray[j].pos.y += -(slopeOfY * agentSpeedMultiplier)
	)
)
--combine into and statement
*/ -------------------------------















--rollouts for UI
rollout SBCcontainerRollout " RayAgent v0.05"
(
	subrollout SBC_SUB
)
rollout ctrlOptions "Play, Pause, Restart, and Interval Time                      "
(
	--UI
	spinner intervalSpinner "Update screen every (ms):  " pos:[140,10] width:90 height:18 range:[10,5000,80] type:#integer
	button startSIMBTN "Play SIM" pos:[170,50] width:100 height:18
	button pauseSIMBTN "Pause SIM" pos:[170,70] width:100 height:18
	button restartSIMBTN "Restart SIM" pos:[50,70] width:100 height:18
	spinner numberOfAgentsSpinner "# of Players:  " pos:[70,40] width:90 height:18 range:[1,500,20] type:#integer
	timer gameClockTIMER "testClock" interval:80 active:false
	--events
	
	on restartSIMBTN pressed do
		(
			gameClockTIMER.active = false
			maxNumAgents = numberOfAgentsSpinner.value
			initGame()
			gameClockTIMER.active = true
		)
	on intervalSpinner entered do
		(
			gameClockTIMER.interval = intervalSpinner.value
		)
	on gameClockTIMER tick do
		(
			SIMgame()
		)
	on startSIMBTN pressed do
		(
			gameClockTIMER.active = true
		)
	on pauseSIMBTN pressed do
		(
			gameClockTIMER.active = false
		)
	on ctrlOptions close do 
		(
			gameClockTIMER.active = false
			--otherwise the user has to reset max to stop the game
		)
)
rollout boneOptions "Game Options                                                             "
(
	button makeApredatorBTN "Make a Predator" pos:[10,10] width:100 height:18
	button makeApreyBTN "Make a Healer" pos:[10,30] width:100 height:18
	--
	spinner respawnTimeSPN "Respawn Time:  " pos:[180,10] width:90 height:18 range:[10,10000,500] type:#integer --***********************************************************
	spinner predatorSpeedSPN "Predator Speed:  " pos:[180,30] width:90 height:18 range:[1,30,2] type:#integer
	spinner agentSpeedSPN "Agent Speed:  " pos:[180,50] width:90 height:18 range:[1,30,2] type:#integer
	spinner maxRaysSPN "Max Rays per interval:  " pos:[180,70] width:90 height:18 range:[1,10,4] type:#integer
	--
	button deletepredatorBTN "Delete Predator" pos:[10,100] width:100 height:18
	button deletepreyBTN "Delete Healer" pos:[10,120] width:100 height:18
	--
	button defaultGameBTN "Play Default Game" pos:[120,100] width:150 height:18
	button predatorGameBTN "Play Predator Wins Game" pos:[120,120] width:150 height:18
	button preyGameBTN "Play Prey Wins Game" pos:[120,140] width:150 height:18
	
	--button updateSIMBTN "UPDATE SIM" pos:[10,120] width:262 height:24
	--
	
	--SET DEFAULT GAME TYPES
	on defaultGameBTN pressed do
		(
			agentSpeedSPN.value = 2
			agentSpeedMultiplier = 2
			predatorSpeedSPN.value = 2
			predatorSpeedMultiplier = 2
			respawnTimeSPN.value = 500 --chances in 1/500
			BringMeBackNumODDS = respawnTimeSPN.value
		)
	on predatorGameBTN pressed do
		(
			agentSpeedSPN.value = 1
			agentSpeedMultiplier = 1
			predatorSpeedSPN.value = 10
			predatorSpeedMultiplier = 10
			respawnTimeSPN.value = 1000 --chances of 1/1000
			BringMeBackNumODDS = respawnTimeSPN.value
		)
	on preyGameBTN pressed do
		(
			agentSpeedSPN.value = 10
			agentSpeedMultiplier = 10
			predatorSpeedSPN.value = 1
			predatorSpeedMultiplier = 1
			respawnTimeSPN.value = 80 --chance of 1/80
			BringMeBackNumODDS = respawnTimeSPN.value
		)
	--EVENTS
	on deletepredatorBTN pressed do
		(
			delete $*predator*
		)
	on deletepreyBTN pressed do
		(
			delete $*prey*
		)
	--
	on respawnTimeSPN entered do
		(
			BringMeBackNumODDS = respawnTimeSPN.value
		)
	on predatorSpeedSPN entered do
		(
			predatorSpeedMultiplier = predatorSpeedSPN.value
		)
	on agentSpeedSPN entered do
		(
			agentSpeedMultiplier = agentSpeedSPN.value
		)
	on maxRaysSPN entered do
		(
			numOfRays = maxRaysSPN.value
		)
	on makeApreyBTN pressed do
		(
			--build the prey
			Sphere radius:25 smooth:on segs:10 chop:0 slice:off \
			sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
			pos:[500,500,0] isSelected:on
			$.name = "prey"
			$.wirecolor = [0,255,0]
			$.xray = false
			clearSelection()
		)
	on makeApredatorBTN pressed do
		(
			--build a predator
			local randomPosNum = [(random -1000 1000),(random -1000 1000),0]
			Sphere radius:25 smooth:on segs:10 chop:0 slice:off \
			sliceFrom:0 sliceTo:0 mapcoords:on recenter:off \
			pos:[500,500,0] isSelected:on
			$.name = "predator"
			$.wirecolor = [255,0,0]
			clearSelection()
		)		
)


--create dialog and add subrollouts + their properties
createDialog SBCcontainerRollout 320 330 100 100 style:#(#style_toolwindow, #style_sysmenu)
--add subrollouts to main rollout
AddSubRollout SBCcontainerRollout.SBC_SUB ctrlOptions rolledUp:false
AddSubRollout SBCcontainerRollout.SBC_SUB boneOptions rolledUp:false

--rolled up property?
--styles for sub rollouts
SBCcontainerRollout.SBC_SUB.height = 320
SBCcontainerRollout.SBC_SUB.width = 300
SBCcontainerRollout.SBC_SUB.pos = [10,1]
--init
initGame()


)