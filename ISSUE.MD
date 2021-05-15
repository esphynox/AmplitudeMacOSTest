## Expected Behavior
I should receive events only from my application. 


## Current Behavior
I'm receiving events from all applications using Amplitude iOS SDK on this computer.
<screenshot of dashboard>

## Possible Solution

### Problem

Problem lurking inside function `platformDataDirectory` of  `AMPUtils.m` file.
Thing is following API call:
`[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];`
returns different paths when macOS app is sandboxed and not sandboxed.

When app is sandboxed returned value from this function is:
`/Users/<username>/Library/Containers/<app_bundle_identifier>/Data/Library`
but when app isn't sandboxed returned value is:
`/Users/<username>/Library`

Which leads to situation that every app is reading and writing to database located by path
`/Users/<username>/Library/com.amplitude.database`

When user have no internet, events stacking inside database from all applications and then sent to dashboard.

### Possible solutions

I'm not exactly sure what's the best solution to implement in your case, but I see two different approaches two fix this issue.

### Solution 1 - Separate DB file for each app 

You can add bundle identifier of host application to database filename so it won't collide for different apps.
I guess downside to this approach is that you might need to migrate records from old file to new which might be not an easy task.

### Solution 2 - Filter records on send

You can add bundle identifier of host application to each event that is recorded to database. Then when reading those event from database and before sending those events to your backend you can filter them by bundle identifier of host applications so you can exclude unneeded events.

This might be a more hackier approach then previous but still might work. 

## Steps to Reproduce

### Pre-requesites 

For correct observation of this issue we need two different apps and two different API keys for SDK. I prepared test application which with few modifications will correctly reproduce this issue. We will change bundle identifier of application so we can emulate two different apps using Amplitude.

### Steps

1. Pull repository with submodules from this link (https://github.com/esphynox/AmplitudeMacOSTest) 
1. Open `TestViewController.swift` file and replace `API_KEY_1` & `API_KEY_2` strings with correct API keys.
1. Disable internet connection.
1. Run application
1. Observe that event is written to `/Users/<username>/Library/com.amplitude.database`
1. Change bundle identifier of app from `com.esphynox.AmplitudeTest1` to `com.esphynox.AmplitudeTest2`.
1. Run application 
1. Observe that second event is written to `/Users/<username>/Library/com.amplitude.database`
1. Enable internet connection.
1. Go to Amplitude dashboard of application that used `API_KEY_2` and observe that there is two `Launch` events from `com.esphynox.AmplitudeTest1` and `com.esphynox.AmplitudeTest2` applications.

## Environment
- SDK Version: v8.3.0
- Device: MacBook Pro (13-inch, M1, 2020)
- OS Version: macOS 11.1 (20C69)

