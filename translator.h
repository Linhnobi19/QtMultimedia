#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>

class Translator : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString m_language READ getEmptylanguage NOTIFY languageChanged)
public:
    // initial function
    Translator(QGuiApplication *app, QObject *parent = nullptr);

    void setCurrentLang(QString lang);
    Q_INVOKABLE void selectLanguage(QString lang);
    QString getEmptylanguage();
    QString getCurrentLanguage();

    ~Translator();

signals:
    void languageChanged();
private:
    QString m_language;
    QGuiApplication *m_app;     // support for setup language
    QTranslator *translator;

};

#endif // TRANSLATOR_H
