--	The Viewport Maxscript Editor V2
--	by Garrick@GarrickCampsey 2011.03.01
--	with DragAndDrop by Matthew Lichy

--	High level description
--	onScriptRun do
--		load all category folders into categories dropDown
--		load first node folders contents (.ms + .png files)
--		build DragAndDropIcons from .pngs

--	onDragandDrop icon dropped do
--		load the proper .ms file
--		get the build parameters from the .ms file
--             build node based on these parameters 
--             (can be: rectangle or circle; and prox circle and text)
--		get the code parameters from the .ms file
--             write them to the node.CA.rollout.EditTextExe

--	onWriteScript pressed do
--		gather all nodes in scene, filter vme nodes with proper cas
--		evaluate parent/child relationship to an ordered array
--		for the array.count, add the node's CA.rollout.EditTextExe.text to source
--		write source to file, fileIn file just written

--	Script layout  --the script will write .ms files based on this layout
--		global viewportMaxscriptEditor
--		try destroyDialog viewportMaxscriptEditor catch()
--		rollout viewportMaxscriptEditor " Viewport Maxscript Editor v1.1"
--		(
--			values
--			fns declared
--			--
--			fns defined
--			ui defined
--			--
--			events for ui
--		) --close rollout
--		createDialog viewportMaxscriptEditor

--	Script directory layout
--		vmeV2.ms
--			/nodes/
--				UIelements/ #(rollout, button, ,etc...)
--				values/ #(value, integer, string, etc...)
--				etc...










-- rough 'group node to node file' code dev
Local myGoupedNodeCodeString = "this is a code string"
( --xml reader code by denisT
	doc = dotNetObject "system.xml.xmlDocument"
	sr = dotnetobject "System.IO.StringReader" (getUserPropBuffer $)
	doc.Load sr

	ss = doc.SelectSingleNode "//Node/BuildParams"
	ss.InnerText = myGoupedNodeCodeString

	settings = dotnetobject "System.Xml.XmlWriterSettings"
	settings.OmitXmlDeclaration = on
	settings.Indent = on
	sw = dotnetobject "System.IO.StringWriter"
	xw = (dotnetclass "System.Xml.XmlWriter").Create sw settings
	doc.Save xw
	setUserPropBuffer $ (sw.ToString())
 )
 example xml:
 <Node>
     <BuildParams>string</BuildParams>
     <WriteParams>string</WriteParams >
 </Node>









fn easyQuotes myString = (
	local myFixedString = ""
	for i = 1 to myString.count do
	(
		case of
		(
			(myString[i] as string == "\\""): myFixedString += ("\\\\" + myString[i])
			default: myFixedString += myString[i]
		)
	)
	print myFixedString
)
easyQuotes myStringcode