#include "../header/songtagparser.h"
#include <QDebug>

#include <string>
#include <iostream>
// TagLib核心头文件
#include <taglib/fileref.h>
#include <taglib/tag.h>
#include <taglib/audioproperties.h>
// TagLib各格式的头文件
#include <taglib/mpegfile.h>    // MP3
#include <taglib/flacfile.h>    // FLAC
#include <taglib/vorbisfile.h>  // OGG/Vorbis
#include <taglib/wavfile.h>     // WAV
#include <taglib/mp4file.h>     // MP4/M4A
#include <taglib/aifffile.h>    // AIFF
// Windows中文路径适配
#ifdef _WIN32
#include "myFunctions.h"
#endif


SongTagParser::SongTagParser(QObject *parent)
    : QObject{parent}
{}

// 属性读方法
QString SongTagParser::title() const{
    return m_title;
}
QString SongTagParser::album() const{
    return m_album;
}
QString SongTagParser::artist() const{
    return m_artist;
}
int SongTagParser::duration() const{
    return m_durationInSeconds;
}
int SongTagParser::bitrate() const{
    return m_bitrate;
}
QString SongTagParser::filetype() const{
    return m_filetype;
}
QString SongTagParser::filepath() const{
    return m_filepath;
}

// 属性写方法
void SongTagParser::setTitle(const QString &newValue){
    if (m_title == newValue) return; // 避免重复触发信号
    m_title = newValue;
    emit titleChanged(); // 触发属性变化信号
}

void SongTagParser::setAlbum(const QString &newValue){
    if (m_album == newValue) return;
    m_album = newValue;
    emit albumChanged();
}

void SongTagParser::setArtist(const QString &newValue){
    if (m_artist == newValue) return;
    m_artist = newValue;
    emit artistChanged();
}

void SongTagParser::setDuration(const int newValue){
    if (m_durationInSeconds == newValue) return;
    m_durationInSeconds = newValue;
    emit durationChanged();
}

void SongTagParser::setBitrate(const int newValue){
    if (m_bitrate == newValue) return;
    m_bitrate = newValue;
    emit bitrateChanged();
}

void SongTagParser::setFiletype(const QString &newValue){
    if (m_filetype == newValue) return;
    m_filetype = newValue;
    emit filetypeChanged();
}

void SongTagParser::setFilepath(const QString &newValue){
    if (m_filepath == newValue) return;
    m_filepath = newValue;
    emit filepathChanged();
}



void SongTagParser::getInfoOf(const QString &text)
{
    qDebug() << "parsing file : " << text;
    const std::string audioPath = text.toStdString();

    // TagLib解析音频元数据
    TagLib::FileRef fileRef;
#ifdef _WIN32
    fileRef = TagLib::FileRef(utf8ToWide(audioPath).c_str());
#else
    fileRef = TagLib::FileRef(audioPath.c_str());
#endif

    if (fileRef.isNull()) {
        std::cerr << "错误：无法打开文件！路径：" << audioPath << std::endl;
        return;
    }

    // 获取各个Tag
    TagLib::Tag* tag = fileRef.tag();
    std::string title = tag->title().toCString(true);
    std::string artist = tag->artist().toCString(true);
    std::string album = tag->album().toCString(true);
    TagLib::AudioProperties* ap = fileRef.audioProperties();
    int duration = ap->lengthInSeconds();
    int bitrate = ap->bitrate();

    // 获取文件类型
    QString fileType = "未知格式";
    TagLib::File* file = fileRef.file();
    if (file) {
        if (dynamic_cast<TagLib::MPEG::File*>(file)) {
            fileType = "mp3";
        } else if (dynamic_cast<TagLib::FLAC::File*>(file)) {
            fileType = "flac";
        } else if (dynamic_cast<TagLib::Ogg::Vorbis::File*>(file)) {
            fileType = "ogg";
        } else if (dynamic_cast<TagLib::RIFF::WAV::File*>(file)) {
            fileType = "wav";
        } else if (dynamic_cast<TagLib::MP4::File*>(file)) {
            fileType = "m4a/mp4";
        }
    }

    setTitle(QString::fromStdString(title.empty() ? "未知" : title));
    setAlbum(QString::fromStdString(album.empty() ? "未知" : album));
    setArtist(QString::fromStdString(artist.empty() ? "未知" : artist));
    setDuration(duration);
    setBitrate(bitrate);
    setFiletype(fileType);
    setFilepath(text);
}
