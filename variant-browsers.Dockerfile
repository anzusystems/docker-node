# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# BROWSERS SETUP START
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------------------------------------------------------------------------------------------------------------
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
# Install Needed packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        bzip2 \
        dbus-x11 \
        fonts-liberation \
        libasound2 \
        libgbm-dev \
        libgbm1 \
        libgconf-2-4 \
        libgtk-3-0 \
        libgtk2.0-0 \
        libnotify-dev \
        libnss3 \
        libu2f-udev \
        libxkbcommon0 \
        libxss1 \
        libxtst6 \
        xauth \
        xdg-utils \
        xvfb && \
# Cleanup
    apt-get clean && \
    rm -r /var/lib/apt/lists/*
# Install Google Chrome
RUN wget -q -O /usr/src/google-chrome-stable_current_amd64.deb "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" && \
    apt-get update && \
    dpkg -i /usr/src/google-chrome-stable_current_amd64.deb ; \
    apt-get install -f -y && \
    rm -f /usr/src/google-chrome-stable_current_amd64.deb && \
# Cleanup
    apt-get clean && \
    rm -r /var/lib/apt/lists/*
# Install Firefox
RUN wget -q -O /tmp/firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2" && \
    tar -C /opt -xjf /tmp/firefox.tar.bz2 && \
    rm -f /tmp/firefox.tar.bz2 && \
    ln -fs /opt/firefox/firefox /usr/bin/firefox
# Versions of local tools
RUN echo "node version:    $(node -v) \n" \
         "npm version:     $(npm -v) \n" \
         "yarn version:    $(yarn -v) \n" \
         "debian version:  $(cat /etc/debian_version) \n" \
         "Chrome version:  $(google-chrome --version) \n" \
         "Firefox version: $(firefox --version) \n" \
         "git version:     $(git --version) \n" \
         "whoami:          $(whoami) \n"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# BROWSERS SETUP END
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
