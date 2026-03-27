FROM alpine:latest AS downloader
RUN apk add --no-cache wget xz
RUN wget -O /tmp/ffmpeg.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz && \
    tar xf /tmp/ffmpeg.tar.xz -C /tmp && \
    mv /tmp/ffmpeg-*-static/ffmpeg /usr/local/bin/ffmpeg && \
    mv /tmp/ffmpeg-*-static/ffprobe /usr/local/bin/ffprobe

FROM n8nio/n8n:latest
USER root
COPY --from=downloader /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=downloader /usr/local/bin/ffprobe /usr/local/bin/ffprobe
RUN chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe
RUN mkdir -p /data/ffmpeg && chown node:node /data/ffmpeg
USER node
