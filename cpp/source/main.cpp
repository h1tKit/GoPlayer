#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include <QResource>
#include <QDebug>
#include <QDir>

// 递归遍历资源目录，打印所有文件（核心验证函数）
void printResourceFiles(const QString &resourcePath) {
    QDir dir(resourcePath);
    // 确保是资源路径（qrc:/开头）
    if (!dir.exists()) {
        qDebug() << "资源目录不存在：" << resourcePath;
        return;
    }

    // 遍历目录下的所有文件/子目录
    QFileInfoList infoList = dir.entryInfoList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QFileInfo &info : infoList) {
        if (info.isDir()) {
            // 递归遍历子目录
            printResourceFiles(info.absoluteFilePath());
        } else {
            // 打印具体的资源文件路径
            qDebug() << "已打包的资源文件：" << info.absoluteFilePath();
        }
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // ===== 验证资源是否打包（Qt6兼容版）=====
    qDebug() << "===== 开始打印所有已打包的资源 =====";
    // 场景1：未设置RESOURCE_PREFIX（默认），遍历模块资源根路径
    printResourceFiles("qrc:/qt/qml/GoPlayerUI/");
    // 场景2：设置了RESOURCE_PREFIX "/"，遍历资源根路径
    printResourceFiles("qrc:/");

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
