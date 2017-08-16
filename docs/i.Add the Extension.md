
## Add the Extension

First step is always to add the extension to your development environment. 
To do this use the tutorial located [here](http://airnativeextensions.com/knowledgebase/tutorial/1).



## Required ANEs

### Core ANE

The Core ANE is required by this ANE. You must include and package this extension in your application.

The Core ANE doesn't provide any functionality in itself but provides support libraries and frameworks used by our extensions.
It also includes some centralised code for some common actions that can cause issues if they are implemented in each individual extension.

You can access this extension here: [https://github.com/distriqt/ANE-Core](https://github.com/distriqt/ANE-Core).




## Android 


### Manifest Additions

Couchbase requires the following permissions added to your manifest additions:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```


### Additional Assets

On Android you need to package a file along with your application.

This is a zip file containing some assets required by the Couchbase SDK.

Simply add `icudt53l.zip` to your AIR applications package in the root directory.

The file is available in the repository build directory:

```
build/assets/icudt53l.zip
```



## iOS

### Info Additions

If you are using a non-secure remote server you will need to set the app transport security 
appropriately in your info additions.

In order to set arbitrary loads add the following.

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

>
> This is not suggested for a release application but is useful when testing
> against a development server that may not have a secure connection.
>

