//
//  AppDelegate.swift
//  AccountKit_SampleApp
//
//  Created by Gabrielle Miller-Messner on 11/27/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
// : import CoreKit
import FBSDKCoreKit


// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?
    
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL,
                     sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    
    // : Activate App Events
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp() // for Events and Analytics! What?! Yep, Account Kit keeps track of login events and gives you demographic information with virtually
        /*
         On the client side:
         
         Login impressions - when the phone number and email entry is shown
         Login starts - when a phone number or email is entered and the next button is clicked
         Logins - login is completed and an access token is received
         On the server side:
         
         Login requests - requests to begin the login flow
         Notification sent - any confirmation sent by the server
         Login complete - login is completed and an access token is generated
         
         */
    }
    
    /*
     Below is Obj-C 
    //  AppDelegate.m
    #import <FBSDKCoreKit/FBSDKCoreKit.h>
    
    - (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
    didFinishLaunchingWithOptions:launchOptions];
    // Add any custom logic here.
    return YES;
    }
    
    - (BOOL)application:(UIApplication *)application
    openURL:(NSURL *)url
    options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
    openURL:url
    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
    ];
    // Add any custom logic here.
    return handled;
    }
     
     
     // Add this to the header of your file, e.g. in ViewController.m
     // after #import "ViewController.h"
     #import <FBSDKCoreKit/FBSDKCoreKit.h>
     #import <FBSDKLoginKit/FBSDKLoginKit.h>
     
     // Add this to the body
     @implementation ViewController
     
     - (void)viewDidLoad {
     [super viewDidLoad];
     FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
     // Optional: Place the button in the center of your view.
     loginButton.center = self.view.center;
     [self.view addSubview:loginButton];
     }
     
     @end
     
     
     - (void)viewDidLoad
     {
     [super viewDidLoad];
     if ([FBSDKAccessToken currentAccessToken]) {
     // User is logged in, do work such as go to next view controller.
     }
     }
     
     
     // Extend the code sample from 6a. Add Facebook Login to Your Code
     // Add to your viewDidLoad method:
     loginButton.readPermissions = @[@"public_profile", @"email"];
    */

}
