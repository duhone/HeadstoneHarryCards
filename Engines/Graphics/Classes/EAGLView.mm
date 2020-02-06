//
//  EAGLView.m
//  Graphics
//
//  Created by Eric Duhon on 1/7/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
#import "HPT Graphics.h"
#include <mach/mach.h>
#include <mach/mach_time.h>
#include "AssetList.h"

using namespace CR;

#define USE_DEPTH_BUFFER 0

HPTBackground *background = 0;
HPTGraphicsEngine* graphics = 0;
HPTSprite1 *sprite1 = 0;
HPTSprite1 *spencer = 0;
HPTTileBackground *backTiles = 0;
HPTTileBackground *frontTiles = 0;
HPTFont1 *smallfont = 0;
HPTFont1 *largefont = 0;


float inverse_timerfreq;

float sx1 = 0.0f;
float sy1 = 0.0f;
float sx2 = 0.0f;
float sy2 = 300.0f;
bool fwd = true;

uint64_t starttime;
uint64_t currenttime;

int framecount = 0;
float frametime = 0.0f;
int fps = 0;

float tilepos = 20;
bool tilefwd = true;

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation EAGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;


// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
		
		[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
		
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / 60.0;
		
		mach_timebase_info_data_t time_info;
		mach_timebase_info(&time_info);
		
		inverse_timerfreq = time_info.numer/(float)time_info.denom;
		inverse_timerfreq /= 1000000000.0f;
		
		starttime = mach_absolute_time();
		
		graphics = GetHPTGraphicsEngine();
		NSString * path = [[NSBundle mainBundle] pathForResource:  @"test" ofType: @"hgf"];
		const char *c = [path cStringUsingEncoding:1];
		
		graphics->LoadHGF(c);
		background = graphics->CreateHPTBackground();
		background->SetImage(AssetList::static_bg);
		graphics->SetBackgroundImage(background);
		graphics->SetClearScreen(false);
		sprite1 = graphics->CreateSprite1();
		sprite1->SetImage(AssetList::ninja);
		sprite1->SetAutoAnimate(true);
		spencer = graphics->CreateSprite1();
		spencer->SetImage(AssetList::Spencer_Framesets);
		spencer->SetAutoAnimate(true);
		
		backTiles = graphics->CreateHPTTileBackground();
		path = [[NSBundle mainBundle] pathForResource:  @"Level1b" ofType: @"htf"];
		const char *level1b = [path cStringUsingEncoding:1];
		backTiles->LoadTileSet(const_cast<char*>(level1b));
		//graphics->SetTileBackgroundImage(0,backTiles);
		backTiles->SetPositionRelative(0, -50);
		
		frontTiles = graphics->CreateHPTTileBackground();
		path = [[NSBundle mainBundle] pathForResource:  @"Level1f" ofType: @"htf"];
		const char *level1f = [path cStringUsingEncoding:1];
		frontTiles->LoadTileSet(const_cast<char*>(level1f));
		//graphics->SetTileBackgroundImage(1,frontTiles);
		
		smallfont = graphics->CreateFont1();
		path = [[NSBundle mainBundle] pathForResource:  @"small" ofType: @"HFF"];
		const char *smallf = [path cStringUsingEncoding:1];
		smallfont->LoadHFFFont(const_cast<char*>(smallf));
		
		largefont = graphics->CreateFont1();
		path = [[NSBundle mainBundle] pathForResource:  @"large" ofType: @"HFF"];
		const char *largef = [path cStringUsingEncoding:1];
		largefont->LoadHFFFont(const_cast<char*>(largef));
		//graphics->SetBackgroundColor(0, 0, 255);
    }
    return self;
}


- (void)drawView {
    
    // Replace the implementation of this method to do your own custom drawing
	
	float timepassed;
	currenttime = mach_absolute_time();
	timepassed = (currenttime - starttime)*inverse_timerfreq;
	starttime = currenttime;	
	if(fwd)
	{
		sx1 += timepassed*60;
		sx2 += timepassed*60;
	}
	else
	{
		sx1 -= timepassed*60;
		sx2 -= timepassed*60;
	}
	
	if(fwd)
	{
		sy1 += timepassed*40;
		sy2 -= timepassed*40;
	}
	else
	{
		sy1 -= timepassed*40;
		sy2 += timepassed*40;
	}
	
	if(fwd && sx1 > 450)
	{
		fwd = false;
		spencer->SetFrameSet(3);
	}
	else if(!fwd && sx1 < 0)
	{
		fwd = true;
		spencer->SetFrameSet(2);
	}
	
	if(tilefwd)
		tilepos += timepassed*20;
	else
		tilepos -= timepassed*20;
	
	if(tilepos > 20)
	{
		tilefwd = false;
		tilepos = 19;
	}
	else if (tilepos < -1000)
	{
		tilefwd = true;
		tilepos = -999;
	}
			
	backTiles->SetPositionRelative(tilepos-100, -50);	
	frontTiles->SetPositionRelative(tilepos*4-400,0);

	framecount++;
	frametime += timepassed;
	
	if(framecount >= 10)
	{
		fps = static_cast<int>(framecount/frametime);
		frametime = 0;
		framecount = 0;
	}
	
    [EAGLContext setCurrentContext:context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-159.5f, 159.5f, -239.5f, 239.5f, 0.0f, 100.0f);
	glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    //glLoadIdentity();
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	// Enable blending
	glEnable(GL_BLEND);
	
	graphics->BeginFrame();
	sprite1->SetPositionAbsalute(static_cast<int>(sx1),static_cast<int>(sy1));
	spencer->SetPositionAbsalute(static_cast<int>(sx2),static_cast<int>(sy2));
	if(fwd)
	{
		sprite1->Render();
		spencer->Render();
	}
	else
	{
		sprite1->RenderHFlip();
		spencer->RenderHFlip();
	}
	
	graphics->Position(10, 10);
	(*graphics) << smallfont;
	(*graphics) << "test";
	
	graphics->Position(200, 15);
	(*graphics) << largefont;
	(*graphics) << "FPS " << fps;
	
	graphics->Position(200, 50);
	(*graphics) << "az AX 09 .?";
	
	graphics->EndFrame();
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}


- (void)dealloc {
    
    [self stopAnimation];
    
	if(sprite1)
		sprite1->Release();
	if(background)
		background->Release();
	if(graphics)
		graphics->Release();
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end
