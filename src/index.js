"use strict";

import "./index.html";
import "./styles.scss";

import api from "./database";
import Elm from "./Main.elm";

const mountNode = document.getElementById("main");
const app = Elm.Main.embed(mountNode);

const feedsPort = app.ports.updateFeedIds;
const updateItem = app.ports.updateItem;

app.ports.subscribeToFeed.subscribe(feed => {
  api.child(feed).off();
  api.child(feed).on("value", snapshot => feedsPort.send(snapshot.val()));
});

app.ports.loadTopic.subscribe(topicId => {
  fetchItem(topicId, function(story) {
    fetchTopic(story.kids);
  });
});

function fetchTopic(ids) {
  ids.forEach(id => {
    fetchItem(id, item => {
      updateItem.send(item);
      if (item.kids && item.kids.length > 0) {
        fetchTopic(item.kids);
      }
    });
  });
}

function fetchItem(id, cb) {
  api.child(`/item/${id}`).off();
  api.child(`/item/${id}`).on("value", snapshot => {
    const item = snapshot.val();
    item["type_"] = item.type;
    cb(item);
  });
}

app.ports.loadStoriesById.subscribe(ids => {
  ids.forEach(id => {
    fetchItem(id, updateItem.send);
  });
});

// Rgb Split with text-shadow
const setShadow = () => {
  let displace = 2 - Math.random();
  const shadow = `${displace}px 0px 1px rgba(0, 70, 255, 0.9), ${-displace}px 0px 1px rgba(255, 50, 0, 0.6), 0 0 3px`;
  document.body.style.textShadow = shadow;
};
setShadow();
setInterval(setShadow, 60);

// Animate scanline position relative to the viewport
const style = document.documentElement.style;
const duration = 3000;
let currentTime = Date.now();
let elapsed = 0;

function drawScanLine() {
  const newTime = Date.now();
  const delta = newTime - currentTime;
  elapsed += delta;
  if (elapsed > 2000) {
    elapsed = 0;
  }
  const Y = elapsed / 1000 * window.innerHeight;
  style.setProperty("--scanlineY", Math.floor(Y) + "px");
  currentTime = newTime;
  requestAnimationFrame(drawScanLine);
}

// drawScanLine();
