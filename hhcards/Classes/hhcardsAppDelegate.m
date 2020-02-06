//
//  hhcardsAppDelegate.m
//  hhcards
//
//  Created by Eric Duhon on 2/8/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "hhcardsAppDelegate.h"
#import "EAGLView.h"

@implementation hhcardsAppDelegate

@synthesize window;
@synthesize glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions   
{
    [glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)dealloc
{
    [window release];
    [glView release];

    [super dealloc];
}

@end
