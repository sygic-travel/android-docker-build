FROM circleci/android:api-29-node

RUN sudo pip install --upgrade pip setuptools && \
	sudo pip --no-cache-dir install awscli

COPY markdown-it.js /sdk-build/markdown-it.js
COPY apidoc-style.css /sdk-build/apidoc-style.css
