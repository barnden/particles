#!/bin/bash

mkdir -p ./dist/js

# TODO: Minify the files in ./dist/

# Replace shader-include with <script> tags of type "text/x-fragment-shader".
perl -ne'/<!-- shader-include: "(.*)" as "(.*)" -->/ &&\
    system("echo \"    <script type=\\\"text/x-fragment-shader\\\" id=\\\"$2\\\">\"") &&\
    system("cat ./src/shaders/$1") &&\
    system("echo \"    </script>\"") || print' ./src/index.html > ./dist/index.html

cp ./src/js/*.js ./dist/js
