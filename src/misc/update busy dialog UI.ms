


--the great denisT shows us how to force update a dialog while the dialog is busying doing work

(
	--disable windows ghosting via denisT's method
  	source = ""
  	source += "using System;\n"
  	source += "using System.Runtime.InteropServices;\n"
  	source += "class WindowsGhosting\n"
  	source += "{\n"
  	source += "	[DllImport(\"user32.dll\")]\n"
  	source += "	public static extern void DisableProcessWindowsGhosting();\n"
  	source += "}\n"
  	csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
  	compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
  	compilerParams.GenerateInMemory = on
  	compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)
  	assembly = compilerResults.CompiledAssembly
  	windowsGhosting = assembly.CreateInstance "WindowsGhosting"
  	windowsGhosting.DisableProcessWindowsGhosting()
)






global _user32
fn CreateUser32Assembly =
(
	source = "using System;\n"
	source += "using System.Runtime.InteropServices;\n"
	source += "class User32\n"
	source += "{\n"
	source += " [DllImport(\"user32.dll\")]\n"
	source += " static extern bool RedrawWindow(IntPtr hWnd, IntPtr lprcUpdate, IntPtr hrgnUpdate, uint flags);\n"
	source += " static uint FULL_REDRAW = 0x0185;\n"
	source += " public bool RedrawAllWindow(Int32 hWnd) { return RedrawWindow((IntPtr)hWnd, IntPtr.Zero, IntPtr.Zero, FULL_REDRAW); }\n"
	source += "}\n"

	csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
	compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"

	compilerParams.ReferencedAssemblies.AddRange #("System.dll")
	compilerParams.GenerateInMemory = on

	compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)
	_user32 = compilerResults.CompiledAssembly.CreateInstance "User32"
)
CreateUser32Assembly()







try(destroydialog sleepUI) catch()
rollout sleepUI "Sleep UI" width:200
(
	label info_lb "" width:190 pos:[5,-6] visible:on
	checkbutton action_bt "Execute" width:190 pos:[5,9]

	on action_bt changed state do if state do
	(
		action_bt.text = "Executing... (Press ESC to cancel)"
		action_bt.enabled = off
		setfocus info_lb

		dialog_hwnd = (windows.getchildhwnd 0 sleepUI.title)[1]
		button_hwnd = (windows.getchildhwnd dialog_hwnd action_bt.text)[1]
		_user32.RedrawAllWindow button_hwnd

		while not keyboard.escpressed do
		(
			sleep (random 0.01 0.2)
			if (getTextExtent info_lb.text).x < 190 then info_lb.text += "." else info_lb.text = "."
		)
		info_lb.text = ""
		action_bt.text = "Execute"
		action_bt.state = not (action_bt.enabled = on)
	)
)
createdialog sleepUI