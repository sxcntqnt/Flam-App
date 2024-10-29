# Ride Sharing App

## Overview

The Ride Sharing App is an Android application that enables users to book rides in real-time, view nearby drivers on a map, and manage their profiles. This app leverages the **Google Maps API** for mapping functionalities and **Firebase Authentication** for secure user sign-up and login processes.

## Features

- User registration and login via Firebase Authentication
- Real-time ride booking capabilities
- Map integration utilizing Google Maps API
- Driver location tracking
- User profile management
- Ride history and fare calculation

## Technology Stack

- **Programming Language**: Java
- **IDE**: Android Studio
- **Mapping Services**: Google Maps API
- **Authentication**: Firebase Authentication
- **Database**: Firebase Firestore (optional for storing ride history and user profiles)
- **Dependency Management**: Gradle

## Prerequisites

Ensure you meet the following requirements before starting:

- **Android Studio** installed (latest version recommended)
- **Java Development Kit (JDK)** installed
- A Google account for accessing Firebase and Google Maps API
- An emulator or an Android device for testing

## Getting Started

To get a local copy of the project up and running, follow these steps:

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/ridesharing-app.git
```
 <h1>Ride Sharing App - Setup Instructions</h1>

  <h2>2. Open the Project in Android Studio</h2>
    <ol>
        <li>Launch Android Studio.</li>
        <li>Select <strong>"Open an existing Android Studio project."</strong></li>
        <li>Navigate to the cloned repository and select it.</li>
    </ol>

  <h2>3. Configure Google Maps API</h2>
    <ol>
        <li>Go to the <a href="https://console.cloud.google.com/" target="_blank">Google Cloud Console</a>.</li>
        <li>Create a new project or select an existing one.</li>
        <li>Enable the Google Maps Android API for your project.</li>
        <li>Generate an API key:
            <ol>
                <li>Navigate to the <strong>"Credentials"</strong> tab.</li>
                <li>Click on <strong>"Create Credentials"</strong> and select <strong>"API Key."</strong></li>
            </ol>
        </li>
        <li>Optionally, restrict the API key:
            <ol>
                <li>Click on the created API key.</li>
                <li>Under <strong>"Application restrictions,"</strong> select <strong>"Android apps."</strong></li>
                <li>Add your app's package name and SHA-1 fingerprint.</li>
            </ol>
        </li>
        <li>Add the API key to your <code>AndroidManifest.xml</code>:
            <pre><code>&lt;manifest ...&gt;
    &lt;application ...&gt;
        &lt;meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_API_KEY_HERE"/&gt;
    &lt;/application&gt;
&lt;/manifest&gt;</code></pre>
        </li>
    </ol>

  <h2>4. Set Up Firebase Authentication</h2>
    <ol>
        <li>Go to the <a href="https://firebase.google.com/" target="_blank">Firebase Console</a>.</li>
        <li>Create a new project or select an existing one.</li>
        <li>In the project settings, add your Android app:
            <ol>
                <li>Enter your app's package name.</li>
                <li>Download the <code>google-services.json</code> file and place it in the <code>app/</code> directory of your project.</li>
            </ol>
        </li>
        <li>Enable the desired authentication methods:
            <ol>
                <li>Navigate to <strong>"Authentication"</strong> in the Firebase console.</li>
                <li>Click on the <strong>"Sign-in method"</strong> tab and enable your preferred sign-in methods.</li>
            </ol>
        </li>
    </ol>

  <h2>5. Add Dependencies</h2>
    <ol>
        <li>Open <code>build.gradle (Module: app)</code> and add the following dependencies:
            <pre><code>dependencies {
    implementation 'com.google.firebase:firebase-auth:YOUR_VERSION'
    implementation 'com.google.firebase:firebase-firestore:YOUR_VERSION' // Optional
    implementation 'com.google.android.gms:play-services-maps:YOUR_VERSION'
    // Other dependencies...
}</code></pre>
        </li>
        <li>Don’t forget to sync your Gradle files.</li>
    </ol>

   <h2>6. Build the App</h2>
    <ol>
        <li>Connect an Android device or start an emulator.</li>
        <li>Click on the Run button (green triangle) in Android Studio.</li>
    </ol>

   <h2>7. Testing</h2>
    <ol>
        <li>Create a new account using the authentication method you configured.</li>
        <li>Test ride booking and map functionalities.</li>
        <li>Ensure that Firebase and Google Maps integrations are working correctly.</li>
    </ol>

  <h2>Contributing</h2>
    <p>Contributions are what make the open-source community an incredible place to learn, inspire, and create. Any contributions you make are <strong>greatly appreciated</strong>.</p>
    <ol>
        <li>Fork the Project</li>
        <li>Create your Feature Branch (<code>git checkout -b feature/YourFeature</code>)</li>
        <li>Commit your Changes (<code>git commit -m 'Add some YourFeature'</code>)</li>
        <li>Push to the Branch (<code>git push origin feature/YourFeature</code>)</li>
        <li>Open a Pull Request</li>
    </ol>

  <h2>License</h2>
    <p>Distributed under the MIT License. See <code>LICENSE</code> for more information.</p>

  <h2>Acknowledgements</h2>
    <ul>
        <li><a href="https://firebase.google.com/" target="_blank">Firebase</a> - For authentication and database services</li>
        <li><a href="https://developers.google.com/maps/documentation/android-sdk/start" target="_blank">Google Maps API</a> - For integrating mapping features</li>
        <li><a href="https://developer.android.com/docs" target="_blank">Android Development Documentation</a> - For Android development resources</li>
    </ul>

   <h2>Contact</h2>
    <p><strong>Your Name</strong> - <a href="mailto:your.email@example.com">your.email@example.com</a></p>
    <p>Project Link: <a href="https://github.com/yourusername/ridesharing-app">https://github.com/yourusername/ridesharing-app</a></p>
