React = require 'react' 
ReactDOM = require 'react-dom' 
axios = require 'axios' 
$ = require 'jquery'

Posts = require './posts.coffee'

{section,input,ul,div,header,h1,h2,h3,h4,p} = React.DOM

create = React.createElement

class App extends React.Component
  
  constructor: (props) ->
    super props
    return

  render: ->
    div {}, 
      create Posts
      

ReactDOM.render(
  create App
  document.getElementById 'app'
)
