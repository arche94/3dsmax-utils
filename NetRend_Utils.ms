SERVER="apxh-ws001"
RENDER_PATH=@"\\apxh-ws001\apxh_001\renders\"
PROJECT=@"\DTLA_001_001\"
FILENAME="DTLA_001_001_FX_Explosions"
CURRENT_VERSION="002"


function saveRenderFile netPath elName:"" = (
	print "-- Creating render file --"
	renderFilePath = netPath + @"\scenes\"
	makeDir renderFilePath
	renderFile = renderFilePath + ((FilterString maxFileName ".")[1]) + "_" + elName + "_.max"
	saveMaxFile renderFile useNewFile:false quiet:true
	print "-- Render file created --"
	return renderFile
)

function setRenderFilename = (
	rendPath = RENDER_PATH + PROJECT + FILENAME + "_v" + CURRENT_VERSION
	rendBaseName = rendPath + @"\" + FILENAME + "_v" + CURRENT_VERSION
	rendOutputFilename = rendBaseName + "_.exr"
)	

function connect2Server serverName:SERVER = (
	print "-- Connecting to \"" + serverName + "\""
	server = serverName
	manager = netrender.GetManager()
	manager.connect #manual server
	print "-- Connection with \"" + serverName + "\" established --"
	return manager
)

function submitNewJob manager jFile jName:FILENAME jPriority:5 jStartFrame:0 jEndFrame:0 jCamera:undefined = (
	print "-- Submitting new job --"
	job = manager.newJob file:jFile
	job.priority = jPriority
	job.fromFrame = jStartFrame
	job.toFrame = jEndFrame
	if (jCamera != undefined) then (
		job.renderCamera = jCamera
	) else (
		job.renderCamera = cameras[1].name
	)
	job.submit()
	print "-- Job correctly submitted --"
) 

function renderOnNetwork elName:"" submit:true = (
	renderSceneDialog.close()
	rendFilename = rendOutputFilename
	vr = renderers.current
	rendSaveFile = true
	rendPath = RENDER_PATH + PROJECT + FILENAME + "_v" + CURRENT_VERSION
	rendBaseName = rendPath + @"\" + FILENAME + "_v" + CURRENT_VERSION + "_" + elName
	rendOutputFilename = rendBaseName + "_.exr"
	
	if (classOf renderers.current == V_Ray_5__update_1) then (
		-- V-Ray Raw options
		vr.output_saveRawFile = true
		vr.output_rawFileName = rendBaseName + "_vray_.exr"
	)
	
	rendFile = saveRenderFile rendPath	elName:elName
	
	if (submit) then (
		connManager = connect2Server()
		submitNewJob connManager rendFile jStartFrame:animationRange.start jEndFrame:animationRange.end
	) else (
		DOSCommand rendFile
	)

	rendSaveFile = false
	rendOutputFilename = rendFilename
	if (classOf renderers.current == V_Ray_5__update_1) then (
		-- Reset V-Ray Raw options
		vr.output_saveRawFile = false
	)
)

