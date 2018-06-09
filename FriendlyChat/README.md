---20180513 by charles
sometimes the pod install will fail
so you need to close whole xcode project 
cd ~/Library/Developer/Xcode/DerivedData/
To delete the related file 
and delete below 3 files: "Pods"(folder) & "podfile.lock" & "XXX.xcworkspace"
then pod install again 
and rebuild!
---
# FriendlyChat

This repository contains code for the FriendlyChat project in the Firebase in a Weekend Udacity course.

## Overview

FriendlyChat is an app that allows users to send and receive text and photos in realtime across platforms.

## Setup

Setup requires creating a Firebase project. See https://firebase.google.com/ for more information.

## Maintainers

@jenperson
@jarrodparkes

## License
See [LICENSE](LICENSE)
