"use strict";

import './index.html'

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
