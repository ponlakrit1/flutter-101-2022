# flutter_101

Simple flutter (3.0.3) project with Google firebase auth.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to Use 

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/ponlakrit1/flutter-101-2022.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
```

Here is the folder structure we have been using in this project

```
lib/
|- asset/
|- model/
|- screens/
|- service/
|- utils/
|- widgets/
|- main.dart
```
Now, lets dive into the lib folder which has the main code for the application.

```
1- asset - All the application level constants are defined in this directory with-in their respective files.
2- model - Contains store(s) for state-management of your application, to connect the reactive data of your application with the UI. 
3- screens - Contains all the ui of your project, contains sub directory for each screen.
4- service - Contains the data layer of your project, includes directories for local, network and shared pref/cache.
5- utils - Contains the utilities functions of your application.
6- widgets - Contains the common widgets for your applications. For example, Button, TextField etc.
7- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```

## Author
Ponlakrit kaewmoon
