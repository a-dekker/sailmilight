# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-sailmilight

DEPLOYMENT_PATH = /usr/share/$${TARGET}

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}

CONFIG += sailfishapp

SOURCES += src/sailmilight.cpp \
    src/settings.cpp

OTHER_FILES += qml/sailmilight.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingPage.qml \
    qml/pages/EffectsPage.qml \
    qml/pages/About.qml \
    qml/pages/call_milight.py \
    rpm/sailmilight.spec \
    rpm/sailmilight.changes \
    harbour-sailmilight.desktop \
    python-milight/milight/__init__.py \
    python-milight/milight/rgb.py \
    python-milight/milight/rgbw.py \
    python-milight/milight/white.py \
    python-milight/bridges.py

isEmpty(VERSION) {
    VERSION = $$system( egrep "^Version:\|^Release:" rpm/sailmilight.spec |tr -d "[A-Z][a-z]: " | tr "\\\n" "." | sed "s/\.$//g"| tr -d "[:space:]")
    message("VERSION is unset, assuming $$VERSION")
}
DEFINES += APP_VERSION=\\\"$$VERSION\\\"


python.files = python-milight/*
python.path = /usr/share/harbour-sailmilight/python-milight

icon86.files += icons/86x86/harbour-sailmilight.png
icon86.path = /usr/share/icons/hicolor/86x86/apps

icon108.files += icons/108x108/harbour-sailmilight.png
icon108.path = /usr/share/icons/hicolor/108x108/apps

icon128.files += icons/128x128/harbour-sailmilight.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

icon172.files += icons/172x172/harbour-sailmilight.png
icon172.path = /usr/share/icons/hicolor/172x172/apps

icon256.files += icons/256x256/harbour-sailmilight.png
icon256.path = /usr/share/icons/hicolor/256x256/apps

INSTALLS += icon86 icon108 icon128 icon172 icon256 python translations

TRANSLATIONS = translations/harbour-sailmilight-fr.ts \
               translations/harbour-sailmilight-nl.ts \

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n


HEADERS += \
    src/settings.h

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}
