-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
-- *  FRACTURE VORONOI (for 3ds max and higher)            *
-- *                                                       *
-- *  Based one a previous script (VoronoiCells) this one  *
-- *  divides any mesh in a certain amount of parts.       *
-- *  As with the previous one, go easy on the numbers if  *
-- *  don't want it to run forever.                        *
-- *                                                       *
-- *  Feel free to share and modify at will...             *
-- *                                                       *
-- *  GARP - 2008                                          *
-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

(	-- start script

global rltFractureVoronoi
try destroyDialog rltFractureVoronoi catch()

rollout rltFractureVoronoi "F.R.A.C.T.U.R.E" width:120 height:207
(
	groupBox boxSetUp "" pos:[5,0] width:110 height:82
	fn geometryFilter obj = superClassOf obj == GeometryClass
	pickButton btnMesh "Pick Mesh" pos:[10,11] width:100 height:25 filter:geometryFilter tooltip:"mesh to fracture"
	spinner spnNbPts "Nb Parts: " pos:[10,41] width:100 height:16 range:[2,1000,10] type:#integer enabled:false
	spinner spnNbIter "Iterations:     " pos:[29,61] width:81 height:16 range:[1,10,1] type:#integer enabled:false

	groupBox boxChunks "" pos:[5,80] width:110 height:75
	button btnCreate "Break in 10" pos:[10,91] width:100 height:25 tooltip:"start creating blocks" enabled:false
	radiobuttons rdoColor "" pos:[12,119] width:72 height:32 labels:#("Multi Color","Uniform") default:1 columns:1
	colorPicker cpParts "" pos:[70,136] fieldWidth:20 height:12 color:[128,96,64]

	groupBox boxProgress "" pos:[5,153] width:110 height:49
	progressBar pbProgress "" pos:[10,165] width:100 height:15 value:0 color:[0,96,0]
	label lblProStatus "" pos:[10,183] width:100 height:17

	local theMesh			-- holds the original object

	on btnMesh picked obj do
	(
		btnMesh.caption = obj.name
		theMesh = obj
		spnNbPts.enabled = true
		spnNbIter.enabled = true
		btnCreate.enabled = true
		cpParts.color = obj.wireColor

	)	-- end on btnMesh picked theMesh

	on btnCreate pressed do
	(
		local arrTemp = #()
		local arrFinal = #()
		local nbParts = spnNbPts.value
		local rotPlane = plane isHidden:true

		start = timeStamp()

		theMesh.isHidden = true
		theMesh.isSelected = false

		append arrFinal (copy theMesh)
		collapseStack arrFinal[1]

		for iter = 1 to spnNbIter.value do
		(
			counter = 0
			arrTemp = arrFinal
			arrFinal = #()
			for obj in arrTemp do obj.isHidden = true

			for obj in arrTemp do
			(
				nbPartsys = pcloud emitter:obj formation:3 quantityMethod:1 total_number:nbParts \
								 viewPercent:100 seed:(random 0 1000) isHidden:true
				arrCoords = #()
				for i = 1 to nbParts do arrCoords[i] = (particlePos nbPartsys i)
				delete nbPartsys

				for i = 1 to nbParts do
				(
					thePart = editable_mesh pos:arrCoords[i]
					thePart.wireColor = case rdoColor.state of
										(
											1: random black white
											2: cpParts.color
										)	-- end case rdoColor.state
					attach thePart (copy obj isHidden:true)

					for j = 1 to nbParts where j != i do
					(
						theVec = arrCoords[j] - arrCoords[i]
						rotPlane.dir = theVec
						mSlice = sliceModifier slice_type:2
						addModifier thePart mSlice
						mSlice.slice_plane.rotation = rotPlane.rotation
						mSlice.slice_plane.pos = theVec / 2
						addModifier thePart (cap_holes())
						collapseStack thePart

					)	-- end for j = 1 to nbParts

					append arrFinal thePart
					thePart.isHidden = false
					redrawViews()
					end = timeStamp()
					counter += 1
					total = nbParts ^ iter
					prog = 100 * counter / total
					pbProgress.value = prog
					pbProgress.color = [200 - prog * 2,prog * 2,0]
					lblProStatus.caption = (counter as string + " parts in " + \
						(formattedPrint ((end - start) / 1000.0) format:".1f") + "s")

				)	-- end for i = 1 to nbParts

				delete obj

			)	-- end for obj in arrTemp

		)	-- end for iter = 1 to spnNbIter.value

		for obj in arrFinal do obj.name = (uniqueName (theMesh.name + "_Part_"))
		delete rotPlane
		btnMesh.caption = "Pick Mesh"
		spnNbPts.enabled = false
		spnNbIter.enabled = false
		btnCreate.enabled = false

	)	-- end on btnCreate pressed

	on spnNbPts changed val do
	(
		btnCreate.caption = "Break in " + ((val ^ spnNbIter.value) as string)
	)

	on spnNbIter changed val do
	(
		btnCreate.caption = "Break in " + ((spnNbPts.value ^ val) as string)
	)

)	-- end rollout rltFractureVor

createDialog rltFractureVoronoi 120 207 100	200

)	-- end script