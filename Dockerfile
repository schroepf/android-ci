FROM openjdk:8-jdk

MAINTAINER Tobias Schröpf <schroepf@gmail.com>

ARG ANDROID_USER="android"
ARG ANDROID_USER_HOME="/home/${ANDROID_USER}"

ARG ANDROID_COMPILE_SDK="28"
ARG ANDROID_SDK_TOOLS="4333796"
ARG ANDROID_BUILD_TOOLS="28.0.3"
ARG ANDROID_SDK_DIR="${ANDROID_USER_HOME}/android-sdk"

ENV ANDROID_HOME="${ANDROID_SDK_DIR}"
ENV PATH="${ANDROID_HOME}/emulator:${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 libqt5widgets5

RUN useradd -ms /bin/bash ${ANDROID_USER}
USER ${ANDROID_USER}
WORKDIR ${ANDROID_USER_HOME}

RUN wget --quiet https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN unzip -q sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip -d ${ANDROID_SDK_DIR}

ADD packages.txt ${ANDROID_USER_HOME}

RUN yes | sdkmanager --licenses
RUN sdkmanager `cat ~/packages.txt | paste -s -d " "`

RUN avdmanager create avd -n pixel_xl -k "system-images;android-25;google_apis;armeabi-v7a" --device "pixel_xl" --tag "google_apis"

CMD /bin/bash -l
