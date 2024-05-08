#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "player.h"
#include "playlistmodel.h"
#include <QQmlContext>
#include <QDebug>
#include <QTranslator>
#include "translator.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Translator trans(&app);
    trans.selectLanguage("us");


    Player player;

    engine.rootContext()->setContextProperty("playlistModel", player.m_playlistModel);
    engine.rootContext()->setContextProperty("player", player.m_player);
    engine.rootContext()->setContextProperty("playlist", player.m_playlist);
    engine.rootContext()->setContextProperty("utility", &player);
    engine.rootContext()->setContextProperty("location", player.location);
    engine.rootContext()->setContextProperty("Translation", &trans);

    qDebug() << player.m_playlistModel;

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
