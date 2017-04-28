FROM gradle:jdk8

USER root
ENV ANDROID_HOME /opt/android-sdk
RUN mkdir ${ANDROID_HOME} && chown gradle:gradle ${ANDROID_HOME}

ENV SDK_VERSION 26.0.1
ENV TOOLS_VERSION 25.2.5
ENV PLATFORM_VERSION 25

RUN \
	cd ${ANDROID_HOME} && wget -O android-sdk.zip https://dl.google.com/android/repository/tools_r${TOOLS_VERSION}-linux.zip \
	&& unzip android-sdk.zip \
	&& rm -f android-sdk.zip

RUN \
	cd ${ANDROID_HOME} \
	&& yes | tools/bin/sdkmanager "tools" "platforms;android-15" "platforms;android-${PLATFORM_VERSION}"

RUN \
	curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
	&& unzip awscli-bundle.zip \
	&& ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

USER gradle
ENV ANDROID_HOME /opt/android-sdk
ENV PATH ${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

WORKDIR /opt/workspace
CMD ["gradle", "installDebug"]
