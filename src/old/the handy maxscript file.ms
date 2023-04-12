--The Handy Maxscript file
--useful for remembering the best way to code things
--don't evaluate all, obvs...


first of all, the '&' character:
/*
MAXScript supports by-reference parameter passing. This allows a reference to be passed to a variable, 
property, or array element in the caller's context as a parameter to a function and any assignments 
to that parameter in the called function will be assigned directly to the caller's variable, property. 
or array element. This is often used as a mechanism for passing multiple results back from a function. 
To define by-reference parameters for a function, you prefix them with an '&' character.
*/


--coding best practices
	--break up long lines with the '\' character
	--example:
	foo = standardMaterial twosided:on shininess:34 \ --breaks input parameters to next line
	diffuseMap:baz \
	opacityMap:bar \
	bumpMap:boo
	
	--use ';' character to put many commands on one line
	--example:
	print "End of input data reached" to:f ; close f ; f = undefined
	if a < 0 do (print "value out of range";a=0)
	--this helps to keep things nicely bunched together at times





--user keyboard input captures
if keyboard.shiftPressed == true do print "shift pressed." --evaluate with shift key pressed and not pressed
keyboard.controlPressed
keyboard.altPressed
keyboard.escPressed

escapeEnable
/*
Lets you get and set a Boolean value defining whether ESC key interrupt detection is 
on or off. Setting enableEscape to false turns ESC key interrupt detection off, setting 
it to true turns it on again. This variable is useful when used in conjunction with a Progress Bar.
*/






--logic 
while variable1 do (
	--while variable1 is true, do.  notice lack of test: if variable1 == true do...
)

true is synonymous to on and 1
false is synonymous to off and 0

--comparisons
<compare_operand> == <compare_operand> -- equal
<compare_operand> != <compare_operand> -- not equal
<compare_operand> > <compare_operand> -- greater than
<compare_operand> < <compare_operand> -- less than
<compare_operand> >= <compare_operand> -- greater than or equal
<compare_operand> <= <compare_operand> -- less than or equal

--and, or, not
<logical_operand> or <logical_operand> -- true if either operand is true
<logical_operand> and <logical_operand> -- true if both operands are true
[ not ] <logical_operand> -- true if operand is false

--EXECUTE
execute <string> --Compiles and evaluates the contents of the string as a MAXScript 
				--expression and returns the result of the evaluation
				--example:
		execute "2 + 2" -- yields the value 4
		--ex2:
		str = "$foo.ffd_2x2x2.control_point_" +
		n as string + " = [1,1,1]" --builds the 'code' string
		execute str --tells max to evaluate the code string






--selections
select $*SBC* --will select all objects with 'SBC' anywhere in the name.  
			-- very useful for scripts that operate off naming convention

rootNode --a special node that contains all non-linked nodes (parents) as children
		--The scene can be enumerated by accessing the children property of the root node.






--memory management			
undo on  --allows undo to happen to following block
(
	delete $box*
	delete $sphere*
	clearUndoBuffer()
)
undo off  --can't undo following expression block
(
	delete $box*
	delete $sphere*
	clearUndoBuffer()
)
clearUndoBuffer() --clears out the undo buffer

sysinfo.getSystemMemoryInfo() --returns a 7 element array containing system memory status data
								--use this to determine system memory when working on big operations
/*
(
r=sysinfo.getSystemMemoryInfo()
for i=2 to 7 do r[i] /= (1024*1024.)
format "percent of memory in use:\t%\n" r[1]
format "total physical memory:\t% MB\n" r[2]
format "free physical memory:\t% MB\n" r[3]
format "used physical memory:\t% MB\n" (r[2]-r[3])
format "total paging file size:\t% MB\n" r[4]
format "free paging file size:\t% MB\n" r[5]
format "used paging file size:\t% MB\n" (r[4]-r[5])
format "total virtual memory:\t% MB\n" r[6]
format "free virtual memory:\t\t% MB\n" r[7]
format "used virtual memory:\t\t% MB\n" (r[6]-r[7])
ok
)
returns:
percent of memory in use: 0
total physical memory: 255.359 MB
free physical memory: 16.5156 MB
used physical memory: 238.844 MB
total paging file size: 1016.3 MB
free paging file size: 757.898 MB
used paging file size: 258.398 MB
total virtual memory: 2047.88 MB
free virtual memory:  1846.55 MB
used virtual memory:  201.328 MB
OK
*/





--file actions and whatnot
maxFilePath --Contains a String value that defines the directory path for the currently open scene. read-only.
maxFileName --Contains a String value that defines the file name for the currently open scene. read-only.
sceneName = maxFilePath + maxFileName --the way to get the filename



























