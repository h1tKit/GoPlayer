#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <QResource>
#include <QDebug>
#include <QDir>
#include "../header/songtagparser.h"
#include "coverimageprovider.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<SongTagParser>("MyCustomModule", 1, 0, "SongTagParser");

    QQuickStyle::setStyle("Fusion");

    QQmlApplicationEngine engine;

    // 注册自定义图像提供器
    engine.addImageProvider("audioCovers", new CoverImageProvider);

    // 获取程序运行目录（exe所在目录）
    QString debugExeDir = QCoreApplication::applicationDirPath();
    engine.rootContext()->setContextProperty("DebugExeDir", debugExeDir);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("GoPlayerUI", "Main");

    return app.exec();
}
