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

app.ports.getStoriesById.subscribe(ids => {
  ids.forEach(id => {
    api.child(`/item/${id}`).off();
    api.child(`/item/${id}`).on("value", snapshot => {
      const item = snapshot.val();
      item["type_"] = item.type;
      updateItem.send(item);
    });
  });
});

// Rgb Split with text-shadow
const setShadow = () => {
  let displace = 1.8 - Math.random();
  const shadow = `${displace}px 0px 1px rgba(0, 70, 255, 0.8), ${-displace}px 0px 1px rgba(255, 50, 0, 0.6), 0 0 3px`;
  document.body.style.textShadow = shadow;
};
setShadow();
setInterval(setShadow, 60);

