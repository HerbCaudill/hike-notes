module.exports = (PORT) ->


    WebpackNotifierPlugin = require 'webpack-notifier' 
    WebpackDevServer = require 'webpack-dev-server'

    webpack = require 'webpack'
    config = require './webpack.config.coffee'

    # modify config for development environment

    config.entry.app = [
        "webpack-dev-server/client?http://localhost:#{PORT}"
        'webpack/hot/only-dev-server'
        config.entry.app
    ]

    config.plugins.push new WebpackNotifierPlugin
    config.plugins.push new webpack.HotModuleReplacementPlugin()

    # start server

    compiler = webpack config

    server = new WebpackDevServer compiler, 
        publicPath: config.output.publicPath
        hot: true
        inline: true
        contentBase: "."  
        noInfo: true  
        proxy: 
            "*": "http://localhost:#{PORT - 1}"

    server.listen PORT, 'localhost', (err, result) ->
        if err 
            console.log err
        else
            console.log "webpack listening on port #{PORT}"

