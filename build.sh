#!/bin/bash
# from https://elm-lang.org/0.19.0/optimize

[ -d "node_modules" ] || npm i
PATH="./node_modules/.bin:$PATH"
APP_FILE=app.js
MIN_FILE=app.min.js

elm make --optimize --output "$APP_FILE" ${*:-src/Main.elm}
uglifyjs "$APP_FILE" --compress "
        pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],
        pure_getters,keep_fargs=false,unsafe_comps,unsafe
    " |
    uglifyjs --mangle --output="$MIN_FILE"
