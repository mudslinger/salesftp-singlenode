FROM node:0.12-onbuild

RUN echo "LANG=ja_JP.UTF-8" >> /etc/default/locale
RUN echo "LC_ALL=ja_JP.UTF-8" >> /etc/default/locale
ENV LANG ja_JP.UTF-8

ENV TZ Asia/Tokyo
ENV s3region ap-northeast-1
ENV ec2region ap-northeast-1
ENV eipAllocationId eipalloc-47a57222
ENV eipAddr 54.65.149.251



