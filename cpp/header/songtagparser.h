#include <QObject>
#include <QString>

class SongTagParser : public QObject
{
    Q_OBJECT
    // 暴露属性：READ(读方法)、WRITE(写方法)、NOTIFY(变化信号)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString album READ album WRITE setAlbum NOTIFY albumChanged)
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(int duration READ duration WRITE setDuration NOTIFY durationChanged)
    Q_PROPERTY(int bitrate READ bitrate WRITE setBitrate NOTIFY bitrateChanged)
    Q_PROPERTY(QString filetype READ filetype WRITE setFiletype NOTIFY filetypeChanged)
    Q_PROPERTY(QString filepath READ filepath WRITE setFilepath NOTIFY filepathChanged)

public:
    explicit SongTagParser(QObject *parent = nullptr);

    // 属性读方法
    QString title() const;
    QString album() const;
    QString artist() const;
    int duration() const;
    int bitrate() const;
    QString filetype() const;
    QString filepath() const;

    // 属性写方法
    void setTitle(const QString &newValue);
    void setAlbum(const QString &newValue);
    void setArtist(const QString &newValue);
    void setDuration(const int newValue);
    void setBitrate(const int newValue);
    void setFiletype(const QString &newValue);
    void setFilepath(const QString &newValue);

    // 暴露普通方法（QML可调用）
    //Q_INVOKABLE void ...();

signals:    // 信号（可向QML发送数据）
    // 属性变化信号
    void titleChanged();
    void albumChanged();
    void artistChanged();
    void durationChanged();
    void bitrateChanged();
    void filetypeChanged();
    void filepathChanged();

public slots:
    // 槽函数（QML可直接调用）
    void getInfoOf(const QString &text);

private:
    QString m_title;
    QString m_album;
    QString m_artist;
    int m_durationInSeconds = 0;
    int m_bitrate = 0;
    QString m_filetype;
    QString m_filepath;
};
