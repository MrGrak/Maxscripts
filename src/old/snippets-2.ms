--Snippets v0.01 by GarrickCampsey.com //updated:11.29.10
( --start script
global snippetsRollout
try destroyDialog snippetsRollout catch()

















--SCRIPT INDEX
--errors and defaults
local theDefaultMessage = "This is the default message.\nThis is a new line."
local theErrorMessage = "Error, couldn't find snippet."
local theErrorMessageDD = #("Error, couldn't find topic.")
--THE TOPICS ARRAY
local topicsArray = #(\
	"Script Layout", "UI"\
	)
--THE SNIPPETS ARRAYS
local scriptLayoutArray = #(\
	"BasicLayout", "Layout 2", "Layout 3", "Layout 4", "Layout 5"\
	)
local UIarray = #(\
	"Angle", "Bitmap", "Button", "Checkbox", "Checkbutton", "Colorpicker", "Combobox", "Dropdown List",\
	"EditText", "GroupBox", "Label", "Listbox", "MapButton", "MaterialButton", "Multilist Box", "PickButton",\
	"PopUpMenu", "ProgressBar", "RadioButtons", "Slider", "Spinner", "Timer"\
	)
--
--CODE SNIPPETS
local BasicLayoutSnippet = "--Basic Script Layout

( --start script
global myRollout
try destroyDialog myRollout catch()
--
local myVariable = \"something\"
--
fn myFunction = ()
--
rollout myRollout \" myRollout\"
(
	--UI
	--Events
)
--
createDialog myRollout 500 355 10 100 lockWidth:true lockHeight:true \
style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script
" --end BasicLayoutSnippet
--

















--FUNCTIONS
fn Topics topicName =
(
	case of
	(
		(topicName == "Script Layout"):return scriptLayoutArray
		(topicName == "UI"):return UIarray
		default:return theErrorMessageDD
	)
)
fn Snippets snippetsName =
(
	case of
	(
		(snippetsName == "BasicLayout"):return BasicLayoutSnippet
		(snippetsName == "Layout 2"):return theDefaultMessage
		(snippetsName == "Layout 3"):return theDefaultMessage
		(snippetsName == "Layout 4"):return theDefaultMessage
		(snippetsName == "Layout 5"):return theDefaultMessage
		default:return theErrorMessage
	)
)

















--UI
rollout snippetsRollout " Snippets v0.01"
(
	--UI
	
	dropdownlist topicList "Topic" items:topicsArray width:490 pos:[5,5]
	dropdownlist snippetList "Snippet" items:#("Choose a topic...") width:490 pos:[5,50]
	edittext myEditTxt text:"Choose a snippet..." width:490 height:350 pos:[3,100]
	label correctionsLabel "Send code corrections and suggestions to Garrick@GarrickCampsey.com" pos:[145,5]
	--Events
	on topicList selected i do (snippetList.items = Topics topicList.items[i])
	on snippetList selected i do (myEditTxt.text = Snippets snippetList.items[i])
) --end rollout
createDialog snippetsRollout 500 455 10 100 lockWidth:true lockHeight:true \
style:#(#style_toolwindow, #style_sysmenu, #style_resizing)
) --close script
