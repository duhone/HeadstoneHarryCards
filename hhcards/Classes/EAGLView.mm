//
//  EAGLView.m
//  hhcards
//
//  Created by Eric Duhon on 2/8/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "EAGLView.h"

#import "ES1Renderer.h"
#import "ES2Renderer.h"

#include "Game.h"
#include "Graphics.h"
#include "InputEngine.h"
#include "UIEngine.h"

@implementation EAGLView

@synthesize animating;
@dynamic animationFrameInterval;

using namespace CR::HHCards;
using namespace CR::Graphics;
using namespace CR::Input;
using namespace CR::UI;

GraphicsEngine *graphics_engine;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
    {		
		graphics_engine = GetGraphicsEngine();
		
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

        eaglLayer.opaque = TRUE;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
		
        /*renderer = [[ES2Renderer alloc] init];

        if (!renderer)
        {*/
            renderer = [[ES1Renderer alloc] init];

            if (!renderer)
            {
                [self release];
                return nil;
            }
        //}

        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;

        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;
		
		InputEngine::Instance().AddTouchable(&UIEngine::Instance());
		
		Game::Instance().Initialize();
    }

    return self;
}

- (void)drawView:(id)sender
{
	Game::Instance().Tick();
	
    //[renderer render];
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;

        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        if (displayLinkSupported)
        {
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.

            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];

        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }

        animating = FALSE;
    }
}

- (void)dealloc
{
	Game::Instance().TearDown();
	graphics_engine->Release();
	graphics_engine = NULL;
    [renderer release];

    [super dealloc];
}

- (void)applicationTerminated
{
	Game::Instance().ApplicationTerminated();
}

- (void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event
{
	//KeyboardManager::Instance().HideKeyboard();
	
	InputEngine::Instance().TouchesBegan(self, touches);
}

- (void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event
{
	InputEngine::Instance().TouchesMoved(self, touches);
}

- (void)touchesEnded: (NSSet *)touches withEvent:(UIEvent *)event
{
	InputEngine::Instance().TouchesEnded(self, touches);
}

- (void)touchesCancelled: (NSSet *)touches withEvent:(UIEvent *)event
{
	InputEngine::Instance().TouchesCancelled(self, touches);
}

@end
