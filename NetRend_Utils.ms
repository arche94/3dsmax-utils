SERVER="apxh-ws001"

function connect2Server serverName:SERVER = (
	print "-- Connecting to \"" + serverName + "\""
	server = serverName
	manager = netrender.GetManager()
	manager.connect #manual server
	print "-- Connection with \"" + serverName + "\" established --"
	return manager
)

function submitNewJob manager jFile:undefined jName:undefined jPriority:5 jStartFrame:0 jEndFrame:0 jCamera:undefined = (
	print "-- Submitting new job --"
	if (jFile != undefined) then (
		job = manager.newJob file:jFile
	) else (
		job = manager.newJob()
	)
	job.name = jName
	job.priority = jPriority
	job.fromFrame = jStartFrame
	job.toFrame = jEndFrame
	if (jCamera != undefined) then (
		job.renderCamera = jCamera
	) else (
		cameras[1].name
	)
	job.submit()
	return "-- Job \"" + job.name + "\" correctly submitted --"
) 