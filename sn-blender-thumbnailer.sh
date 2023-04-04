#!/bin/bash
#dependency: fzf, xargs, parallel

bl=$(find ~/blender/* -name 'blender-thumbnailer'| head -1)
blr=$(find ~/blender/* -name 'blender'| head -1)
path=~/data/
wcf=$(find "$path" -name "*.blend" | wc -l )

conv_xargs(){
find "$path" -name "*.blend" | cut -d '.' -f1 | xargs -i "$bl" {}.blend {}.thum.png
}
conv_parallel(){
find "$path" -name "*.blend" | parallel "$bl" {} {.}.thum.png
}
render_ht(){
find "$path" -name "*.blend" | cut -d '.' -f1 | xargs -i "$blr" -b {}.blend -o //frame_##### --scene "Scene.003" -F EXR -f -1
}
dell_thum(){
find "$path" -name "*.thum.png" -delete
}
run=$(echo -e "conv_xargs\nconv_parallel\nrender_ht\ndell_thum" | fzf)
$run
echo $wcf thumbnails
exit
