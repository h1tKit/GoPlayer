cmake_minimum_required(VERSION 3.16)

project(GoPlayerUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appGoPlayerUI
    cpp/source/main.cpp
)

qt_add_qml_module(appGoPlayerUI
    URI GoPlayerUI
    VERSION 1.0

    QML_FILES
        qml/Main.qml
        qml/FontViewer.qml
        qml/GoWindow.qml
        qml/MaxModeWindow.qml
        qml/MinModeWindow.qml
        qml/PlayingSlider.qml
        qml/SwitchButton.qml

    #RESOURCE_PREFIX "/"  # 关键：将资源前缀改为根路径
    # RESOURCES
    #     resource/icons/last.svg
    #     resource/icons/like_n.svg
    #     resource/icons/like_y.svg
    #     resource/icons/menu.svg
    #     resource/icons/pause.svg
    #     resource/icons/pause_max.svg
    #     resource/icons/play.svg
    #     resource/icons/play_max.svg
    #     resource/icons/share.svg
    #     resource/icons/volume_low.svg

    # RESOURCES
    #     resource/images/cover.png
    #     resource/images/cover2.jpg

    SOURCES
    RESOURCES resource/icons/icons.qrc
    RESOURCES resource/images/images.qrc
    QML_FILES qml/SongListView.qml
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appGoPlayerUI PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appGoPlayerUI
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGoPlayerUI
    PRIVATE Qt6::Quick
    PRIVATE Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appGoPlayerUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


