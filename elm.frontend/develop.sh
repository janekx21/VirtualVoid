#!/bin/sh
# TODO maybe add proxy
elm-live src/Main.elm --pushstate --hot --start-page src/index.html -- --debug --output=elm.js
