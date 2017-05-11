FROM gradle:jdk8

USER root

ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

ENV PLATFORM_VERSION 25
ENV SDK_TOOLS_VERSION 25.2.5
ENV BUILD_TOOLS_VERSION 25.0.3

RUN \
	mkdir ${ANDROID_HOME} \
	&& chown gradle:gradle ${ANDROID_HOME}

RUN \
	cd ${ANDROID_HOME} \
	&& wget -O android-sdk.zip https://dl.google.com/android/repository/tools_r${SDK_TOOLS_VERSION}-linux.zip \
	&& unzip android-sdk.zip \
	&& rm -f android-sdk.zip

RUN \
	cd ${ANDROID_HOME} \
	&& yes | tools/bin/sdkmanager "platforms;android-${PLATFORM_VERSION}" \
	&& yes | tools/bin/sdkmanager "platform-tools" \
	&& yes | tools/bin/sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" \
	&& yes | tools/bin/sdkmanager "tools"

RUN \
	curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
	&& unzip awscli-bundle.zip \
	&& ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

RUN \
	gradle installDebug

USER gradle
WORKDIR /opt/workspace