# Run Firefox in a container

FROM debian:jessie
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

# To avoid problems with Dialog and curses wizards
ENV DEBIAN_FRONTEND noninteractive

# -- Install the prerequisites
RUN sed -i.bak 's/jessie main/jessie main contrib/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -yq bzip2 libfreetype6 libfontconfig1 \
        libxrender1 libxext6 libxdamage1 libxcomposite1 libasound2 \
        libdbus-glib-1-2 libgtk2.0-0 libxt6 libcanberra-gtk-module \
        libv4l-0 \
        libpango1.0-0 \
        pulseaudio \
        fonts-droid fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists

# -- The Firefox
ENV FIREFOX_VER 45.0.1
ADD https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VER/linux-x86_64/en-US/firefox-$FIREFOX_VER.tar.bz2 /tmp/firefox.tar.bz2
RUN mkdir /opt/mozilla \
    && tar xf /tmp/firefox.tar.bz2 -C /opt/mozilla/ \
    && rm -f /tmp/firefox.tar.bz2

# -- Google Hangouts
ADD https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb /tmp/google-talkplugin_current_amd64.deb
RUN dpkg -i /tmp/google-talkplugin_current_amd64.deb \
    && rm -f /tmp/google-talkplugin_current_amd64.deb

# -- Java x64 RE plugin
# https://java.com/en/download/manual.jsp
# https://www.java.com/verify
ENV JAVA_VER 8
ENV JAVA_JRE_UVER 77
ENV JAVA_JRE_FVER 1.8.0_77
ENV JAVA_FONTS "/usr/share/fonts/truetype"
ENV _JAVA_OPTIONS "-Dawt.useSystemAAFontSettings=on \
               -Dswing.aatext=true \
               -Dsun.java2d.xrender=true \
               -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
# ENV _JAVA_AWT_WM_NONREPARENTING 1
#
# You can pick alternative Java look (swing.defaultlaf=):
#   - javax.swing.plaf.metal.MetalLookAndFeel
#   - javax.swing.plaf.nimbus.NimbusLookAndFeel
#   - com.sun.java.swing.plaf.gtk.GTKLookAndFeel
#   - com.sun.java.swing.plaf.motif.MotifLookAndFeel
ADD http://javadl.sun.com/webapps/download/AutoDL?BundleId=207221 /tmp/jre-linux-x64.tar.gz
RUN mkdir -p /opt/java/64 \
    && tar xf /tmp/jre-linux-x64.tar.gz -C /opt/java/64/ \
    && cd /opt/java/64/ \
    && ln -sv jre${JAVA_JRE_FVER} jre \
    && ln -sv /opt/java/64/jre/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins/ \
    && update-alternatives --install "/usr/bin/java" "java" "/opt/java/64/jre/bin/java" 1 \
    && update-alternatives --set java /opt/java/64/jre/bin/java \
    && update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/java/64/jre/bin/javaws" 1 \
    && update-alternatives --set javaws /opt/java/64/jre/bin/javaws \
    && rm -f /tmp/jre-linux-x64.tar.gz

# For testing the audio
# docker-compose run --rm --entrypoint /bin/bash firefox
# aplay -L
# pactl list
# arecord -D pulse -f cd | aplay -D pulse -B 10000 -
# RUN apt-get update && apt-get install -y alsa-utils
#
# WebRTC online test for Microphone, Camera, Network, Connectivity and Throughput
# https://test.webrtc.org/
# https://webaudiodemos.appspot.com/AudioRecorder/index.html

# -- Define a user under which the firefox will be running
ENV USER user
ENV UID 1000
ENV GROUPS video,audio
ENV HOME /home/$USER
RUN useradd -u $UID -m -d $HOME -s /usr/sbin/nologin $USER \
    && usermod -aG $GROUPS $USER

WORKDIR $HOME
USER $USER

ENTRYPOINT [ "/opt/mozilla/firefox/firefox" ]
