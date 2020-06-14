import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.5
import QtQuick.Window 2.2
ApplicationWindow {
    id: app
    visible: false
    width: 300
    height: Screen.desktopAvailableHeight
    flags: Qt.Window | Qt.FramelessWindowHint// | Qt.WindowStaysOnTopHint
    x:Screen.width-width
    color: 'transparent'
    property string moduleName: 'ytcv'
    property int fs: app.width*0.035
    property color c1: 'black'
    property color c2: 'white'
    property color c3: 'gray'
    property color c4: 'red'
    property string uHtml: ''
    property bool voiceEnabled: true
    property string user: 'nextsigner'
    property string url: 'https://www.youtube.com/live_chat?v=NsiPUCPPS1U&is_popout=1'//'https://www.youtube.com/live_chat?v=4DVwK2iGGqQ&is_popout=1'
    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    Item{
        id: xApp
        anchors.fill: parent
        Rectangle{
            anchors.fill: parent
            WebEngineView{
                id: wv
                anchors.fill: parent
                property QtObject defaultProfile: WebEngineProfile {
                    id: wep
                    httpUserAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_2 like Mac OS X)
AppleWebKit/603.1.30 (KHTML, like Gecko) Mobile/14F89 Safari/602.1"
                    storageName: "Default"
                    persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
                    //persistentStoragePath: '.'
                    //httpCacheType: WebEngineProfile.MemoryHttpCache
                    onDownloadRequested: {
                        app.onDLR(download)
                    }
                    onDownloadFinished: {

                    }
                }
                settings.javascriptCanOpenWindows: true
                settings.allowRunningInsecureContent: false
                //settings.hyperlinkAuditingEnabled:  true
                settings.javascriptCanAccessClipboard: true
                settings.localStorageEnabled: true
                settings.javascriptEnabled: true
                onLoadProgressChanged: {
                    if(loadProgress===100)tCheck.start()
                }
            }
        }       
    }
    Timer{
        id:tCheck
        running: false
        repeat: true
        interval: 1000
        onTriggered: {         
            wv.runJavaScript('document.getElementsByTagName("yt-live-chat-text-message-renderer").length', function(result) {
                    //console.log(result)
                wv.runJavaScript('document.getElementsByTagName("yt-live-chat-text-message-renderer")['+parseInt(result-1)+'].innerHTML', function(result2) {
                    let m0=result2.split('style-scope yt-live-chat-author-chip">')
                    let m1=result2.split('</yt-live-chat-author-chip>​<span id="message" dir="auto" class="style-scope yt-live-chat-text-message-renderer">')
                    if(m0.length>1&&m1.length>1){
                        let m00=m0[1].split('<')
                        let m11=m1[1].split('<')
                        let msg=m00[0].replace(/ /g, '' )+' dice: '+m11[0]
                        if(msg!==app.uHtml){
                            if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('show')>=0){
                                app.visible=true
                            }
                            if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('hide')>=0){
                                app.visible=false
                            }
                            if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('launch')>=0){
                                Qt.openUrlExternally(app.url)
                            }
                            app.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                            app.flags = Qt.Window | Qt.FramelessWindowHint
                            unik.speak(msg)
                        }
                        app.uHtml=msg
                        //console.log('Autor: '+m0[1])
                        //console.log('Mensaje: '+m1[1])
                    }
                });
            });
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {           
            Qt.quit()
        }
    }
    Component.onCompleted: {
        if(Qt.platform.os==='linux'){
            let m0=(''+ttsLocales).split(',')
            let index=0
            for(var i=0;i<m0.length;i++){
                console.log('Language: '+m0[i])
                if((''+m0[i]).indexOf('Spanish (Spain)')>=0){
                    index=i
                    break
                }
            }
            unik.ttsLanguageSelected(index)
            //unik.speak('Idioma Español seleccionado.')
        }
        let user=''
        let launch=false
        let args = Qt.application.arguments
        //uLogView.showLog(args)
        for(var i=0;i<args.length;i++){
            //uLogView.showLog(args[i])
            if(args[i].indexOf('-youtubeUser=')>=0){
                let d0=args[i].split('-youtubeUser=')
                user=d0[1]
                app.user=user
            }
            if(args[i].indexOf('-launch')>=0){
                launch=true
            }
        }
        wv.url=app.url
        if(launch){
            Qt.openUrlExternally(app.url)
        }
        app.visible=true
    }
}
