# hikenotes.com

### To run: 

- In command window, navigate to root folder (e.g. `cd c:\git\hike-notes`)
- Run `npm start`
- In a browser, go to `http://localhost:9001`

### To do: 

- 



### Schema

user

- first
- last
- email
- photo

hike

- user
- title
- trail
- description
- content
- distance
- days
- waypoints 
    -  location
- stops
    -  location
    -  name
- section
    -  distance
    -  time
    -  elevation
    -  start
    -  end
- posts

post

- timestamp
- content
- photos
  
photo

- caption
- timestamp
- location

  
location = lat, lng, elevation 

