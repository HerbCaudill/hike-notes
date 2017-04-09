React = require 'react' 
ReactDOM = require 'react-dom' 
axios = require 'axios' 

{section,input,ul,div,header,h1,h2,h3,h4,p} = React.DOM


module.exports = class Posts extends React.Component

  constructor: (props) ->
    super props
    @state = 
      posts: null
    
  componentDidMount: ->
    @setState posts: [
        id: 1
        title: 'Hello!!'
        body: 'Among other things, you could make a pretty sweet blog'
      ,
        id: 2
        title: 'Another Post'
        body: 'Today I saw a double rainbow. It was pretty neat.'
    ]
    #axios.get '/api/posts'
    #  .then (result) =>
    #    @setState posts: result.data

  render: ->
    div {}, 
      h1 {}, "Posts"
      if !@state.posts
        div
          className: 'spinner'
          "Loading..."
      else
        for post in @state.posts
          div
            key: post.id
            h2 {}, post.title
            p {}, post.body
            