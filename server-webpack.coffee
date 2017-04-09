module.exports = (PORT) ->


    WebpackNotifierPlugin = require 'webpack-notifier' 
    WebpackDevServer = require 'webpack-dev-server'

    webpack = require 'webpack'
    config = require './webpack.config.coffee'

    # add hot replacement entry points to config (only in development)
    config.entry.app = [
        "webpack-dev-server/client?http://localhost:#{PORT}"
        'webpack/hot/only-dev-server'
        config.entry.app
    ]

    config.plugins.push new WebpackNotifierPlugin
    config.plugins.push new webpack.HotModuleReplacementPlugin()



    compiler = webpack config

    server = new WebpackDevServer compiler, 
        publicPath: config.output.publicPath
        hot: true
        inline: true
        contentBase: "."  
        noInfo: true  


    server.listen PORT, 'localhost', (err, result) ->
        if err 
            console.log err
        else
            console.log "webpack listening on port #{PORT}"

