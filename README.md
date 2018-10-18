### 镜像说明
- 使用[官方](https://gitee.com/quazero/express-ffmpeg "官方")最新的源码安装
- /data为数据库的目录
- /express-ffmpeg/movies为上传文件的目录
- /express-ffmpeg/public/videos为切片后的文件目录
- 3000为web端口，可以使用nginx/apache做域名映射

### 使用docker-compose文件部署
```
version: '2.1'

services:
 express-ffmpeg:
    image: palidin/express-ffmpeg:latest
    ports:
      - 3000:3000
    privileged: true
    volumes:
      - /data/express-ffmpeg/mongodb:/data
      - /mnt/movies:/express-ffmpeg/movies
      - /mnt/videos:/express-ffmpeg/public/videos
```
