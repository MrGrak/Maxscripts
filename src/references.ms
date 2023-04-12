/*
--clear entire scene
resetMaxFile #noPrompt

--just delete geometry
max select all
if $ != undefined then ( delete $ )

--set units to us american
units.DisplayType = #US

--struct w/ fields + methods example
struct A_Struct_Example 
(
	--a field example (int, maybe or double)
	var_myInt = 0,
	
	--can declare undefined variables too
	var_undef = undefined,
	
	--predeclare functions/methods
	fn A_Method = (),
	
	--implementation of fn/method
	fn A_Method_With_Params A_Parameter = 
	(
		
	)
)

move spline_3 [spline_3.X,spline_3.Y,0]

showClass "splineShape.*"


--flip studs to be offset
if(flip)then
(
	--group all studs in plate array
	group plate_array name:"temp_plate_group"
	--center pivot, rotate 180
	CenterPivot $temp_plate_group
	rotate $temp_plate_group (eulerangles 0 0 180)
	--ungroup studs
	ungroup $temp_plate_group
)


fn WeldVerts vA vB TheMesh = 
(
	select TheMesh
	subobjectlevel=1
	
	$.selectedVerts = #{vA,vB}
	arr = $.selectedVerts
	p = $.selectedverts[1].pos
	meshop.weldVertSet $ arr weldpoint:p
)

--ConvertTo Rough Editable_Mesh
--$.selectedVerts = #{3,1}

Rough = Box lengthsegs:1 widthsegs:1 heightsegs:1 length:builderDialog.gen_length.value width:(builderDialog.gen_width.value*0.5) height:builderDialog.gen_height.value pos:[0,0,0] 
Rough.wirecolor = [200, 200, 200]
Rough.name = "Roof_Base"
Rough.pos.x = Rough.width * 0.5
ConvertTo Rough Editable_Mesh

--weld to create one side of roof
WeldVerts 8 7 Rough
WeldVerts 6 5 Rough
--delete interior faces
select Rough
subobjectlevel=2
ep.Select #Face #{1..24} 
ep.SetOperation #DeleteFace
ep.Commit()

--subobjectlevel=4

*/




--this code disables windows ghosting, so max can update normally
/*
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
*/
