#!/bin/bash

lockfile="/data/lock"
if [ ! -f "$lockfile" ];then
cat <<  EOF > temp-init-db.js
use admin
use ffmpeg
db.createUser({user:"ffmpeg",pwd:"ffmpeg",roles:[{role:"readWrite",db:"ffmpeg"}]})
db.auth("ffmpeg","ffmpeg")
EOF
mongod --dbpath /data/db --fork --logpath /data/log/mongodb.log &
wait $!
mongo < temp-init-db.js
rm temp-init-db.js & \
touch $lockfile& \
fi


redis-server &
mongod -auth --bind_ip 127.0.0.1 --port 27017 --dbpath /data/db --fork --logpath /data/log/mongodb.log &
wait $!

if [ "$RUN_MODE" == "PM2" ]
then
    pm2 start /express-ffmpeg/bin/www --name app -i 0 & \
        pm2 logs app
else
    node /express-ffmpeg/bin/www
fi