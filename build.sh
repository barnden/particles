#!/bin/bash

mkdir -p ./dist/js

# TODO: Minify the files in ./dist/

make_html() {
    # Replace shader-include with <script> tags of type "text/x-fragment-shader".
    perl -ne'/<!-- shader-include: "(.*)" as "(.*)" -->/ &&\
        system("echo \"    <script type=\\\"text/x-fragment-shader\\\" id=\\\"$2\\\">\"") &&\
        system("cat ./src/shaders/$1") &&\
        system("echo \"    </script>\"") || print' ./src/index.html |

    # Replace attractor-include with corresponding shader
    perl -ne '/<!-- attractor-include as "(.*)" -->/ &&\
        system("echo \"    <script type=\\\"text/x-fragment-shader\\\" id=\\\"$1\\\">\"") &&\
        system("cat \"./src/shaders/'$1'.vs\"") &&\
        system("echo \"    </script>\n    <script>let attractor=\\\"'$1'\\\"</script>\"") || print'\
        > ./dist/$1.html
}

if [ $# -eq 0 ]; then
    # Make all attractors if argc is 0
    for file in ./src/shaders/*.vs; do
        file=${file##*/}

        if [ ${file} == "render.vs" ]; then
            continue
        fi

        make_html ${file%.*}
    done
else
    make_html ${1}
fi

cp ./src/js/*.js ./dist/js
