'use strict'

webpack = require 'webpack'

module.exports =

    cache: true
    
    devtools: 'cheap-module-eval-source-map'
    
    entry: 
        app: './bundle.app.coffee'
        vendor: './bundle.vendor.coffee'
    
    output:
        path: __dirname
        filename: '[name].js'
        chunkFilename: '[hash]/js/[id].js'
        hotUpdateMainFilename: '[hash]/update.json'
        hotUpdateChunkFilename: '[hash]/js/[id].update.js'
        publicPath: '/dist/'
        
    module:
        loaders: [
                test: /\.coffee$/
                loaders: ['react-hot', 'coffee']
                exclude: /node_modules/
            ,
                test: /\.scss/
                loader: 'style!raw!sass'
                exclude: /node_modules/
            ,                
                test: /\.(png|jpg|jpeg|gif|svg|woff|woff2|ttf|eot)$/
                loader: 'file'
            ,
                test: /\.html$/,
                loader: 'html'
            , 
                test: /\.svg$/,
                loader: 'svg'
        ]
        noParse: [ 
            /iconic\.js/ 
        ]
        
    resolve:
        alias:
            'jquery': "#{__dirname}/node_modules/jquery/dist/jquery.js"
        extensions: [
            ''
            '.coffee'
            '.js'
        ]
        
    plugins: [
        new (webpack.ProvidePlugin)
            $: 'jquery'
            jQuery: 'jquery'
            'window.jQuery': 'jquery'
    ]
    

