FROM node:8
 
WORKDIR /

RUN git clone https://gitee.com/quazero/express-ffmpeg.git && \
	cd express-ffmpeg && \
	git checkout 54124dc7c6ec712d21e06038a87ed2e265b50557

WORKDIR /express-ffmpeg/

RUN npm install && \
	npm rebuild node-sass && \
	npm install -g pm2 && \
	wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz && \
	tar xvf ffmpeg-git-*-static.tar.xz && \
	mv ffmpeg-git-*/ffmpeg ffmpeg-git-*/ffprobe /usr/bin/ && \
	rm -rf ffmpeg-git-*-static ffmpeg-git-*-static.tar.xz && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
	echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
	apt-get update && \
	apt-get install -y mongodb-org redis-server && \
	rm -rf /var/lib/apt/lists/*
	
COPY ./docker-entrypoint.sh ./auth.js /

RUN mkdir -p /data/db -p /data/log /express-ffmpeg/config && \
	mv /auth.js /express-ffmpeg/config/ && \
	chmod +x /docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]
