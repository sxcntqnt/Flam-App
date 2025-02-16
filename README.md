# Ride Sharing App

## Overview

The Ride Sharing App is an Android application that allows users to book rides in real-time, view nearby drivers on a map, and manage their profiles. The app integrates Google Maps API for location tracking and Firebase Authentication for secure user sign-up and login processes.

## Features

- **User Registration & Login:** Firebase Authentication for secure sign-in.
- **Real-Time Ride Booking:** Users can book rides instantly.
- **Map Integration:** Display nearby drivers and users' location using Google Maps API.
- **Driver Location Tracking:** Real-time tracking of driver’s location.
- **Profile Management:** Users can manage their personal profiles.
- **Ride History & Fare Calculation:** Track past rides and calculate fares.

## Technology Stack

- **Programming Language:** Java
- **IDE:** Android Studio
- **Mapping Services:** Google Maps API
- **Authentication:** Firebase Authentication
- **Database:** Firebase Firestore (optional for storing ride history and user profiles)
- **Dependency Management:** Gradle

## Project Members

This project was developed as a group effort by:

- **Joseph Mwamburi** - SB06/JR/MN/14030/2022
- **Dennis Kemboi** - SB06/JR/MN/14080/2022
- **Alex Anyega** - SB06/SR/MN/11089/2020
- **Vincent Sime** - SB06/JR/MN/14083/2022
- **Peter Mwangi Wachira** - SB06/SR/MN/11091/2020

## Prerequisites

Before starting, ensure you have the following:

- **Android Studio** installed (latest version recommended)
- **Java Development Kit (JDK)** installed
- A **Google account** for accessing Firebase and Google Maps API
- An **emulator or Android device** for testing

## Getting Started

To get a local copy of the project up and running, follow these steps:

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/ridesharing-app.git
```
### 2. Open the Project in Android Studio
Launch Android Studio.
Select "Open an existing Android Studio project".
Navigate to the cloned repository and select it.
### 3. Configure Google Maps API
- Go to the Google Cloud Console.
Create a new project or select an existing one.
Enable the Google Maps Android API.
Generate an API key:
Go to the Credentials tab.
Click Create Credentials and select API Key.
Optionally, restrict the API key:
Under Application restrictions, select Android apps.
Add your app's package name and SHA-1 fingerprint.
Add the API key to your AndroidManifest.xml:
```
<manifest ...>
    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/>
    </application>
</manifest>
```
### 4. Set Up Firebase Authentication
Go to the Firebase Console.
Create a new project or select an existing one.
In the project settings, add your Android app:
Enter your app's package name.
Download the google-services.json file and place it in the app/ directory.
Enable authentication methods in Firebase:
Navigate to Authentication and enable the preferred sign-in methods.
### 5. Add Dependencies
Open build.gradle (Module: app) and add the following dependencies:
gradle
```
dependencies {
    implementation 'com.google.firebase:firebase-auth:YOUR_VERSION'
    implementation 'com.google.firebase:firebase-firestore:YOUR_VERSION' // Optional
    implementation 'com.google.android.gms:play-services-maps:YOUR_VERSION'
    // Other dependencies...
}
```
Don’t forget to sync your Gradle files.
### 6. Build the App
Connect an Android device or start an emulator.
Click the Run button (green triangle) in Android Studio.
### 7. Testing
Create a new account using the authentication method you configured.
Test ride booking and map functionalities.
Ensure Firebase and Google Maps integrations are working correctly.
### Contributing
Contributions are welcome! To contribute:

### Fork the Project
Create a Feature Branch
```
git checkout -b feature/YourFeature
```
Commit Your Changes
```
git commit -m 'Add some YourFeature'
```
Push to the Branch
```
git push origin feature/YourFeature
```
License
This project is licensed under the MIT License. See LICENSE for more details.

### Acknowledgements
Firebase for authentication and database services
Google Maps API for mapping features
Android Development Documentation for resources
### Contact
Your Name - anyega.alex.kamau@gmail.com
Project Link: https://github.com/yourusername/ridesharing-app
