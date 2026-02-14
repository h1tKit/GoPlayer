#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include <QResource>
#include <QDebug>
#include <QDir>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickStyle::setStyle("Fusion");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("GoPlayerUI", "Main");

    return app.exec();
}
