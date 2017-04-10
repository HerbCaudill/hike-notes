express = require 'express'
server = express()
bodyParser = require 'body-parser'
datastore = require('./datastore').async
    

module.exports = (PORT) ->

    server.use bodyParser.urlencoded extended: false
    server.use bodyParser.json()
    server.use express.static __dirname + '/'

    handleError = (err, response) ->
        response.status 500
        response.send "<html><head><title>Internal Server Error!</title></head><body><pre>#{JSON.stringify(err, null, 2) }</pre></body></pre>"
        return

    connectOnProjectCreation = ->
        new Promise (resolving) ->
            if !connected
                connected = datastore.connect().then(->
                    resolving()
                    return
                )
            else
                resolving()
            return

    initializeDatastoreOnProjectCreation = ->
        new Promise (resolving) ->
            datastore.get('initialized').then (init) ->
                if !init
                    datastore.set('posts', initialPosts).then ->
                        datastore.set('initialized', true).then ->
                            resolving()
                            return
                        return
                else
                    resolving()
                return
            return

    connected = false 


    # ROUTES


    server.get '/api/posts', (request, response) ->
        #response.send initialPosts
        try
          posts = datastore.get('posts')
          .then (posts) ->
              response.status 200
              response.send posts
          .catch (err) ->
              console.log JSON.stringify err
        catch err
            handleError err, response
        return
        
    server.post '/posts', (request, response) ->
        try
            posts = datastore.get('posts').then (posts) ->
                posts.push request.body
                datastore.set('posts', posts).then (posts) ->
                    response.redirect '/'
                    return
                return
        catch err
            handleError err, response
        return

    server.get '/reset', (request, response) ->
        try
            datastore.removeMany([
                'posts'
                'initialized'
            ]).then ->
                response.redirect '/'
                return
        catch err
            handleError err, response
        return

    server.get '/delete', (request, response) ->
        try
            datastore.set('posts', []).then ->
                response.redirect '/'
                return
        catch err
            handleError err, response
        return

    initialPosts = [
            id: 1
            title: 'Hello!'
            body: 'Among other things, you could make a pretty sweet blog.'
        ,
            id: 2
            title: 'Another Post'
            body: 'Today I saw a double rainbow. It was pretty neat.'
    ]


    connectOnProjectCreation() 
    .then -> initializeDatastoreOnProjectCreation()
    .then -> server.listen PORT, -> 
        console.log "API listening on port #{PORT}"

