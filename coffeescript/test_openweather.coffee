
site = 'openweathermap'

getData = require('./'+site)


# capc = {}
# capc.location = {}
# capc.location.latitude = 44.849264
# capc.location.longitude = -0.572434

# getData capc,(data)->

# 	console.log data

location = {}
location.latitude = 43.452581
location.longitude = -1.444826

getData location,(name,data)->

	#console.log data