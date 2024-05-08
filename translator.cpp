#include "translator.h"
#include <QDebug>

Translator::Translator(QGuiApplication *app, QObject *parent)
{
    m_app = app;
    translator = new QTranslator();
    translator->load("string_us", ":/translator");
    m_app->installTranslator(translator);
    m_language = "us";
}

void Translator::setCurrentLang(QString lang)
{
    if(m_language != lang){
        if(lang == "us"){
            translator->load("string_us", ":/translator");
        }
        else if(lang == "vn"){
            translator->load("string_vn", ":/translator");
        }
        m_app->installTranslator(translator);
        m_language = lang;
    }
    emit languageChanged();
}

void Translator::selectLanguage(QString lang)
{
    if(!(lang == "us" || lang == "vn")){
        qDebug() << "The language you choose is not available";
    }
    else{
        setCurrentLang(lang);
    }
}

QString Translator::getEmptylanguage()
{
    return "";
}

QString Translator::getCurrentLanguage()
{
    return m_language;
}

Translator::~Translator()
{

}
