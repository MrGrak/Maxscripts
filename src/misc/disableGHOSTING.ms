--this code disables windows ghosting, so max can update normally
(
source = ""
source += "using System;\n"
source += "using System.Runtime.InteropServices;\n"
source += "class WindowsGhosting\n"
source += "{\n"
source += " [DllImport(\"user32.dll\")]\n"
source += " public static extern void DisableProcessWindowsGhosting();\n"
source += "}\n"

csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"

compilerParams.GenerateInMemory = on
compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)

assembly = compilerResults.CompiledAssembly
windowsGhosting = assembly.CreateInstance "WindowsGhosting"
windowsGhosting.DisableProcessWindowsGhosting()
)