import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import QtQuick.Layouts

ApplicationWindow {
   width: 1280
   height: 720
   visible: true
   title: qsTr("Book Cipher : ") + book

   property string book: ""
   property bool bookLoaded: false
   property bool encTextChanged: false
   property var bookSplitted: []
   property var decText: []
   property var encText: []

   header: ToolBar {
       Flow {
           anchors.fill: parent
           ToolButton {
               text: qsTr("Открыть книгу")
               icon.name: "document-open"
               display: AbstractButton.TextBesideIcon
               onClicked: fileOpenDialog.open()
           }
           ToolButton {
               text: qsTr("Зашифровать")
               enabled: bookLoaded
               onClicked: {
                   encText = []
                   decText = textD.text.split(/\W+/);
                   console.log(decText)
                   decText.forEach(element => {
                                       var n = bookSplitted.indexOf(element);
                                       var x = Math.floor(n / 100);
                                       var y = n % 100;
                                       encText.push([x, y])
                                   });
                   var resultString = "";
                   encText.forEach(function(element, idx, array){
                                       resultString += '[';
                                       element.forEach(function(element2, idx2, element){
                                           if (idx2 === element.length - 1){
                                               resultString = resultString + element2
                                           }
                                           else
                                           {
                                               resultString = resultString + element2 + ','
                                           }
                                       });
                       if (idx === array.length - 1){
                           resultString += ']';
                       }
                       else
                       {
                           resultString += '] ';
                       }

                                   });
                   textE.text = resultString;
               }
           }
           ToolButton {
               text: qsTr("Расшифровать")
               enabled: bookLoaded
               onClicked: {
                   encText = [];
                   var cipherSplitted = textE.text.split(/(\s+)/).filter(function(e){return e.trim().length > 0;});
                   cipherSplitted.forEach(element => {
                                              var elSp = element.split(/[\[\],]/).filter(function(e){return e.length > 0;});
                                              encText.push([Number(elSp[0]),Number(elSp[1])]);
                                          });
                   var resultString = "";
                   encText.forEach(element => {
                                       var n = element[0] * 100 + element[1];
                                       var s;
                                       if (n < 0)
                                       {
                                           s = "_ ";
                                       }
                                       else
                                       {
                                           s = bookSplitted[n] + " ";
                                       }
                                       resultString += s;
                                   });
                   textD.text = resultString;
               }
           }
       }
   }
   RowLayout {
       id: layout
       anchors.fill: parent
       spacing: 2
       Rectangle {
           Layout.fillWidth: true
           Layout.fillHeight: true
           Layout.minimumWidth: 50
           Layout.preferredWidth: 100
           Layout.minimumHeight: 150
           ScrollView {
               id: viewD
               anchors.fill: parent
               TextArea {
                   id: textD
                   text: "Введите текст для зашифровки"
                   font.pointSize: 14
               }
           }
       }
       Rectangle {
           Layout.fillWidth: true
           Layout.fillHeight: true
           Layout.minimumWidth: 50
           Layout.preferredWidth: 100
           Layout.minimumHeight: 150
           ScrollView {
               id: viewE
               anchors.fill: parent
               TextArea {
                   id: textE
                   text: "Введите текст для дешифровки"
                   font.pointSize: 14
               }
           }
       }
   }

   FileDialog {
       id: fileOpenDialog
       title: "Выберите книгу, при помощи которой будет осуществляться шифрование"
       folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
       nameFilters: [
           "Text files (*.txt)", "All files (*)"
       ]
       onAccepted: {
           book = fileOpenDialog.currentFile
           bookLoaded = true;
           var xhr = new XMLHttpRequest;
           xhr.open("GET", book);
           xhr.onreadystatechange = function() {
               if (xhr.readyState === XMLHttpRequest.DONE) {
                   var response = xhr.responseText;
                   bookSplitted = response.split(/\W+/);
               }
           };
           xhr.send();
       }
   }
}
