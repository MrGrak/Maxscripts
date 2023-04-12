--	Viewport Maxscript Editor Version 1, by garrick@garrickcampsey.com 
--	last updated 02.22.2011

global viewportMaxscriptEditor
try destroyDialog viewportMaxscriptEditor catch()
rollout viewportMaxscriptEditor " Viewport Maxscript Editor v1.0"
(
	--INDEX
	local mySavePath --this value stores the folder path, example .../scripts/
	local VMEFileName --this value stores the file name, based on the "save script" text entered by the user
	local theUIelementsArray = #("Rollout", "Slider", "Spinner", "Button",\
	"Check Button", "Pick Button", "Check Box", "Colorpicker", "Dropdown list", "Edit Text", "Group Box",\
	"Hyperlink", "Label", "Progressbar", "Radio Buttons", "Timer")
	local buildColor = (color 0 255 255)
	--
	--UI	
	label lab0 "_________________________________" pos:[10,45]
	label lab1 "_________________________________" pos:[10,117]
	label lab2 "_________________________________" pos:[10,226]
	dropdownlist createDD "Create:" items:theUIelementsArray pos:[10,10] width:200 height:20
	label lab3 "Save script :" pos:[10,85]
	edittext saveObjektNameET text:"myVME" fieldWidth:157 height:18 pos:[6,101]
	button folderVMEFileBTN "Folder" pos:[170,100] width:40 height:20
	--
	button compileScriptsButton ">>    Gather and Write script    <<" width:200 height:30 pos:[10,170]
	label progLabel "Gathering..." pos:[10,203]
	progressBar pbProgress1 pos:[10,220] width:60 height:10 value:0 color:[0,96,0]
	label progLabel2 "Writing Script..." pos:[80,203]
	progressBar pbProgress2 pos:[80,220] width:130 height:10 value:0 color:[0,96,0]
	--
	button launchBTN "Launch Indexr" pos:[10,245] width:100 height:20
	on launchBTN pressed do	(try(fileIn "indexr.ms")catch(messagebox "Cannot find indexr.ms"))
	button whoIsBTN "?" pos:[113,245] width:15 height:20
	on whoIsBTN pressed do (messagebox "Send errors to: Garrick@GarrickCampsey.com")
	--
	--THIS CODE HANDLES UPDATES TO THE OFFSET CA VALUES
	fn updateOffsets = 
	(
		--try to get the offset from the parent.
		--if no parent is available, the object isn't linked to the rollout
		local myParent = $.parent
		local myOffsetX = ((abs(floor(myParent.children[1].pos.x-$.pos.x)))-($.width/2)) as string
		local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-$.pos.z)))-($.length/2)) as string
		$.objectData.xoffset = myOffsetX
		$.objectData.yoffset = myOffsetZ
		$.objectData.paramsRollout.xoffsetlabel.text = myOffsetX
		$.objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
	)
	label myVMELabel "VME" pos:[180,250]
	--THIS TIMER ATTEMPTS TO ACCESS THE SELECTED OBJECT'S VME ID
		--on a timer, try writing the selected object's VME ID to it's offset, if it doesn't exist - it's not a VME UI element
		--if it does exist, then the IDs are effectively updated as the object is selected.  it doesn't even need to move.  can also work on arrays, just pad a 0 value at the beginning
	timer gameClockTIMER "testClock" interval:500 active:true
	on viewportMaxscriptEditor close do (gameClockTIMER.active = false) --stop the timer on close
	on gameClockTIMER tick do
	(
		try(myVMELabel.text =  ($.objectData.VMEID as string))catch(myVMELabel.text = " ")
		try(if $.objectData.VMEID  != undefined then (updateOffsets()))catch()
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--call this fn like: buildUIelement "BTN" 30 100 buildColor
	fn buildUIelement buiVMEID buiLength buiWidth buiWireColor =
	(
		--accepts parameters of: VMEid, length, width, wirecolor
			--VME ID determines what is built, most custom code is contained within those sections
		--build rectangle with length and width and wirecolor
		local myUIelement = Rectangle length:buiLength width:buiWidth cornerRadius:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
		setTransformLockFlags myUIelement #{3,4,5,6,7,8,9} --lock it to 2d front view
		--
		--based on buiVMEID, build title text, customAttributes, and other misc objects
		--ROLL
		if buiVMEID == "ROLL" then 
			(
				--build UI rollout title
				local myText = text size:12 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
				myText.text = "Rollout" ;myText.name = "RolloutText" ;myText.parent = myUIelement
				setTransformLockFlags myText #all; myText.pos = [-(myUIelement.width/2)+16,0,(myUIelement.length/2)+3]
				--build the 0,0 reference object
					--CREATE AN OBJECT THAT SERVES AS 0,0 FOR THE ROLLOUT
					--build the elements offset CAs based on this objects position.
				myZeroRef = Circle radius:1 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [-(myUIelement.width/2),0,(myUIelement.length/2)]) isSelected:off wirecolor:buiWireColor
				myZeroRef.parent = myUIelement; setTransformLockFlags myZeroRef #all; myZeroRef.name = "ZeroZero"
					
				--collapse text into 0,0 object
				convertToSplineShape myText
				updateShape myText
				convertToSplineShape myZeroRef
				updateShape myZeroRef
				addAndWeld myZeroRef myText 0.0 --attach
				updateShape myZeroRef 
					
				--define and add CAs
				customAttributes = attributes objectData
				(
					parameters main rollout:paramsRollout
					(
						myrolloutWidth type:#integer ui:myrolloutWidth default:300
						myrolloutLength type:#integer ui:myrolloutLength default:300
						myrolloutName type:#string ui:myrolloutET default:"myRollout"
						VMEID type:#string ui:VMEIDlabel default:"ROLL"
					)
					rollout paramsRollout "VM Editor IDs"
					(
						label VMEIDlabel "ROLL" type:#string align:#center
						editText myrolloutET "Name:" text:"myRollout" type:#string align:#center
						spinner myrolloutWidth "Width:" range:[0,1000,300] type:#integer align:#center
						spinner myrolloutLength "Length:" range:[0,1000,300] type:#integer align:#center
						--
						fn updateChildren = 
						(
							$.width = myrolloutWidth.value 
							$.length = myrolloutLength.value
							$.children[1].pos = [(-($.width/2))+$.pos.x,0,(($.length/2))+$.pos.z]
						)
						on myrolloutWidth changed theState do (try(updateChildren())catch())
						on myrolloutLength changed theState do (try(updateChildren())catch())
					)
				)
				custAttributes.add myUIelement customAttributes
				select myUIelement
			)
		--
			
			
			
		--BTN
		if buiVMEID == "BTN" then 
		(
			--build UI button title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Button" ;myText.name = "ButtonText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"BTN"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "BTN" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		--
		
		
		--SLDR
		if buiVMEID == "SLDR" then 
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Slider" ;myText.name = "SliderText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"SLDR"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "SLDR" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--SPNR
		if buiVMEID == "SPNR" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Spinner" ;myText.name = "SpinnerText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"SPNR"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "SPNR" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--CHKBTN
		if buiVMEID == "CHKBTN" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "CheckButton" ;myText.name = "CheckButtonText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"CHKBTN"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "CHKBTN" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		

		
		--PCKBTN
		if buiVMEID == "PCKBTN" then 
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "PickButton" ;myText.name = "PickButtonText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"PCKBTN"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "PCKBTN" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		
		
		--CHKBOX
		if buiVMEID == "CHKBOX" then 
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Checkbox" ;myText.name = "CheckBoxText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"CHKBOX"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "CHKBOX" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		
		--CLRPIKR
		if buiVMEID == "CLRPIKR" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Colorpicker" ;myText.name = "ColorpickerText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"CLRPIKR"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "CLRPIKR" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--DDL
		if buiVMEID == "DDL" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "DropdownList" ;myText.name = "DropdownListText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"DDL"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "DDL" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--EDTXT
		if buiVMEID == "EDTXT" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "EditText" ;myText.name = "EditText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"EDTXT"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "EDTXT" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--GRPBOX
		if buiVMEID == "GRPBOX" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "GroupBox" ;myText.name = "GroupBoxText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"GRPBOX"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "GRPBOX" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--LINK
		if buiVMEID == "LINK" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Hyperlink" ;myText.name = "HyperlinkText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"LINK"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "LINK" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--LBL
		if buiVMEID == "LBL" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Label" ;myText.name = "LabelText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"LBL"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "LBL" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--PROG
		if buiVMEID == "PROG" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "ProgressBar" ;myText.name = "ProgressBarText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"PROG"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "PROG" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--RDOBTN
		if buiVMEID == "RDOBTN" then 
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "RadioButton" ;myText.name = "RadioButtonText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"RDOBTN"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "RDOBTN" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
		--TMR
		if buiVMEID == "TMR" then
		(
			--build UI slider title
			local myText = text size:10 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:off wirecolor:buiWireColor
			myText.text = "Timer" ;myText.name = "TimerText" ;myText.parent = myUIelement
			setTransformLockFlags myText #all; 
			--center pivot on my text
			myText.pivot = myText.center
			myText.pos = myUIelement.pos
			--define and add CAs
			customAttributes = attributes objectData
			(
				parameters main rollout:paramsRollout
				(
					VMEID type:#string ui:VMEIDlabel default:"TMR"
					xoffset type:#string ui:xoffsetlabel default:"unlinked"
					yoffset type:#string ui:yoffsetlabel default:"unlinked"
				)
				rollout paramsRollout "VM Editor IDs"
				(
					label VMEIDlabel "TMR" type:#string align:#center
					label xoffsetlabel "unlinked" type:#string align:#center
					label yoffsetlabel "unlinked" type:#string align:#center
				)
			)
			custAttributes.add myUIelement customAttributes
			select myUIelement
		)
		
		
		
	) --end fn buildUIelement



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--EVENTS
	on createDD selected i do 
	(
		case of
		(
			--*********************************************MODIFY THE BUILD PARAMETERS TO BETTER REFLECT THE UI ELEMENTS SIZE
			(createDD.items[i] == "Rollout"): buildUIelement "ROLL" 300 300 buildColor --ROLL
			(createDD.items[i] == "Slider"): buildUIelement "SLDR" 45 200 buildColor --SLDR
			(createDD.items[i] == "Spinner"): buildUIelement "SPNR" 16 80 buildColor --SPNR
			(createDD.items[i] == "Button"): buildUIelement "BTN" 30 100 buildColor --BTN
			(createDD.items[i] == "Check Button"): buildUIelement "CHKBTN" 30 100 buildColor --CHKBTN
			(createDD.items[i] == "Pick Button"): buildUIelement "PCKBTN" 30 100 buildColor  --PCKBTN
			(createDD.items[i] == "Check Box"): buildUIelement "CHKBOX" 13 70 buildColor  --CHKBOX
			(createDD.items[i] == "Colorpicker"): buildUIelement "CLRPIKR" 30 100 buildColor  --CLRPIKR
			(createDD.items[i] == "Dropdown list"): buildUIelement "DDL" 18 100 buildColor  --DDL
			(createDD.items[i] == "Edit Text"): buildUIelement "EDTXT" 30 100 buildColor  --EDTXT
			(createDD.items[i] == "Group Box"): buildUIelement "GRPBOX" 30 100 buildColor  --GRPBOX
			(createDD.items[i] == "Hyperlink"): buildUIelement "LINK" 10 100 buildColor  --LINK
			(createDD.items[i] == "Label"): buildUIelement "LBL" 10 100 buildColor  --LBL
			(createDD.items[i] == "Progressbar"): buildUIelement "PROG" 10 100 buildColor  --PROG
			(createDD.items[i] == "Radio Buttons"): buildUIelement "RDOBTN" 35 100 buildColor  --RDOBTN
			(createDD.items[i] == "Timer"): buildUIelement "TMR" 20 40 buildColor  --TMR
			default: print "exception occured in case statement..."
		)
	)
	--
	on folderVMEFileBTN pressed do 
	(
		local folderPre = getSavePath caption:"Set folder" initialDir:(GetDir #scripts)
		if folderPre != undefined then (mySavePath = folderPre + "\\")
	)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--
	on compileScriptsButton pressed do 
	(
		--gather all objects in scene into array
		select $*
		local VMEinScene
		try (VMEinScene = $ as array)catch()
		clearSelection()
		--create the arrays containing the rollouts, and other UI elements
		myRolloutsArray = #()
		mySlidersArray = #()
		mySpinnersArray = #()
		myButtonsArray = #()
		myCheckButtonsArray = #()
		myPickButtonsArray = #()
		myCheckBoxesArray = #()
		myColorpickersArray = #()
		myDropDownlistsArray = #()
		myEditTextsArray = #()
		myGroupBoxesArray = #()
		myHyperlinksArray = #()
		myLabelsArray = #()
		myProgressBarsArray = #()
		myRadioButtonsArray = #()
		myTimersArray = #()
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		--SORT ELEMENTS INTO ARRAYS
		if VMEinScene != undefined then (
			for i = 1 to VMEinScene.count do
			(
				--find the rollout IDs, put into rolloutsArray, etc...
				try(if (VMEinScene[i].objectData.VMEID as string) == "ROLL" then (append myRolloutsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "BTN" then (append myButtonsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "SLDR" then (append mySlidersArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "SPNR" then (append mySpinnersArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "CHKBTN" then (append myCheckButtonsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "PCKBTN" then (append myPickButtonsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "CHKBOX" then (append myCheckBoxesArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "CLRPIKR" then (append myColorpickersArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "DDL" then (append myDropDownlistsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "EDTXT" then (append myEditTextsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "GRPBOX" then (append myGroupBoxesArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "LINK" then (append myHyperlinksArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "LBL" then (append myLabelsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "PROG" then (append myProgressBarsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "RDOBTN" then (append myRadioButtonsArray VMEinScene[i]))catch()
				try(if (VMEinScene[i].objectData.VMEID as string) == "TMR" then (append myTimersArray VMEinScene[i]))catch()
				--UPDATE PROGRESS BAR1
				myPercent = 100 * i / VMEinScene.count; pbProgress1.value = myPercent; pbProgress1.color = [200 - myPercent * 2,myPercent * 2,0]
			)
		)
		VMEFileName = saveObjektNameET.text
		local filePath
		try(filePath = mySavePath + VMEFileName + ".ms")catch(filePath = (GetDir #scripts) + "\\" + VMEFileName + ".ms")
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		--SOURCE
		source = ""
		--for the count of the rolloutsArray do
			--write the opening to the rollout
			--for each elementArray, write their entries
			--write the closing to the rollout
		local myDialogName
		for j = 1 to myRolloutsArray.count do
		(
			try(myDialogName =  myRolloutsArray[j].name)catch(myDialogName = VMEFileName)
			--
			source += "global " + myDialogName + "\n"
			source += "try destroyDialog " + myDialogName + " catch()\n"
			source += "rollout " + myDialogName + " \" " + myDialogName + "\"\n"
			source += "(\n"
			--
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			--WRITE THE UI ELEMENTS
			source += "    --UI ELEMENTS\n"
			--
			--write the BTNs array
				try
				(
					for g = 1 to myButtonsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myButtonsArray[g].parent == myRolloutsArray[j] then (try(myParent = myButtonsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myButtonsArray[g].pos.x)))-(myButtonsArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myButtonsArray[g].pos.z)))-(myButtonsArray[g].length/2)) as string
							myButtonsArray[g].objectData.xoffset = myOffsetX; myButtonsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myButtonsArray[g].objectData.yoffset = myOffsetZ; myButtonsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    button " + myButtonsArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] width:" + myButtonsArray[g].width as string + " height:" +  myButtonsArray[g].length as string + "\n" --write it properly
						)
					)
				)catch()
				
				
			--write mySlidersArray
				try
				(
					for g = 1 to mySlidersArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if mySlidersArray[g].parent == myRolloutsArray[j] then (try(myParent = mySlidersArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-mySlidersArray[g].pos.x)))-(mySlidersArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-mySlidersArray[g].pos.z)))-(mySlidersArray[g].length/2)) as string
							mySlidersArray[g].objectData.xoffset = myOffsetX; mySlidersArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							mySlidersArray[g].objectData.yoffset = myOffsetZ; mySlidersArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    slider " + mySlidersArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] width:" + (mySlidersArray[g].width+21) as string + " ticks:10 range:[-30,30,0]\n" --write it properly
						)
					)
				)catch()
				
				
			--write mySpinnersArray
				try
				(
					for g = 1 to mySpinnersArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if mySpinnersArray[g].parent == myRolloutsArray[j] then (try(myParent = mySpinnersArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-mySpinnersArray[g].pos.x)))-(mySpinnersArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-mySpinnersArray[g].pos.z)))-(mySpinnersArray[g].length/2)) as string
							mySpinnersArray[g].objectData.xoffset = myOffsetX; mySpinnersArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							mySpinnersArray[g].objectData.yoffset = myOffsetZ; mySpinnersArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    spinner " + mySpinnersArray[g].name as string + " pos:[" + myOffsetX + "," + myOffsetZ + "] fieldwidth:" + (mySpinnersArray[g].width-5) as string + " range:[0,1000,100.00] type:#float\n" --write it properly
						)
					)
				)catch()
				
				
			--write myCheckButtonsArray
				try
				(
					for g = 1 to myCheckButtonsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myCheckButtonsArray[g].parent == myRolloutsArray[j] then (try(myParent = myCheckButtonsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myCheckButtonsArray[g].pos.x)))-(myCheckButtonsArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myCheckButtonsArray[g].pos.z)))-(myCheckButtonsArray[g].length/2)) as string
							myCheckButtonsArray[g].objectData.xoffset = myOffsetX; myCheckButtonsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myCheckButtonsArray[g].objectData.yoffset = myOffsetZ; myCheckButtonsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ								
							source += "    checkbutton " + myCheckButtonsArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] width:" + myCheckButtonsArray[g].width as string + " height:" +  myCheckButtonsArray[g].length as string + "\n" --write it properly
						)
					)
				)catch()
				
				
			--write myPickButtonsArray
				try
				(
					for g = 1 to myPickButtonsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myPickButtonsArray[g].parent == myRolloutsArray[j] then (try(myParent = myPickButtonsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myPickButtonsArray[g].pos.x)))-(myPickButtonsArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myPickButtonsArray[g].pos.z)))-(myPickButtonsArray[g].length/2)) as string
							myPickButtonsArray[g].objectData.xoffset = myOffsetX; myPickButtonsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myPickButtonsArray[g].objectData.yoffset = myOffsetZ; myPickButtonsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    pickbutton " + myPickButtonsArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] width:" + myPickButtonsArray[g].width as string + " height:" +  myPickButtonsArray[g].length as string + "\n" --write it properly
						)
					)
				)catch()
				
				
			--write myCheckBoxesArray
				try
				(
					for g = 1 to myCheckBoxesArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myCheckBoxesArray[g].parent == myRolloutsArray[j] then (try(myParent = myCheckBoxesArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myCheckBoxesArray[g].pos.x)))-(myCheckBoxesArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myCheckBoxesArray[g].pos.z)))-(myCheckBoxesArray[g].length/2)) as string
							myCheckBoxesArray[g].objectData.xoffset = myOffsetX; myCheckBoxesArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myCheckBoxesArray[g].objectData.yoffset = myOffsetZ; myCheckBoxesArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    checkbox " + myCheckBoxesArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] \n" --write it properly
						)
					)
				)catch()
				
				
			--write myColorpickersArray
				try
				(
					for g = 1 to myColorpickersArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myColorpickersArray[g].parent == myRolloutsArray[j] then (try(myParent = myColorpickersArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myColorpickersArray[g].pos.x)))-(myColorpickersArray[g].width/2)-4) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myColorpickersArray[g].pos.z)))-(myColorpickersArray[g].length/2)) as string
							myColorpickersArray[g].objectData.xoffset = myOffsetX; myColorpickersArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myColorpickersArray[g].objectData.yoffset = myOffsetZ; myColorpickersArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    colorpicker " + myColorpickersArray[g].name as string + " pos:[" + myOffsetX + "," + myOffsetZ + "] fieldWidth:" + myColorpickersArray[g].width as string + " height:" +  myColorpickersArray[g].length as string + " color:[0,0,255]\n" --write it properly
						)
					)
				)catch()
				
				
			--write myDropDownlistsArray
				try
				(
					for g = 1 to myDropDownlistsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myDropDownlistsArray[g].parent == myRolloutsArray[j] then (try(myParent = myDropDownlistsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myDropDownlistsArray[g].pos.x)))-(myDropDownlistsArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myDropDownlistsArray[g].pos.z)))-(myDropDownlistsArray[g].length/2)) as string
							myDropDownlistsArray[g].objectData.xoffset = myOffsetX; myDropDownlistsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myDropDownlistsArray[g].objectData.yoffset = myOffsetZ; myDropDownlistsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    dropdownlist " + myDropDownlistsArray[g].name as string + " pos:[" + myOffsetX + "," + myOffsetZ + "] width:" + myDropDownlistsArray[g].width as string + " items:#(\"Temp\", \"Temp\") selection:1\n" --write it properly
						)
					)
				)catch()
				
				
			--write myEditTextsArray
				try
				(
					for g = 1 to myEditTextsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myEditTextsArray[g].parent == myRolloutsArray[j] then (try(myParent = myEditTextsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myEditTextsArray[g].pos.x)))-(myEditTextsArray[g].width/2)-4) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myEditTextsArray[g].pos.z)))-(myEditTextsArray[g].length/2)+3) as string
							myEditTextsArray[g].objectData.xoffset = myOffsetX; myEditTextsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myEditTextsArray[g].objectData.yoffset = myOffsetZ; myEditTextsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ								
							source += "    edittext  " + myEditTextsArray[g].name as string + " pos:[" + myOffsetX + "," + myOffsetZ + "] fieldWidth:" + myEditTextsArray[g].width as string + " height:" +  myEditTextsArray[g].length as string + "\n" --write it properly
						)
					)
				)catch()
				
				
			--write myGroupBoxesArray
				try
				(
					for g = 1 to myGroupBoxesArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myGroupBoxesArray[g].parent == myRolloutsArray[j] then (try(myParent = myGroupBoxesArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myGroupBoxesArray[g].pos.x)))-(myGroupBoxesArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myGroupBoxesArray[g].pos.z)))-(myGroupBoxesArray[g].length/2)+3) as string
							myGroupBoxesArray[g].objectData.xoffset = myOffsetX; myGroupBoxesArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myGroupBoxesArray[g].objectData.yoffset = myOffsetZ; myGroupBoxesArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    groupBox " + myGroupBoxesArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] width:" + myGroupBoxesArray[g].width as string + " height:" +  myGroupBoxesArray[g].length as string + "\n" --write it properly
						)
					)
				)catch()
				
				
			--write myHyperlinksArray
				try
				(
					for g = 1 to myHyperlinksArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myHyperlinksArray[g].parent == myRolloutsArray[j] then (try(myParent = myHyperlinksArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myHyperlinksArray[g].pos.x)))-(myHyperlinksArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myHyperlinksArray[g].pos.z)))-(myHyperlinksArray[g].length/2)) as string
							myHyperlinksArray[g].objectData.xoffset = myOffsetX; myHyperlinksArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myHyperlinksArray[g].objectData.yoffset = myOffsetZ; myHyperlinksArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    hyperLink " + myHyperlinksArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] color:[0,0,255] hoverColor:[0,0,255] visitedColor:[0,0,255] address:\"http://www.google.com/\"\n" --write it properly
						)
					)
				)catch()
				
				
			--write myLabelsArray
				try
				(
					for g = 1 to myLabelsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myLabelsArray[g].parent == myRolloutsArray[j] then (try(myParent = myLabelsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myLabelsArray[g].pos.x)))-(myLabelsArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myLabelsArray[g].pos.z)))-(myLabelsArray[g].length/2)) as string
							myLabelsArray[g].objectData.xoffset = myOffsetX; myLabelsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myLabelsArray[g].objectData.yoffset = myOffsetZ; myLabelsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    label " + myLabelsArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] \n" --write it properly
						)
					)
				)catch()
				
				
			--write myProgressBarsArray
				try
				(
					for g = 1 to myProgressBarsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myProgressBarsArray[g].parent == myRolloutsArray[j] then (try(myParent = myProgressBarsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myProgressBarsArray[g].pos.x)))-(myProgressBarsArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myProgressBarsArray[g].pos.z)))-(myProgressBarsArray[g].length/2)+3) as string
							myProgressBarsArray[g].objectData.xoffset = myOffsetX; myProgressBarsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myProgressBarsArray[g].objectData.yoffset = myOffsetZ; myProgressBarsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    progressBar " + myProgressBarsArray[g].name as string + " pos:[" + myOffsetX + "," + myOffsetZ + "] width:" + myProgressBarsArray[g].width as string + " height:" +  myProgressBarsArray[g].length as string + " value:0 color:[0,96,0] \n" --write it properly
						)
					)
				)catch()
				
				
			--write myRadioButtonsArray
				try
				(
					for g = 1 to myRadioButtonsArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myRadioButtonsArray[g].parent == myRolloutsArray[j] then (try(myParent = myRadioButtonsArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myRadioButtonsArray[g].pos.x)))-(myRadioButtonsArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myRadioButtonsArray[g].pos.z)))-(myRadioButtonsArray[g].length/2)) as string
							myRadioButtonsArray[g].objectData.xoffset = myOffsetX; myRadioButtonsArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myRadioButtonsArray[g].objectData.yoffset = myOffsetZ; myRadioButtonsArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    radiobuttons " + myRadioButtonsArray[g].name as string + " \"caption\" pos:[" + myOffsetX + "," + myOffsetZ + "] labels:#(\"Temp\", \"Temp\", \"Temp\", \"Temp\") columns:2 \n" --write it properly
						)
					)
				)catch()
				
				
			--write myTimersArray
				try
				(
					for g = 1 to myTimersArray.count do
					(
						--set the CA offset values for the object, this ensures all linked elements will have offset values even if the user didn't select them
						local myParent = undefined --try to get the offset from the parent.  --if no parent is available, the object isn't linked to the rollout
						if myTimersArray[g].parent == myRolloutsArray[j] then (try(myParent = myTimersArray[g].parent)catch())
						if myParent != undefined then 
						(
							local myOffsetX = ((abs(floor(myParent.children[1].pos.x-myTimersArray[g].pos.x)))-(myTimersArray[g].width/2)) as string
							local myOffsetZ = ((abs(floor(myParent.children[1].pos.z-myTimersArray[g].pos.z)))-(myTimersArray[g].length/2)) as string
							myTimersArray[g].objectData.xoffset = myOffsetX; myTimersArray[g].objectData.paramsRollout.xoffsetlabel.text = myOffsetX
							myTimersArray[g].objectData.yoffset = myOffsetZ; myTimersArray[g].objectData.paramsRollout.yoffsetlabel.text = myOffsetZ
							source += "    timer " + myTimersArray[g].name as string + " pos:[" + myOffsetX + "," + myOffsetZ + "] interval:1000 active:false \n" --write it properly
						)
					)
				)catch()
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
			/*
				
				
			--WRITE THE EVENTS
			source += "\n    --EVENTS\n"
			--write the BTNs array events
				try
				(
					for g = 1 to myButtonsArray.count do
					(source += "    on " + myButtonsArray[g].name as string + " pressed do (print \"" + myButtonsArray[g].name as string + "\")\n")
				)catch()
				
			--**************************************************** ADD MORE CODE TO HANDLE OTHER TYPES OF UI ELEMENTS HERE
			
			*/
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			--
			source += ")--close rollout\n"
			source += "createDialog " + myDialogName + " " + myRolloutsArray[j].objectData.myrolloutWidth as string + " " + myRolloutsArray[j].objectData.myrolloutLength as string + " 250 100 lockWidth:true lockHeight:true style:#(#style_toolwindow, #style_sysmenu, #style_resizing)\n\n"
			--
		) --CLOSE BUILD ROLLOUT FOR LOOP
		--WRITE SOURCE
		f=openFile filePath mode:"w"
		for i = 1 to source.count do 
		(
			format "%" source[i] to:f
			--UPDATE PROGRESS BAR2
			myPercent = 100 * i / source.count; pbProgress2.value = myPercent; pbProgress2.color = [200 - myPercent * 2,myPercent * 2,0]
		)
		close f
		--launch the scripts just written via fileIn()
		fileIn filePath
	)
)--close rollout
createDialog viewportMaxscriptEditor 220 275 5 90 lockWidth:true lockHeight:true style:#(#style_toolwindow, #style_sysmenu, #style_resizing)