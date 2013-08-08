import QtQuick 2.0
import QtQuick.LocalStorage 2.0 as Sql

Rectangle {
    id: main
    width: 480
    height: 800
    property var shows
    property var unwatchedEpisodes
    property var isLogged
    property var request

    VisualItemModel {
        id: itemModel
        Rectangle {
            antialiasing: true
            height: 800
            width: 480
            color: "#90f076"
            Row {
                id: searchLine
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    color: "white"
                    border.color: "black"
                    border.width: 1
                    width: 200
                    height: 20
                    smooth: true
                    radius: 10
                    anchors.topMargin: 20
                    antialiasing: true
                    id: searchRect
                    TextEdit {
                        id: searchBox
                        text: qsTr("sherlock")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        width: parent.width - 20
                        height: parent.height
                        font.pixelSize: 16
                        color: "black"
                        selectByMouse: true
                    }
                }

                Rectangle {
                    color: "#ccc"
                    width: 70
                    height: 20
                    border.color: "black"
                    border.width: 1
                    radius: 10
                    antialiasing: true
                    MouseArea {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.fill: parent
                        onClicked: {
                            searchShows(searchBox.text)
                        }
                        Text {
                            id: searcher
                            font.pixelSize: 16
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Search")
                        }
                    }
                }
            }
            ListView {
                id: showView
                anchors.top: searchLine.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 0
                anchors.margins: 10
                model: shows
                spacing: 10

                delegate: Rectangle {
                    width: showView.width
                    height: 70
                    antialiasing: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'white'
                    border {
                        color: 'lightgray'
                        width: 2
                    }
                    radius: 5

                    Row {
                        anchors.margins: 5
                        anchors.fill: parent
                        spacing: 2
                        height: parent.height
                        // image
                        Rectangle {
                            height: parent.height
                            width: 80
                            Image {
                                height: parent.height
                                width: parent.width
                                fillMode: Image.PreserveAspectFit
                                source: modelData["image"]
                            }
                        }

                        Text {
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 16
                            elide: Text.ElideRight
                            renderType: Text.NativeRendering
                            text: "%1 — %2".arg(modelData['title']).arg(
                                      modelData['year'])
                        }
                    }
                }
            }
        }
        Rectangle {
            height: 800
            width: 480
            color: "skyblue"
            anchors.rightMargin: 5
            antialiasing: true

            Rectangle {
                color: "#ccc"
                width: 70
                antialiasing: true
                height: 20
                border.color: "black"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 10
                id: rldRectangle
                MouseArea {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.fill: parent
                    onClicked: {
                        getUnwatched()
                    }
                    Text {
                        id: reloadUnwatched
                        font.pixelSize: 16
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("Reload")
                    }
                }
            }

            ListView {
                id: unwatchedList
                anchors.top: rldRectangle.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 0
                anchors.margins: 40
                spacing: 10
                model: unwatchedEpisodes

                delegate: Rectangle {
                    width: showView.width
                    antialiasing: true
                    height: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: 'white'
                    border {
                        color: 'lightgray'
                        width: 2
                    }
                    radius: 5

                    Rectangle {
                        anchors.margins: 5
                        anchors.fill: parent
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                singleCheck(modelData['episodeId']);
                            }
                        Text {
                            width: parent.width
                            anchors.verticalCenter: parent.verticalCenter
                            elide: Text.ElideRight
                            renderType: Text.NativeRendering
                            text: "%1 [%2,ep. %3.%4]".arg(
                                      modelData['title']).arg(
                                      modelData['airDate']).arg(
                                      modelData['seasonNumber']).arg(
                                      modelData['episodeNumber'])
                        }
                            }
                    }
                }
            }
        }
        Rectangle {
            height: 800
            width: 480
            antialiasing: true
            color: "burlywood"
            Rectangle {
                color: "white"
                border.color: "black"
                border.width: 1
                width: 200
                height: 20
                antialiasing: true
                radius: 10
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                id: loginRect
                TextEdit {
                    id: loginBox
                    text: qsTr("")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width - 20
                    height: parent.height
                    font.pixelSize: 16
                    color: "black"
                    selectByMouse: true
                }
            }

            Rectangle {
                color: "white"
                border.color: "black"
                border.width: 1
                width: 200
                height: 20
                antialiasing: true
                radius: 10
                anchors.top: loginRect.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 20
                id: passRect
                TextEdit {
                    id: passBox
                    text: qsTr("")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    width: parent.width - 20
                    height: parent.height
                    font.pixelSize: 16
                    color: "black"
                    selectByMouse: true
                }
            }

            Rectangle {
                color: "#ccc"
                width: 70
                antialiasing: true
                height: 20
                border.color: "black"
                border.width: 1
                anchors.top: passRect.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 10
                MouseArea {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.fill: parent
                    onClicked: {
                        login(loginBox.text, passBox.text)
                    }
                    Text {
                        id: apply
                        font.pixelSize: 16
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: qsTr("Apply")
                    }
                }
            }
        }
    }

    ListView {
        highlightMoveDuration: 150
        keyNavigationWraps: true
        snapMode: ListView.SnapOneItem
        boundsBehavior: Flickable.DragOverBounds
        anchors.fill: parent
        model: itemModel
        orientation: ListView.Horizontal
    }

    Component.onCompleted: {
        isLogged = false
        request = new XMLHttpRequest()
        var db = Sql.LocalStorage.openDatabaseSync("UserDB", "1.0",
                                                   "myshows data", 1000000)
        db.transaction(function (tx) {
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS User(login TEXT, pass TEXT)')
            var rs = tx.executeSql('SELECT * FROM User')
            loginBox.text = rs.rows.item(0).login
            passBox.text = rs.rows.item(0).pass
        })
        login(loginBox.text, passBox.text)
    }

    function searchShows(name) {
        var url = "http://api.myshows.ru/shows/search/?q=" + name
        request.open('GET', url)
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText)
                    main.shows = []
                    for (var show in result) {
                        var item = result[show]
                        shows.push(item)
                    }
                    showView.model = shows
                } else {
                    console.log("HTTP:", request.status, request.statusText)
                }
            }
        }
        request.setRequestHeader('Content-Type',
                                 'application/x-www-form-urlencoded')
        request.send()
    }

    function getUnwatched() {
        request = new XMLHttpRequest()
        var url = "http://api.myshows.ru/profile/episodes/unwatched/"
        request.open('GET', url)
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    var result = JSON.parse(request.responseText)
                    unwatchedEpisodes = []
                    for (var episode in result) {
                        var item = result[episode]
                        unwatchedEpisodes.push(item)
                    }
                    unwatchedList.model = unwatchedEpisodes
                } else {
                    console.log(request.status, request.statusText)
                }
            }
        }
        request.setRequestHeader('Content-Type',
                                 'application/x-www-form-urlencoded')
        request.send()
    }

    function login(name, pass) {
        var url = "http://api.myshows.ru/profile/login?login=%1&password=%2".arg(
                    name).arg(Qt.md5(pass))
        request.open('GET', url)
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    isLogged = true
                    saveChanges()
                    getUnwatched()
                } else {
                    isLogged = false
                    console.log(request.status, request.statusText)
                }
            } else {
                isLogged = false
            }
        }
        request.setRequestHeader('Content-Type',
                                 'application/x-www-form-urlencoded')
        request.send()
    }

    function singleCheck(episodeId) {
        var url = "http://api.myshows.ru/profile/episodes/check/%1".arg(
                    episodeId)
        request.open('GET', url)
        request.onreadystatechange = function () {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status && request.status === 200) {
                    getUnwatched()
                } else {
                    console.log(request.status, request.statusText)
                }
            }
        }
        request.setRequestHeader('Content-Type',
                                 'application/x-www-form-urlencoded')
        request.send()
    }

    function saveChanges() {
        var db = Sql.LocalStorage.openDatabaseSync("UserDB", "1.0",
                                                   "myshows data", 1000000)
        db.transaction(function (tx) {
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS User(login TEXT, pass TEXT)')
            tx.executeSql('DELETE FROM User')
            tx.executeSql('INSERT INTO User VALUES(?, ?)',
                          [loginBox.text, passBox.text])
            var rs = tx.executeSql('SELECT * FROM User')
            var r = ""
            for (var i = 0; i < rs.rows.length; i++) {
                r += rs.rows.item(i).login + ", " + rs.rows.item(i).pass
            }
        })
    }
}
