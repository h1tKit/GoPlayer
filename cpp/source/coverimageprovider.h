#pragma once
#include <QQuickImageProvider>
#include "coverhelper.h"

class CoverImageProvider : public QQuickImageProvider {
public:
    CoverImageProvider() : QQuickImageProvider(QQuickImageProvider::Image) {}

    QImage requestImage(const QString& id, QSize* size, const QSize& requestedSize) override {
        // 中文路径适配：QString转UTF8
        QImage coverImage = extractAudioCover(id.toUtf8().toStdString());

        // 按需缩放图片（保持比例+平滑缩放）
        if (!coverImage.isNull() && requestedSize.isValid()) {
            coverImage = coverImage.scaled(
                requestedSize,
                Qt::KeepAspectRatio,
                Qt::SmoothTransformation
                );
        }

        // 返回图片尺寸
        if (size) *size = coverImage.size();

        return coverImage;
    }
};
