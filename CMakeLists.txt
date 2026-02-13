cmake_minimum_required(VERSION 3.16)

project(GoPlayerUI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appGoPlayerUI
    main.cpp
)

qt_add_qml_module(appGoPlayerUI
    URI GoPlayerUI
    QML_FILES
        Main.qml
        QML_FILES GoWindow.qml
        SOURCES
        QML_FILES
        RESOURCES UIdesign/cover.png
        QML_FILES FontViewer.qml
        RESOURCES
        RESOURCES icons/like_n.svg
        icons/share.svg
        RESOURCES icons/last.svg
        RESOURCES icons/pause.svg icons/play.svg
        RESOURCES icons/last.svg icons/like_n.svg icons/like_y.svg icons/pause.svg icons/play.svg icons/share.svg
        QML_FILES SwitchButton.qml
        QML_FILES PlayingSlider.qml
        RESOURCES UIdesign/cover2.jpg
        RESOURCES icons/menu.svg
        QML_FILES MaxModeWindow.qml
        QML_FILES MinModeWindow.qml
        RESOURCES icons/volume_low.svg
        RESOURCES icons/pause_max.svg icons/volume_low.svg
        RESOURCES icons/pause_max.svg icons/play_max.svg
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


