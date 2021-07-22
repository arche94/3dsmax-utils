/*
Credits@Paolo Preziuso

1 - Define server project folder
2 - Define project name
3 - Define pass name
4 - Update render settings
*/

SERVER_PROJECTS = "//apxh-ws001/apxh_001/projects"
PROJECT = "amk_tdcrashcourse"
PASSNAME = "UpdateRenderSettings"

FILENAME_FULL = (substring maxFileName 1 (maxFileName.count - 4)) + "_" + PASSNAME
RENDER_PATH = SERVER_PROJECTS + "/" + PROJECT + "/" +  FILENAME_FULL 

makeDir RENDER_PATH

rendOutputFilename = RENDER_PATH + "/" + FILENAME_FULL + "_f.jpg" 
rendTimeType = 2
rendSaveFile = true

renderSceneDialog.update()