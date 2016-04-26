FROM ubuntu:xenial
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

# To avoid problems with Dialog and curses wizards
ENV DEBIAN_FRONTEND noninteractive

# Keep the image updated and install the dependencies
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -fy install && \
    apt-get -y install bzip2 libgtk-3-0 libdbus-glib-1-2 libxt6 \
                       libasound2 libgtk2.0-0 libpango1.0-0 libv4l-0 \
                       pulseaudio && \
    rm -rf /var/lib/apt/lists

# Obtain the Mozilla Firefox
# Deps: bzip2 libgtk-3-0 libdbus-glib-1-2 libxt6
ENV FIREFOX_VER 46.0
ADD https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VER/linux-x86_64/en-US/firefox-$FIREFOX_VER.tar.bz2 /tmp/firefox.tar.bz2
RUN mkdir /opt/mozilla && \
    tar xf /tmp/firefox.tar.bz2 -C /opt/mozilla/ && \
    rm -f /tmp/firefox.tar.bz2

# Google Hangouts
# Deps: libasound2 libgtk2.0-0 libpango1.0-0 libv4l-0
ADD https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb /tmp/google-talkplugin_current_amd64.deb
RUN dpkg -i /tmp/google-talkplugin_current_amd64.deb && \
    rm -f /tmp/google-talkplugin_current_amd64.deb

# Java x64 RE plugin
# https://java.com/en/download/manual.jsp
# https://www.java.com/verify
ENV JAVA_VER 8
ENV JAVA_JRE_UVER 91
ENV JAVA_JRE_FVER 1.8.0_91
ENV JAVA_BUNDLE_ID 207765
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
ADD http://javadl.sun.com/webapps/download/AutoDL?BundleId=$JAVA_BUNDLE_ID /tmp/jre-linux-x64.tar.gz
RUN mkdir -p /opt/java/64 && \
    tar xf /tmp/jre-linux-x64.tar.gz -C /opt/java/64/ && \
    cd /opt/java/64/ && \
    ln -sv jre${JAVA_JRE_FVER} jre && \
    ln -sv /opt/java/64/jre/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins/ && \
    update-alternatives --install "/usr/bin/java" "java" "/opt/java/64/jre/bin/java" 1 && \
    update-alternatives --set java /opt/java/64/jre/bin/java && \
    update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/java/64/jre/bin/javaws" 1 && \
    update-alternatives --set javaws /opt/java/64/jre/bin/javaws && \
    rm -f /tmp/jre-linux-x64.tar.gz

# Workaround: pulseaudio client library likes to remove /dev/shm/pulse-shm-*
#             files created by the host, causing sound to stop working.
#             To fix this, we either want to disable the shm or mount /dev/shm
#             in read-only mode when starting the container.
RUN echo "enable-shm = no" >> /etc/pulse/client.conf

# Define a user under which the Firefox will be running
ENV USER user
ENV UID 1000
ENV GROUPS video,audio
ENV HOME /home/$USER
RUN useradd -u $UID -m -d $HOME -s /usr/sbin/nologin $USER && \
    usermod -aG $GROUPS $USER

WORKDIR $HOME
USER $USER

VOLUME [ "/tmp" ]
ENTRYPOINT [ "/opt/mozilla/firefox/firefox" ]
