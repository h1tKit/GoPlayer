cmake_minimum_required(VERSION 3.16)

project(GoPlayerUI VERSION 0.1 LANGUAGES CXX)

# 定义 TAGLIB_STATIC 宏，适配 TagLib 静态库
add_compile_definitions(TAGLIB_STATIC)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)


# 查找 TagLib 头文件
find_path(TAGLIB_INCLUDE_DIR
    NAMES taglib/fileref.h
    PATHS ${CMAKE_CURRENT_SOURCE_DIR}/cpp/libs/taglib/include
    NO_DEFAULT_PATH
)

# 查找 TagLib 静态库
find_library(TAGLIB_LIBRARY
    NAMES tag libtag
    PATHS ${CMAKE_CURRENT_SOURCE_DIR}/cpp/libs/taglib/lib
    NO_DEFAULT_PATH
)


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
        qml/SongListView.qml

    SOURCES
        cpp/header/songtagparser.h

        cpp/source/main.cpp
        cpp/source/songtagparser.cpp

    RESOURCES
        resource/icons/icons.qrc
        resource/images/images.qrc
        resource/musics/musics.qrc


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

# 添加头文件路径（TagLib + FFmpeg）
target_include_directories(appGoPlayerUI
    PRIVATE
        ${TAGLIB_INCLUDE_DIR}  # TagLib 头文件
)

target_link_libraries(appGoPlayerUI
    PRIVATE Qt6::Quick
    PRIVATE Qt6::QuickControls2
    ${TAGLIB_LIBRARY}
)

include(GNUInstallDirs)
install(TARGETS appGoPlayerUI
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


