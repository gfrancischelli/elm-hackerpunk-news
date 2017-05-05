import firebase from "firebase";

firebase.initializeApp({
  databaseURL: "hacker-news.firebaseio.com"
});

const api = firebase.database().ref("/v0");

export default api;
