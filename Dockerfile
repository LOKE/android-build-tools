FROM ubuntu:18.04

MAINTAINER LOKE

ENV ANDROID_HOME /opt/android-sdk

WORKDIR /tmp

ARG DEBIAN_FRONTEND=noninteractive

# Installing packages
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  openjdk-8-jdk \
  unzip \
  awscli \
  curl \
  git \
  ruby \
  ruby-dev && \
  rm -rf /var/lib/apt/lists/ && \
  apt-get clean

# install android sdk tools
RUN curl -L -o android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip  && \
  unzip android-sdk.zip && \
  rm -fr android-sdk.zip && \
  mkdir $ANDROID_HOME && \
  mv tools $ANDROID_HOME

# Take a look at https://github.com/bitrise-io/android/blob/master/Dockerfile for what inspiration

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

RUN touch /root/.android/repositories.cfg

RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools"

RUN yes | $ANDROID_HOME/tools/bin/sdkmanager \
  "platforms;android-30" \
  "platforms;android-29" \
  "platforms;android-28" \
  "platforms;android-27" \
  "build-tools;30.0.2" \
  "build-tools;29.0.2" \
  "build-tools;28.0.3" \
  "build-tools;27.0.3"

# Node JS for React Native
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# Ruby tools
RUN gem update --system
RUN gem install bundler

# Add android commands to PATH
ENV ANDROID_SDK_HOME $ANDROID_HOME
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/build-tools/${ANDROID_BUILD_TOOLS_VERSION}

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Support Gradle
ENV TERM dumb
ENV JAVA_OPTS "-Xms512m -Xmx1024m"
ENV GRADLE_OPTS "-XX:+UseG1GC -XX:MaxGCPauseMillis=1000"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# Android NDK Used for android c code, React Native needs it
ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK_VERSION r20

# download
RUN mkdir /opt/android-ndk-tmp && \
  cd /opt/android-ndk-tmp && \
  curl -L -o android-ndk.zip https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip && \
  # uncompress
  unzip -q android-ndk.zip && \
  # move to its final location
  mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME} && \
  # remove temp dir
  cd ${ANDROID_NDK_HOME} && \
  rm -rf /opt/android-ndk-tmp

# add to PATH
ENV PATH ${PATH}:${ANDROID_NDK_HOME}
