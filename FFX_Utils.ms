 -- include "FS_Utils"
-- include "NetRend_utils"

PREFIX_VERSION="_v"
PREFIX_FRAME="_f"

FFX_PROJECT_BASE_PATH=@"Z:\simulations\FumeFX\Venom\"
ELEMENT_CATEGORY="Atmospherics"
ELEMENT_NAME="Smoke"
CURR_VERSION="001"
SIM_EXTENSION=".vdb"

function setFFXPath version:CURR_VERSION elName:ELEMENT_NAME elCategory:ELEMENT_CATEGORY = (
	print "-- START OF setFFXPath --"
	for element in $ do (
		if (classOf element == FumeFX) then (
			simPath = FFX_PROJECT_BASE_PATH + elCategory + PREFIX_VERSION + version + @"\"
			simName = (getFilenameFile rendOutputFilename) + "_"  + elName + PREFIX_VERSION + version + PREFIX_FRAME + SIM_EXTENSION
			makeDir simPath
			simFullName = simPath + simName
			element.setPath simFullName #("default","nocheck")
			print ("New path: " + element.getPath "default")
		)
	)
	return "-- END OF setFFXPath --"
)

function simOnNetwork jobTitle:undefined simStartF:undefined simEndF:undefined = (
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
		submitNewJob man jFile:file jName:((getFilenameFile rendOutputFilename) + "_" + element.name) jStartFrame:simStartF jEndFrame:simEndF
		element.backburnerSim = off
		hide element
	)
	
	animationRange = interval projStartF projEndF
)	