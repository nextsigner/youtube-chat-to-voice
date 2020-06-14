import QtQuick 2.7
import QtQuick.Layouts 1.0
Item {
    id: raiz
    property alias w: raiz.width
    property alias h: raiz.height
    property alias t: txt.text
    property alias c: txt.color
    property string b:'red'
    property alias f: txt.font.family
    property int r:6
    property alias d: tip.text
    property int tp: 0
    signal clicking
    Layout.preferredWidth:  w
    Layout.preferredHeight: h
    Rectangle{
        id: rect
        width:  raiz.width
        height: width
        color: 'transparent'
        radius: raiz.r
        anchors.centerIn: raiz
        //border.width: 1
        border.color: txt.color
        Rectangle{
            id:bg
            color: raiz.b
            anchors.fill: parent
            //border.width: 1
            border.color: txt.color
            radius: parent.radius
        }
        ParallelAnimation{
                id: an
                running: false
                NumberAnimation {
                    target: rect
                    property: "width"
                    from: rect.width*0.5
                    to: raiz.width
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
        }
    }
    MouseArea{
        id:ma
        anchors.fill: raiz
        property bool pre: false
        hoverEnabled: true
        onEntered:{if(raiz.d!==''){xTip.visible=true}}
        onExited: xTip.visible=false
        onClicked: {
            ma.pre=false
            //an.start()
            clicking()
        }
        onPressed: {ma.pre=true;tp.start()}
        onReleased: {ma.pre=false;tp.stop()}
        Timer{
            id: tp
            running: false
            repeat: false
            interval: 1500
            onTriggered: {
                    raiz.p = !raiz.p
            }
        }
    }
    Text {
        id: txt
        font.pixelSize: raiz.height*0.8
        anchors.centerIn: raiz
        font.family: "FontAwesome"
    }
    Rectangle{
        id:xTip
        width: tip.width+app.fs*0.5
        height: tip.height+app.fs*0.2
        visible:false
        //border.width: 1
        border.color: txt.color
        color: raiz.b
        radius: 6
        Text {
            id: tip
            width: contentWidth
            height: app.fs*0.5
            font.pixelSize: parent.height*0.7
            anchors.centerIn: parent
            text:"?"
            color: txt.color
        }
    }
    Component.onCompleted: {
        if(!unik.isRPI()){
            rect.border.width=1
            xTip.border.width=1
            bg.border.width=1
        }else{
            rect.border.width=0
            xTip.border.width=0
            bg.border.width=0
        }
        if(raiz.tp===0){
            xTip.rotation=0
            xTip.anchors.verticalCenter= raiz.verticalCenter
            xTip.anchors.left=raiz.right
            xTip.anchors.leftMargin=app.fs*0.1
        }
        if(raiz.tp===1){
            xTip.rotation=-180
            xTip.anchors.verticalCenter= raiz.verticalCenter
            xTip.anchors.right=raiz.left
            xTip.anchors.rightMargin=app.fs*0.1
            tip.rotation=180
        }
    }
}
