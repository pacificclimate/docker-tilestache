# Modified from:
#   https://github.com/EmileVauge/docker-tilestache

FROM ubuntu:14.04
MAINTAINER Basil Veerman <bveerman@uvic.ca>

# install Python and all the mapnik dependencies
RUN apt-get update -y \
    && apt-get install -y \
        libjpeg-dev \
        zlib1g-dev \
        python \
        python-setuptools \
        python-dev \
        python-pip \
        python-gdal \
        libboost-python-dev \
        software-properties-common \
        libmapnik2.2 \
        libmapnik-dev \
        mapnik-utils \
        python-mapnik

# symlink the native extensions so Python can pick them up
RUN ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib
RUN ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib
RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_python.so /usr/lib
RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_thread.so /usr/lib

# install tilestache, mapnik, and dependencies
RUN pip install \
    Blit \
    jinja2 \
    mapnik2 \
    Pillow \
    boto \
    redis \
    simplejson \
    sympy \
    tilestache \
    uwsgi \
    werkzeug

VOLUME ["/var/tilestache"]

WORKDIR /var/tilestache

COPY ./application.wsgi /var/tilestache/application.wsgi

EXPOSE 8080

CMD uwsgi --http :8080 --wsgi-file /var/tilestache/application.wsgi
