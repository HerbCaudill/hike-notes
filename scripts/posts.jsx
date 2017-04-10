import React from 'react'; 
import ReactDOM from 'react-dom'; 
import axios from 'axios'; 

class Posts extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      posts: null
    };
  }
    
  componentDidMount() {
    axios.get('/api/posts')
      .then((result) => {
        this.setState({posts: result.data})
      })
  }

  render() {
    return(
      <div>
        <h1>Posts</h1>
        { 
          !this.state.posts ? 
            (
              <div className='spinner'>
                Loading...
              </div>
            )
          :
            this.state.posts.map((post) => (
                <div key={post.id}>
                  <h2>{post.title}</h2>
                  <p>{post.body}</p>
                </div>
              )
            )
        }
      </div>
    )
  }

};
            
export default Posts;
