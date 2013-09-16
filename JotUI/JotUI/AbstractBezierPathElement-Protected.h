//
//  AbstractBezierPathElement-Protected.h
//  JotUI
//
//  Created by Adam Wulf on 5/22/13.
//  Copyright (c) 2013 Adonit. All rights reserved.
//

#ifndef JotUI_AbstractBezierPathElement_Protected_h
#define JotUI_AbstractBezierPathElement_Protected_h

#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@interface AbstractBezierPathElement ()

@property (nonatomic, strong) UIColor* color;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat  rotation;

-(id) initWithStart:(CGPoint)point;

-(NSInteger) numberOfVerticesPerStep;

-(NSInteger) numberOfSteps;

-(NSInteger) numberOfVertices;

-(NSInteger) numberOfBytesGivenPreviousElement:(AbstractBezierPathElement*)previousElement;

-(void) validateDataGivenPreviousElement:(AbstractBezierPathElement*)previousElement;

-(struct ColorfulVertex*) generatedVertexArrayWithPreviousElement:(AbstractBezierPathElement*)previousElement forScale:(CGFloat)scale;

-(void) arrayOfPositionsForPoint:(CGPoint)point
                            andWidth:(CGFloat)stepWidth
                     andRotation:(CGFloat)stepRotation
                        outArray:(CGPoint*)pointArr;

-(CGFloat) angleBetweenPoint:(CGPoint) point1 andPoint:(CGPoint)point2;

-(BOOL) bind;

-(void) unbind;

-(void) draw;

@end


#endif
