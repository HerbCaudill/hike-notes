import React from "react";
import ReactDOM from "react-dom";
import axios from "axios";
import $ from "jquery";

import Posts from "./posts.jsx";

class App extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className="body-inner">
        <aside className="navigator">
          aside
        </aside>
        <main className="main">
          <header>
            header
          </header>
          <div className="posts">
            <Posts />
          </div>
        </main>
      </div>
    );
  }
}

ReactDOM.render(<App />, document.getElementById("app"));