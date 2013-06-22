//
//  JotViewState.m
//  JotUI
//
//  Created by Adam Wulf on 6/21/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#import "JotViewState.h"
#import "JotImmutableStroke.h"

@implementation JotViewState{
    // begin possible state object
    __strong JotGLTexture* backgroundTexture;
    __strong JotGLTextureBackedFrameBuffer* backgroundFramebuffer;
    
    // this dictionary will hold all of the in progress
    // stroke objects
    __strong NSMutableDictionary* currentStrokes;
    // these arrays will act as stacks for our undo state
    __strong NSMutableArray* stackOfStrokes;
    __strong NSMutableArray* stackOfUndoneStrokes;
    NSMutableArray* strokesBeingWrittenToBackingTexture;
    NSUInteger undoLimit;
}

@synthesize backgroundTexture;
@synthesize backgroundFramebuffer;
@synthesize currentStrokes;
@synthesize stackOfStrokes;
@synthesize stackOfUndoneStrokes;
@synthesize strokesBeingWrittenToBackingTexture;
@synthesize undoLimit;

-(id) init{
    if(self = [super init]){
        // setup our storage for our undo/redo strokes
        currentStrokes = [NSMutableDictionary dictionary];
        stackOfStrokes = [NSMutableArray array];
        stackOfUndoneStrokes = [NSMutableArray array];
        strokesBeingWrittenToBackingTexture = [NSMutableArray array];
    }
    return self;
}

-(NSArray*) everyVisibleStroke{
    return [self.strokesBeingWrittenToBackingTexture arrayByAddingObjectsFromArray:[self.stackOfStrokes arrayByAddingObjectsFromArray:[self.currentStrokes allValues]]];
}


-(void) setBackgroundTexture:(JotGLTexture *)_backgroundTexture{
    // generate FBO for the texture
    backgroundTexture = _backgroundTexture;
    backgroundFramebuffer = [[JotGLTextureBackedFrameBuffer alloc] initForTexture:backgroundTexture];
}

-(void) tick{
    if([self.stackOfStrokes count] > self.undoLimit){
        while([self.stackOfStrokes count] > self.undoLimit){
            NSLog(@"== eating strokes");
            
            [self.strokesBeingWrittenToBackingTexture addObject:[self.stackOfStrokes objectAtIndex:0]];
            [self.stackOfStrokes removeObjectAtIndex:0];
        }
    }
}


-(NSDictionary*) asDictionary{
    NSMutableDictionary* stateDict = [NSMutableDictionary dictionary];
    NSMutableArray* stackOfImmutableStrokes = [NSMutableArray array];
    NSMutableArray* stackOfImmutableUndoneStrokes = [NSMutableArray array];
    for(JotStroke* stroke in self.stackOfStrokes){
        [stackOfImmutableStrokes addObject:[[JotImmutableStroke alloc] initWithJotStroke:stroke]];
    }
    for(JotStroke* stroke in self.stackOfUndoneStrokes){
        [stackOfImmutableUndoneStrokes addObject:[[JotImmutableStroke alloc] initWithJotStroke:stroke]];
    }
    
//    stackOfImmutableStrokes = [stackOfStrokes copy];
//    stackOfImmutableUndoneStrokes = [stackOfUndoneStrokes copy];
    
    [stateDict setObject:stackOfImmutableStrokes forKey:@"stackOfStrokes"];
    [stateDict setObject:stackOfImmutableUndoneStrokes forKey:@"stackOfUndoneStrokes"];
    return stateDict;
}

#pragma mark - Public Methods

-(BOOL) isReadyToExport{
    [self tick];
    if([strokesBeingWrittenToBackingTexture count] ||
       [currentStrokes count] ||
       [stackOfStrokes count] > undoLimit){
        if([currentStrokes count]){
            NSLog(@"cant save, currently drawing");
        }else if([strokesBeingWrittenToBackingTexture count]){
            NSLog(@"can't save, writing to texture");
        }else if([stackOfStrokes count] > undoLimit){
            NSLog(@"can't save, more strokes than undo");
        }
        return NO;
    }
    return YES;
}


#pragma mark - dealloc

-(void)dealloc{
    backgroundFramebuffer = nil;
}

@end