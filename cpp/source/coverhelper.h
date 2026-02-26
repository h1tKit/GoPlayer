#pragma once
#include <QImage>
#include <QByteArray>
#include <string>
#include <QString>
#include <QFileInfo>
#include <QDebug>

// 跨平台路径适配（Windows宽字符）
#ifdef _WIN32
#include "../source/myFunctions.h"
#endif

// TagLib完整头文件（新增WAV/OGG支持）
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
#include <taglib/attachedpictureframe.h>
#include <taglib/flacfile.h>
#include <taglib/mp4file.h>
#include <taglib/wavfile.h>         // WAV
#include <taglib/vorbisfile.h>      // OGG
#include <taglib/xiphcomment.h>     // OGG/Vorbis注释
#include <taglib/flacpicture.h>     // FLAC Picture解析
#include <taglib/fileref.h>         // 格式自动检测

// Base64解码FLAC METADATA_BLOCK_PICTURE（核心新增）
inline QImage decodeFlacMetadataBlockPicture(const TagLib::String& base64Str) {
    if (base64Str.isEmpty()) return QImage();

    // Base64解码
    TagLib::ByteVector data = TagLib::ByteVector::fromBase64(base64Str.toCString());
    if (data.isEmpty()) return QImage();

    // 解析FLAC Picture格式
    TagLib::FLAC::Picture pic;
    if (!pic.parse(data)) return QImage();

    // 转换为QImage
    QByteArray imageData(pic.data().data(), pic.data().size());
    QImage image;
    if (image.loadFromData(imageData, pic.mimeType().toCString())) {
        return image;
    }
    return QImage();
}

// WAV封面解析（新增）
inline QImage parseWavCover(const QString& qFilePath) {
#ifdef _WIN32
    std::wstring widePath = utf8ToWide(qFilePath.toUtf8().toStdString());
    TagLib::RIFF::WAV::File file(widePath.c_str());
#else
    TagLib::RIFF::WAV::File file(qFilePath.toUtf8().constData());
#endif

    if (!file.isValid()) return QImage();

    // WAV封面存储在ID3v2标签的APIC帧
    TagLib::ID3v2::Tag* tag = file.ID3v2Tag();
    if (!tag) return QImage();

    TagLib::ID3v2::FrameList apicFrames = tag->frameList("APIC");
    if (apicFrames.isEmpty()) return QImage();

    TagLib::ID3v2::AttachedPictureFrame* coverFrame =
        dynamic_cast<TagLib::ID3v2::AttachedPictureFrame*>(apicFrames.front());
    if (!coverFrame) return QImage();

    QByteArray imageData(coverFrame->picture().data(), coverFrame->picture().size());
    QImage image;
    if (image.loadFromData(imageData, coverFrame->mimeType().toCString())) {
        return image;
    }
    return QImage();
}

// OGG封面解析（新增）
inline QImage parseOggCover(const QString& qFilePath) {
#ifdef _WIN32
    std::wstring widePath = utf8ToWide(qFilePath.toUtf8().toStdString());
    TagLib::Ogg::Vorbis::File file(widePath.c_str());
#else
    TagLib::Ogg::Vorbis::File file(qFilePath.toUtf8().constData());
#endif

    if (!file.isValid()) return QImage();

    // OGG封面存储在XiphComment的METADATA_BLOCK_PICTURE字段
    TagLib::Ogg::XiphComment* comment = file.tag();
    if (!comment) return QImage();

    TagLib::Ogg::FieldListMap fieldMap = comment->fieldListMap();
    // 兼容多种封面字段名
    const char* coverKeys[] = {"METADATA_BLOCK_PICTURE", "COVERART", "COVER_ART", nullptr};
    for (int i = 0; coverKeys[i] != nullptr; i++) {
        std::string key = coverKeys[i];
        if (fieldMap.find(key) != fieldMap.end() && !fieldMap[key].isEmpty()) {
            QImage image = decodeFlacMetadataBlockPicture(fieldMap[key].front());
            if (!image.isNull()) {
                return image;
            }
        }
    }
    return QImage();
}

// 格式自动检测（核心新增）
inline QString detectFileFormat(const QString& qFilePath) {
    TagLib::FileRef fileRef;
#ifdef _WIN32
    std::wstring widePath = utf8ToWide(qFilePath.toUtf8().toStdString());
    fileRef = TagLib::FileRef(widePath.c_str());
#else
    fileRef = TagLib::FileRef(qFilePath.toUtf8().constData());
#endif

    if (fileRef.isNull()) return "unknown";

    TagLib::File* file = fileRef.file();
    if (dynamic_cast<TagLib::MPEG::File*>(file)) return "mp3";
    if (dynamic_cast<TagLib::FLAC::File*>(file)) return "flac";
    if (dynamic_cast<TagLib::Ogg::Vorbis::File*>(file)) return "ogg";
    if (dynamic_cast<TagLib::RIFF::WAV::File*>(file)) return "wav";
    if (dynamic_cast<TagLib::MP4::File*>(file)) return "mp4";

    return "unknown";
}

// 主解析函数（完整重构）
QImage extractAudioCover(const std::string& audioFilePath) {
    // 路径预处理+存在性校验
    QString qFilePath = QString::fromStdString(audioFilePath);
    QFileInfo fileInfo(qFilePath);
    if (!fileInfo.exists()) {
        qWarning() << "文件不存在：" << qFilePath;
        return QImage();
    }

    // 1. 格式自动检测（替代扩展名判断）
    QString format = detectFileFormat(qFilePath);
    qDebug() << "自动检测格式：" << format;

    try {
        // 2. MP3解析（保留）
        if (format == "mp3") {
#ifdef _WIN32
            std::wstring widePath = utf8ToWide(audioFilePath);
            TagLib::MPEG::File file(widePath.c_str());
#else
            TagLib::MPEG::File file(audioFilePath.c_str());
#endif
            if (!file.isValid()) return QImage();

            TagLib::ID3v2::Tag* tag = file.ID3v2Tag();
            if (!tag) return QImage();

            TagLib::ID3v2::FrameList apicFrames = tag->frameList("APIC");
            if (apicFrames.isEmpty()) return QImage();

            TagLib::ID3v2::AttachedPictureFrame* coverFrame =
                dynamic_cast<TagLib::ID3v2::AttachedPictureFrame*>(apicFrames.front());
            if (!coverFrame) return QImage();

            QByteArray imageData(coverFrame->picture().data(), coverFrame->picture().size());
            QImage image;
            if (image.loadFromData(imageData, coverFrame->mimeType().toCString())) {
                return image;
            }
        }

        // 3. FLAC解析（新增METADATA_BLOCK_PICTURE支持）
        else if (format == "flac") {
#ifdef _WIN32
            std::wstring widePath = utf8ToWide(audioFilePath);
            TagLib::FLAC::File file(widePath.c_str());
#else
            TagLib::FLAC::File file(audioFilePath.c_str());
#endif
            if (!file.isValid()) return QImage();

            // 优先读取内置pictureList
            if (!file.pictureList().isEmpty()) {
                const TagLib::FLAC::Picture* picture = file.pictureList()[0];
                QByteArray imageData(picture->data().data(), picture->data().size());
                QImage image;
                if (image.loadFromData(imageData, picture->mimeType().toCString())) {
                    return image;
                }
            }

            // 解析METADATA_BLOCK_PICTURE（核心新增）
            TagLib::Ogg::XiphComment* comment = file.xiphComment();
            if (comment) {
                TagLib::Ogg::FieldListMap fieldMap = comment->fieldListMap();
                if (fieldMap.find("METADATA_BLOCK_PICTURE") != fieldMap.end() &&
                    !fieldMap["METADATA_BLOCK_PICTURE"].isEmpty()) {
                    QImage image = decodeFlacMetadataBlockPicture(
                        fieldMap["METADATA_BLOCK_PICTURE"].front()
                        );
                    if (!image.isNull()) {
                        return image;
                    }
                }
            }
        }

        // 4. MP4/M4A解析（保留）
        else if (format == "mp4") {
#ifdef _WIN32
            std::wstring widePath = utf8ToWide(audioFilePath);
            TagLib::MP4::File file(widePath.c_str());
#else
            TagLib::MP4::File file(audioFilePath.c_str());
#endif
            if (!file.isValid()) return QImage();

            TagLib::MP4::Tag* tag = file.tag();
            if (!tag) return QImage();

            if (tag->contains("covr")) {
                TagLib::MP4::Item coverItem = tag->item("covr");
                TagLib::MP4::CoverArtList coverList = coverItem.toCoverArtList();

                if (!coverList.isEmpty()) {
                    TagLib::MP4::CoverArt cover = coverList[0];
                    QByteArray imageData(cover.data().data(), cover.data().size());
                    QImage image;
                    bool success = image.loadFromData(
                        imageData,
                        cover.format() == TagLib::MP4::CoverArt::JPEG ? "JPG" : "PNG"
                        );
                    if (success) return image;
                }
            }
        }

        // 5. WAV解析（新增）
        else if (format == "wav") {
            QImage image = parseWavCover(qFilePath);
            if (!image.isNull()) return image;
        }

        // 6. OGG解析（新增）
        else if (format == "ogg") {
            QImage image = parseOggCover(qFilePath);
            if (!image.isNull()) return image;
        }

        // 其他格式
        return QImage();
    }
    catch (...) {
        qWarning() << "解析封面时发生异常：" << qFilePath;
        return QImage();
    }
}
