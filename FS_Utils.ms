function saveRenderFile netPath elName:"" = (
	print "-- Creating render file --"
	renderFilePath = netPath + @"scenes\"
	makeDir renderFilePath
	renderFile = renderFilePath + ((FilterString maxFileName ".")[1]) + elName + ".max"
	saveMaxFile renderFile useNewFile:false quiet:true
	print "-- Render file created --"
	return renderFile
)