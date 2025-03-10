import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtWebEngine 1.2
import QtWebChannel 1.0

import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Styles 2.2
import QtQuick.VirtualKeyboard.Settings 2.2

import MyClassType 1.0

// WebGL：http://get.webgl.org
// F:/qt/qt_program/untitled1qml/resource/index.html
// Padhtml：/usr/share/web/pad/build/index.html
// Padhtml：/home/pi/web/pad/build/index.html
// Padhtml：/home/pi/fluidd-pad/index.html
// klipperhtml：http://127.0.0.1
// right，Klipperbottom

Item {
    id: window
    visible: true
    property int device: 2
    property int viewWidth: 1024
    property int viewHeight: 600
    property string direction: "top"

    function getRotation() {
        if (direction === "top") {
            return 0;
        } else if (direction === 'bottom') {
            return 180;
        } else if (direction === 'left') {
            return -90;
        } else if (direction === 'right') {
            return 90;
        }
    }

    width: viewWidth
    height: viewHeight
    rotation: getRotation()

//    Image {
//        id: screensaver
//        anchors.fill: parent
//        source: "/home/pi/fluidd/horizontal.png"
//    }

    MyClass {
        id: myobj;
        WebChannel.id: "qtObject"
    }

    WebChannel{
        id: webChannel
        registeredObjects: [myobj]
    }

    WebEngineView {
        id: webview
        visible: false
        function getWebPath() {
            if (device === 0) {
                return "F:/qt/qt_program/untitled1qml/resource/index.html"
            } else if (device === 1) {
                //return "/usr/share/web/pad/build/index.html"
				return "/home/pi/web/pad/build/index.html"
            } else if (device === 2) {
                //return "/usr/share/fluidd-pad/index.html"
				return "/home/pi/fluidd-pad/index.html"
            }
        }
        function getOffset(axis) {
            if (direction === 'top' || direction === 'bottom') {
                return 0;
            } else if (direction === 'left' || direction === 'right') {
                var offsetX = (viewWidth-viewHeight)/2;
                return axis === "x" ? offsetX : -offsetX;
            }
        }
        url: getWebPath()
        width: direction === "top" || direction === "bottom" ? viewWidth : viewHeight
        height: direction === "top" || direction === "bottom" ? viewHeight : viewWidth
        x: getOffset("x")
        y: getOffset("y")
        onNewViewRequested: request.openIn(webview)
        webChannel: webChannel
    }

    /*
        Keyboard input panel.
        The keyboard is anchored to the bottom of the application.
    */
    InputPanel {
        id: keyboard
        function getKeyboardX(type){
            if(direction === "top" || direction === "bottom") {
                return 0
            } else if(direction === "left" || direction === "right"){
                return (viewWidth-viewHeight)/2
            }
        }
        function getKeyboardY(type){
            if(direction === "top" || direction === "bottom") {
                return type === 0 ? viewHeight : viewHeight-keyboard.height
            } else if(direction === "left" || direction === "right") {
                const offset = viewWidth - 210;
                return type === 0 ? offset : offset-keyboard.height
            }
        }
        x: getKeyboardX(0)
        y: getKeyboardY(0)
        width: direction === "top" || direction === "bottom" ? viewWidth : viewHeight
        states: State {
            /*  The visibility of the InputPanel can be bound to the Qt.inputMethod.visible property,
                but then the handwriting input panel and the keyboard input panel can be visible
                at the same time. Here the visibility is bound to InputPanel.active property instead,
                which allows the handwriting panel to control the visibility when necessary.
            */
            name: "visible"
            when: keyboard.active
            PropertyChanges {
                target: keyboard
                x: getKeyboardX(1)
                y: getKeyboardY(1)
            }
        }
        transitions: Transition {
            id: keyboardTransition
            from: ""
            to: "visible"
            reversible: true
            enabled: !VirtualKeyboardSettings.fullScreenMode
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 500
                    easing.type: Easing.InOutQuint
                }
            }
        }
    }

    Connections {
        target: myobj;
        onQmlMsgEvent: {
            var resultdata = null
            if (json.method === "changeDirection") {
                var reverselist = {
                    top: "bottom", bottom: "top",
                    left: "right", right: "left",
                }
                var nextlist = {
                    top: "right", bottom: "left",
                    left: "top", right: "bottom",
                }
                if (json.dir) {
                    direction = json.dir === "reverse" ? reverselist[direction] : json.dir;
                } else {
                    direction = nextlist[direction];
                }
                resultdata = {"dir": direction};
                myobj.settingConfig("screen_direction", direction);
                myobj.flipScreen()
            } else if (json.method === "getKeybordSize") {
                resultdata = {
                    width: keyboard.width,
                    height: keyboard.height
                }
            } else if (json.method === "reboot") {
                myrepeater.itemAt(0).delay(100, myobj.reboot);
            }
            myobj.webMsgEvent({
                method: json.method,
                data: resultdata
            })
        }
    }

    Repeater{
        id:myrepeater
        model:2
        Item {
            Timer {id: timer}
            function delay(delayTime, cb) {
               timer.interval = delayTime;
               timer.repeat = false;
               timer.triggered.connect(cb);
               timer.start();
            }
        }
    }

    Connections {
        target: webview
        onContextMenuRequested: {
            request.accepted = true;
        }
        onLoadingChanged: {
            var defaultDir = ["top", "right", "top"];
            direction = myobj.getValueFromConfig("screen_direction") || defaultDir[device];
            var dir = direction == "top" || direction == "bottom";
            VirtualKeyboardSettings.styleName = dir ? "default_landscape" : "default_portrait";
            var status = [
                "Page is currently loading.",
                "Loading the page was stopped by the stop() method or by the loader code or network stack in Chromium.",
                "Page has been loaded with success.",
                "Page could not be loaded."
            ];
            if (loadRequest.status === 2) {
                webview.visible = true;
            }
            myobj.recordLogs("qml::"+status[loadRequest.status]);
        }
        onRenderProcessTerminated: {
            var statuslist = [
                "The render process terminated normally.",
                "The render process terminated with with a non-zero exit status.",
                "The render process crashed, for example because of a segmentation fault.",
                "The render process was killed, for example by SIGKILL or task manager kill."
            ];
            if (terminationStatus !== 0) {
                myobj.recordLogs("qml::Error: " + statuslist[terminationStatus] + "ExitCode is " + exitCode + ", Now restart the application...")
                myrepeater.itemAt(0).delay(100, myobj.reboot);
            }
        }
    }
}
