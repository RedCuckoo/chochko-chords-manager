QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets webengine webenginewidgets

CONFIG += c++17

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    AddPlaylistDialog.cpp \
    HTMLParser.cpp \
    MainWindow.cpp \
    MainWindow.cpp \
    main.cpp

HEADERS += \
    AddPlaylistDialog.h \
    HTMLParser.h \
    MainWindow.h \
    MainWindow.h

FORMS += \
    AddPlaylistDialog.ui \
    MainWindow.ui

TRANSLATIONS += \
    chochko-chords-manager-qmake_uk_UA.ts

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    resource_file.qrc

RC_ICONS = icon.ico