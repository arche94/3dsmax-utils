/* 
Credits@Paolo Preziuso

COMMAND ARGS

0 - Input sequence (Nuke format)
1 - Output location (without extension)
2 - Artist name
3 - Maxfile location
*/

-- NUKE INFOS
NUKE_EXE = "C:\Program Files\Nuke13.0v2\Nuke13.0.exe"
NUKE_FILE = "\"C:\Users\pprez\Desktop\FX TD Training\AMK_CrashCourse\AMKCrashCourse_previews.nknc\""

-- RENDER INFOS
SERVER_PROJECTS = "//apxh-ws001/apxh_001/projects"
PROJECT = "amk_tdcrashcourse"
PASSNAME = "UpdateRenderSettings"

FILENAME_FULL = (substring maxFileName 1 (maxFileName.count - 4)) + "_" + PASSNAME
RENDER_PATH = SERVER_PROJECTS + "/" + PROJECT + "/" +  FILENAME_FULL 

-- OPTIONS
switches = #("-nc","-x", "-F 1-100")

INPUT_SEQUENCE = RENDER_PATH + "/" + FILENAME_FULL + "_f####.jpg" 
OUTPUT_LOCATION = maxFilePath + "/previews/" + FILENAME_FULL
ARTIST_NAME = "Paolo Preziuso"
MAXFILE_LOCATION = maxFilePath + maxFileName
args = #(INPUT_SEQUENCE, OUTPUT_LOCATION, ARTIST_NAME, MAXFILE_LOCATION)

-- EXEC
commandArgs = ""
for item in switches do (
    commandArgs += " " + item 
)
commandArgs += " " + NUKE_FILE
for arg in args do (
    commandArgs += " \"" + arg + "\""
)

-- Print (NUKE_EXE + commandArgs)
ShellLaunch NUKE_EXE commandArgs