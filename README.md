# AudioTales is a fictional audio books service that uses stories instead of traditional passwords.

Read more about the project on the **project website**: https://rithikakabilan.wixsite.com/ciu196


See an introduction video to the project here:

[![](http://img.youtube.com/vi/ufrCqc-CQk8/0.jpg)](http://www.youtube.com/watch?v=ufrCqc-CQk8 "What is AudioTales?")


### How to install and run:

Android:
For Android, there is a pre-compiled .apk file (called 'android_install_file.apk' at the root of the repo) you can download and install directly. The app will be called 'narrative_passwords' on your phone.

iOS:
On iOS you have to build the project yourself.

### Build the project yourself:
To build and run the project yourself, you need to have Flutter installed (https://flutter.dev/docs/get-started/install).
Then simply open the repo in an IDE with Flutter support (such as VS Code or Android Studio), which will recognize that it's a Flutter project and then you can run it with the built in controls. You can also run the terminal command 'flutter run' in the repo, which will give you the option to install the project on connected devices (including simulators).


### How to get the database to work
This project is build to use a Google sheets document as a database for logging events (see project website for more info).
The project will run just as normal without adding your own credentials, expect that nothing will be logged. 
You can see my Google sheet document here: https://docs.google.com/spreadsheets/d/1WaJhs3jpcphsg2IyCmfCu86ghtRcgDOuDWZ-kMuZtyA/ 
However, you cannot add events to it (unless using the .apk file). This is because using it requires some private keys, which you should never share in a public repo. 

If you want to test it yourself, follow this tutorial to get your own Google API credentials: https://medium.com/@a.marenkov/how-to-get-credentials-for-google-sheets-456b7e88c430 then replace the empty credentials in privateKey.dart (found in the **lib folder**) with your own. Here's a tutorial on how to ADD the credentials to the project after you've gotten them: https://itnext.io/dart-working-with-google-sheets-793ed322daa0. 

### I just want to look at the code, where is the code you've written for this project?
All code that is relevant to this project is found inside the **lib** folder and ends with .dart (since it's written in the Dart programming language).


 
