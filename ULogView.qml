import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle{
    id: xULogView
    width: app.width-app.fs
    height:parent.height
    color: app.c1
    border.width: unikSettings.borderWidth
    border.color: app.c2
    visible: false
    clip: true
    property bool notShowAgain: false
    /*Connections {
        target: unik
        onUWarningChanged: {
            txtULogView.text+=''+unik.getUWarning()+'<br /><br />';
            if(!xULogView.notShowAgain){
                xULogView.visible=true
            }
        }
    }*/
    Flickable{
        id: flickUW
        width: parent.width-app.fs
        height: parent.height-app.fs
        contentWidth: width
        contentHeight: txtULogView.contentHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: app.fs
        ScrollBar.vertical: ScrollBar {
            parent: flickUW.parent
            anchors.top: flickUW.top
            anchors.topMargin: app.fs*4
            anchors.left: flickUW.right
            anchors.bottom: flickUW.bottom
        }
        Text {
            id: txtULogView
            text: unikSettings.lang==='es'?'<b>Unik Advertencias</b><br /><br />':'<b>Unik Warnings</b><br /><br />'
            font.pixelSize: app.fs
            color: app.c2
            width: parent.width-app.fs*3
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            onTextChanged: {
                if(flickUW.contentHeight>xULogView.height-app.fs){
                    flickUW.contentY=flickUW.contentHeight-flickUW.height
                }
            }
        }
    }
    Boton{//Close
        id: btnCloseXUWarning
        w:app.fs
        h: w
        t: "\uf00d"
        d:unikSettings.lang==='es'?'Cerrar':'Close'
        b:app.c1
        c: app.c2
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.5
        anchors.top: parent.top
        anchors.topMargin: app.fs*0.5
        onClicking: {
            xULogView.visible=false
        }
    }
    Boton{//Close for ever
        id: btnCloseXUWarningNotAgain
        w:app.fs
        h: w
        t: "\uf011"
        d:unikSettings.lang==='es'?'Cerrar - No mostrar mas':'Close - Not Show Again'
        b:app.c1
        c: app.c2
        anchors.right: btnCloseXUWarning.right
        anchors.top: btnCloseXUWarning.bottom
        anchors.topMargin: app.fs*0.5
        onClicking: {
            xULogView.notShowAgain=true
            xULogView.visible=false
        }
    }
    Boton{//Clear
        id: btnCloseXUWarningClear
        w:app.fs
        h: w
        t: "\uf12d"
        d:unikSettings.lang==='es'?'Limpiar':'Clear'
        b:app.c1
        c: app.c2
        anchors.right: btnCloseXUWarningNotAgain.right
        anchors.top: btnCloseXUWarningNotAgain.bottom
        anchors.topMargin: app.fs*0.5
        onClicking: {
            txtULogView.text=unikSettings.lang==='es'?'<b>Unik Advertencias</b><br /><br />':'<b>Unik Warnings</b><br /><br />'
        }
    }
    function showLog(logData){
        txtULogView.text+=''+logData+'<br /><br />';
        if(!xULogView.notShowAgain){
            xULogView.visible=true
        }
    }
}
