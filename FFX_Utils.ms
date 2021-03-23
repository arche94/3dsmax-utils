-- include "FS_Utils"
-- include "NetRend_utils"

PREFIX_VERSION="_v"
PREFIX_FRAME="_f"

FFX_PROJECT_BASE_PATH=@"\\apxh-ws001\apxh_001\simulations\FumeFX\DTLA_001_001_FX\"
ELEMENT_CATEGORY="Explosions"
CURR_VERSION="005"
SIM_EXTENSION=".vdb"

function setFFXPath version:CURR_VERSION elCategory:ELEMENT_CATEGORY = (
	print "-- START OF setFFXPath --"
	simPresetsPath = pathConfig.getCurrentProjectFolder() + @"presets\FFX\"
	for element in $ do (
		if (classOf element == FumeFX) then (
			simPath = FFX_PROJECT_BASE_PATH + elCategory + PREFIX_VERSION + version + @"\"
			simName = (getFilenameFile rendOutputFilename) + "_"  + element.name + PREFIX_VERSION + version + PREFIX_FRAME + SIM_EXTENSION
			waveletSimName = (getFilenameFile rendOutputFilename) + "_"  + element.name + PREFIX_VERSION + version + "_wavelet_" + PREFIX_FRAME + SIM_EXTENSION
			makeDir simPath
			simFullName = simPath + simName
			waveletSimFullName = simPath + waveletSimName
			element.setPath simFullName #("default","nocheck")
			element.setPath waveletSimFullName #("wavelet", "nocheck")
			element.setPath simPresetsPath #("defaultpreset", "nocheck")
			print ("New path: " + element.getPath "default")
			print ("New wavelet path: " + element.getPath "wavelet")
		)
	)
	return "-- END OF setFFXPath --"
)

function simOnNetwork jobTitle:undefined simStartF:undefined simEndF:undefined submit:true = (
	renderSceneDialog.close()
	rendSaveFile = false
	
	projStartF = animationRange.start.frame
	projEndF = animationRange.end.frame
	
	if (simStartF == undefined) then (
		simStartF = animationRange.start.frame
	)
	if (simEndF == undefined) then (
		simEndF = animationRange.end.frame
	)
	animationRange = interval simStartF simEndF
	
	man = connect2Server()
	
	for element in $ do (
		element.backburnerSim = on
		file = saveRenderFile FFX_PROJECT_BASE_PATH elName:element.name
		if (submit) then (
			submitNewJob man file jName:((getFilenameFile rendOutputFilename) + "_" + element.name) jStartFrame:simStartF jEndFrame:simStartF
		) else (
			DOSCommand file
		)
		element.backburnerSim = off
		hide element
	)
	
	animationRange = interval projStartF projEndF
)	

function addLights activeLights:undefined = (
	if (activeLights == undefined) then (
		sceneLights = lights as Array
	) else (
		sceneLights = #()
		for activeLight in activeLights do (
			sceneLights = append sceneLights (getNodeByName activeLight)
		)
	)
	for fumegrid in $ do (
		for sceneLight in sceneLights do (
			fumegrid.addLight sceneLight
		)
	)
)