webpackServer = require './server-webpack'
apiServer = require './server-api'

PROD = process.env.NODE_ENV is "production"
PORT = process.env.PORT or 9001

if PROD
	console.log 'running production'
	apiServer PORT
else
	console.log 'running development'
	#apiServer PORT - 1
	webpackServer PORT
