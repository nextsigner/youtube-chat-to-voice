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
        //ULogView{id: uLogView}
        //UWarnings{id: uWarnings}
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

            /*wv.runJavaScript('document.getElementById("root").innerText', function(result) {
                if(result!==app.uHtml){
                    let d0=result//.replace(/\n/g, 'XXXXX')
                    if(d0.indexOf(':')>0){
                        let d1=d0.split(':')
                        let d2=d1[d1.length-1]
                        let d3=d2.split('Enviar')
                        let mensaje = d3[0]

                        let d5=d0.split('\n\n')
                        let d6=d5[d5.length-3]
                        let d7=d0.split(':')
                        let d8=d7[d7.length-2].split('\n')
                        let usuario=''+d8[d8.length-1].replace('chat\n', '')
                        let msg=usuario+' dice '+mensaje
                        if((''+msg).indexOf('chat.whatsapp.com')<0&&(''+mensaje).indexOf('!')!==1){
                            unik.speak(msg)
                        }
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
                    }
                }
                app.uHtml=result
                //uLogView.showLog(result)
            });*/
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(uLogView.visible){
                uLogView.visible=false
                return
            }
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
            if(args[i].indexOf('-twitchUser=')>=0){
                let d0=args[i].split('-twitchUser=')
                //uLogView.showLog(d0[1])
                user=d0[1]
                app.user=user
                //app.url='https://www.twitch.tv/embed/'+user+'/chat'
                //uLogView.showLog('Channel: '+app.url)
            }
            if(args[i].indexOf('-launch')>=0){
                launch=true
            }
        }
        wv.url=app.url
        if(launch){
            Qt.openUrlExternally(app.url)
        }

        //Depurando
        app.visible=true
        //getViewersCount()
    }
}

/*<yt-live-chat-text-message-renderer class="style-scope yt-live-chat-item-list-renderer" id="CjkKGkNKLXhoS3VYZ09vQ0ZRYTNnZ29kSDRjRDZREhtDT3JMX1plVGdPb0NGVFVBSGdBZHBoUVB5UTY%3D" author-is-owner="" author-type="owner" has-inline-action-buttons="3"><!--css-build:shady--><yt-img-shadow id="author-photo" class="no-transition style-scope yt-live-chat-text-message-renderer" height="24" width="24" style="background-color: transparent; --darkreader-inline-bgcolor:transparent;" data-darkreader-inline-bgcolor="" loaded=""><!--css-build:shady--><img id="img" class="style-scope yt-img-shadow" alt="" height="24" width="24" src="https://yt3.ggpht.com/-1CuM1g3AnCM/AAAAAAAAAAI/AAAAAAAAAAA/izJulppvJV8/s32-c-k-no-mo-rj-c0xffffff/photo.jpg"></yt-img-shadow><div id="content" class="style-scope yt-live-chat-text-message-renderer"><span id="timestamp" class="style-scope yt-live-chat-text-message-renderer">10:45 PM</span><yt-live-chat-author-chip class="style-scope yt-live-chat-text-message-renderer" is-highlighted=""><!--css-build:shady--><span id="author-name" dir="auto" class="owner style-scope yt-live-chat-author-chip">next signer<span id="chip-badges" class="style-scope yt-live-chat-author-chip"></span></span><span id="chat-badges" class="style-scope yt-live-chat-author-chip"></span></yt-live-chat-author-chip>​<span id="message" dir="auto" class="style-scope yt-live-chat-text-message-renderer">prueba 7</span><span id="deleted-state" class="style-scope yt-live-chat-text-message-renderer"></span><a id="show-original" href="#" class="style-scope yt-live-chat-text-message-renderer"></a></div><div id="menu" class="style-scope yt-live-chat-text-message-renderer"><yt-icon-button id="menu-button" class="style-scope yt-live-chat-text-message-renderer"><!--css-build:shady--><button id="button" class="style-scope yt-icon-button" aria-label="Acciones del comentario"><yt-icon icon="more_vert" class="style-scope yt-live-chat-text-message-renderer"><svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" class="style-scope yt-icon" style="pointer-events: none; display: block; width: 100%; height: 100%;"><g class="style-scope yt-icon">
        <path d="M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z" class="style-scope yt-icon"></path>
      </g></svg><!--css-build:shady-->


  </yt-icon></button></yt-icon-button></div><div id="inline-action-button-container" class="style-scope yt-live-chat-text-message-renderer" aria-hidden="true"><div id="inline-action-buttons" class="style-scope yt-live-chat-text-message-renderer"><yt-button-renderer class="style-scope yt-live-chat-text-message-renderer style-default size-default" is-icon-button="" has-no-text=""><a class="yt-simple-endpoint style-scope yt-button-renderer" tabindex="-1"><yt-icon-button id="button" class="style-scope yt-button-renderer style-default size-default"><!--css-build:shady--><button id="button" class="style-scope yt-icon-button" aria-label="Borrar"><yt-icon class="style-scope yt-button-renderer"><svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" class="style-scope yt-icon" style="pointer-events: none; display: block; width: 100%; height: 100%;"><g class="style-scope yt-icon">
        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z" class="style-scope yt-icon"></path>
      </g></svg><!--css-build:shady-->


  </yt-icon></button></yt-icon-button></a></yt-button-renderer><yt-button-renderer class="style-scope yt-live-chat-text-message-renderer style-default size-default" is-icon-button="" has-no-text=""><a class="yt-simple-endpoint style-scope yt-button-renderer" tabindex="-1"><yt-icon-button id="button" class="style-scope yt-button-renderer style-default size-default"><!--css-build:shady--><button id="button" class="style-scope yt-icon-button" aria-label="Silenciar temporalmente al usuario"><yt-icon class="style-scope yt-button-renderer"><svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" class="style-scope yt-icon" style="pointer-events: none; display: block; width: 100%; height: 100%;"><g class="style-scope yt-icon">
        <path d="M6 2v6h.01L6 8.01 10 12l-4 4 .01.01H6V22h12v-5.99h-.01L18 16l-4-4 4-3.99-.01-.01H18V2H6z" class="style-scope yt-icon"></path>
      </g></svg><!--css-build:shady-->


  </yt-icon></button></yt-icon-button></a></yt-button-renderer><yt-button-renderer class="style-scope yt-live-chat-text-message-renderer style-default size-default" is-icon-button="" has-no-text=""><a class="yt-simple-endpoint style-scope yt-button-renderer" tabindex="-1"><yt-icon-button id="button" class="style-scope yt-button-renderer style-default size-default"><!--css-build:shady--><button id="button" class="style-scope yt-icon-button" aria-label="Ocultar al usuario en este canal"><yt-icon class="style-scope yt-button-renderer"><svg viewBox="0 0 24 24" preserveAspectRatio="xMidYMid meet" focusable="false" class="style-scope yt-icon" style="pointer-events: none; display: block; width: 100%; height: 100%;"><g class="style-scope yt-icon">
        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11H7v-2h10v2z" class="style-scope yt-icon"></path>
      </g></svg><!--css-build:shady-->


  </yt-icon></button></yt-icon-button></a></yt-button-renderer></div></div></yt-live-chat-text-message-renderer>
*/

