FROM gradle:jdk8

USER root

# Set variables
ENV ANDROID_HOME /opt/android-sdk-linux

ENV PLATFORM_VERSION 25
ENV SDK_TOOLS_VERSION 25.2.5
ENV BUILD_TOOLS_VERSION 25.0.3

# Enable sudo inside docker
RUN \
	apt-get update && \
	apt-get -y install sudo

RUN \
	echo "gradle:gradle" | chpasswd && \
	adduser gradle sudo

# Create Android SDK home folder and change it's owner
RUN \
	mkdir ${ANDROID_HOME} && \
	chown gradle:gradle ${ANDROID_HOME}

# Download and unpack Android SDK tools
WORKDIR $ANDROID_HOME
RUN \
	wget -q -O android-sdk-tools.zip https://dl.google.com/android/repository/tools_r${SDK_TOOLS_VERSION}-linux.zip && \
	unzip -q android-sdk-tools.zip && \
	rm -f android-sdk-tools.zip

# Install Android platform and build tools
RUN \
	yes | tools/bin/sdkmanager "platforms;android-${PLATFORM_VERSION}" && \
	yes | tools/bin/sdkmanager "platform-tools" && \
	yes | tools/bin/sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" && \
	yes | tools/bin/sdkmanager "tools"

# Download Amazon CLI so we can upload to S3
WORKDIR /opt
RUN \
	curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
	unzip awscli-bundle.zip && \
	./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

USER gradle

# Set PATH
ENV PATH ${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}
ENV PATH ${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/templates/gradle/wrapper:${PATH}

WORKDIR /opt/gradle
CMD ["gradle", "installDebug"]