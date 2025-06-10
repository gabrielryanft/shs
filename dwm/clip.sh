#!/bin/bash

greenclip print | grep . \
  | sed -E 's|^(image/png  )(.*)|\1/tmp/greenclip/\2.png|' \
  | dmenu -i -ip 'image/png  ' -p clipboard -l 23 -is 120 \
  | sed -E 's|^(image/png  )/tmp/greenclip/(-?[0-9]+)\.png$|\1\2|' \
  | xargs -r -d'\n' -I '{}' greenclip print '{}'

