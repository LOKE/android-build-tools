FROM ubuntu:16.04

MAINTAINER LOKE

WORKDIR /tmp

# Installing packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-add-repository -y universe && \
    apt-add-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    autoconf \
    git \
    ca-certificates \
    curl \
    groff \
    less \
    lib32stdc++6 \
    lib32z1 \
    lib32z1-dev \
    lib32ncurses5 \
    libc6-dev \
    libgmp-dev \
    libmpc-dev \
    libmpfr-dev \
    libxslt-dev \
    libxml2-dev \
    locales \
    m4 \
    ncurses-dev \
    ocaml \
    openssh-client \
    pkg-config \
    python \
    python-pip \
    python-setuptools \
    python-software-properties \
    unzip \
    wget \
    zip \
    zlib1g-dev && \
    apt-get install -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/ && \
    apt-get clean

# ENV LANG en_US.UTF-8
# RUN locale-gen $LANG

# COPY README.md /README.md

ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_NDK  /opt/android-ndk

ARG BUILD_TOOLS_VERSION="27.0.3"
ENV ANDROID_BUILD_TOOLS_VERSION=${BUILD_TOOLS_VERSION}

RUN wget -q -O android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip  && \
    unzip android-sdk.zip && \
    rm -fr android-sdk.zip && \
    mkdir $ANDROID_HOME && \
    mv tools $ANDROID_HOME

# Install Android components
RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter android-27 && \
    echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS_VERSION}

RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter extra-android-m2repository && \
    echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter extra-google-google_play_services && \
    echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter extra-google-m2repository

RUN echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter platform-tools

RUN mkdir -p /root/.android
RUN touch /root/.android/repositories.cfg

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "extras;google;m2repository"
RUN yes | $ANDROID_HOME/tools/bin/sdkmanager "patcher;v4"

# Get the latest version from https://developer.android.com/ndk/downloads/index.html
ARG NDK_VERSION="13"
ENV ANDROID_NDK_VERSION=${NDK_VERSION}

# Install Android NDK, put it in a separate RUN to avoid travis-ci timeout in 10 minutes.
RUN wget -q -O android-ndk.zip http://dl.google.com/android/repository/android-ndk-r${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
    unzip -q android-ndk.zip && \
    rm -fr $ANDROID_NDK android-ndk.zip && \
    mv android-ndk-r${ANDROID_NDK_VERSION} $ANDROID_NDK

# AWS CLI
RUN pip --no-cache-dir install awscli && \
    rm -rf /var/cache/apk/*

# Node JS
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# Fastlane
RUN apt-get update && \
    apt-get install -y ruby-dev build-essential dh-autoreconf && \
    gem install fastlane

# Add android commands to PATH
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/build-tools/${ANDROID_BUILD_TOOLS_VERSION}:$ANDROID_NDK

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"
