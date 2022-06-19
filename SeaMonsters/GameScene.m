//
//  GameScene.m
//  SeaMonsters
//
//  Created by Asif Alli on 2022-06-12.
//

#import "GameScene.h"


@implementation GameScene {
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
    //Nodes
    SKNode *joystick;
    SKNode *player;
    SKNode *joystickNob;
    
    //Bools
    BOOL joystickAction;
    
    //Measure
    CGFloat knobRadius;
    
    //Sprite Engine
    CFTimeInterval previousTimeInterval;
    BOOL playerIsFacingRight;
    double playerSpeed;
}

- (void)didMoveToView:(SKView *)view {
    knobRadius = 50.0;
    joystickAction = NO;
    
    previousTimeInterval = 0;
    playerIsFacingRight = YES;
    playerSpeed = 4.0;
    
    player = [self childNodeWithName:@"Player"];
    joystick = [self childNodeWithName:@"Joystick"];
    joystickNob = [joystick childNodeWithName:@"Knob"];
    
    SKEmitterNode *particles = [SKEmitterNode nodeWithFileNamed:@"Bubbles"];
    if(particles!=nil){
        //particles.position.x = 512;
        [particles setPosition:CGPointMake(512, 0)];
        [particles advanceSimulationTime:10];
        [self addChild:particles];
    }
    
//    // Setup your scene here
//
//    // Get label node from scene and store it for use later
//    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
//
//    _label.alpha = 0.0;
//    [_label runAction:[SKAction fadeInWithDuration:2.0]];
//
//    CGFloat w = (self.size.width + self.size.height) * 0.05;
//
//    // Create shape node to use during mouse interaction
//    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
//    _spinnyNode.lineWidth = 2.5;
//
//    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
//    [_spinnyNode runAction:[SKAction sequence:@[
//                                                [SKAction waitForDuration:0.5],
//                                                [SKAction fadeOutWithDuration:0.5],
//                                                [SKAction removeFromParent],
//                                                ]]];
}


- (void)touchDownAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor greenColor];
//    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor blueColor];
//    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor redColor];
//    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    
    for (UITouch *touch in touches) {
        if(joystickNob!=nil){
            CGPoint location = [touch locationInNode:joystick];
            joystickAction = [joystickNob containsPoint:location];
        }
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
    //UITouch *touch = [[event allTouches] anyObject];
    if(!joystickAction)
        return;
    
    for(UITouch *touch in touches) {
        //CGPoint position = [touch locationInView:joystick];
        CGPoint position = [touch locationInNode:joystick];
        double length = sqrt(pow(position.y,2) + pow(position.x,2));
        double angle = atan2(position.y,position.x);
        if(knobRadius>length){
            joystickNob.position = position;
        }else{
            joystickNob.position = CGPointMake(cos(angle) * knobRadius,sin(angle)*knobRadius);
        }
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        //[self touchUpAtPoint:[t locationInNode:self]];
        double xJoystickCoordinate = [touch locationInNode:joystick].x;
        CGFloat xLimit = 200.0;
        if(xJoystickCoordinate>-xLimit && xJoystickCoordinate<xLimit){
            [self resetKnobPosition];
        }
    }
}

#pragma MARK RESET

- (void) resetKnobPosition {
    CGPoint initialPoint = CGPointMake(0.0, 0.0);
    SKAction *moveBack = [SKAction moveTo:initialPoint duration:0.1];
    moveBack.timingMode = SKActionTimingLinear;
    [joystickNob runAction:moveBack];
    joystickAction = NO;
}


-(void)update:(CFTimeInterval)currentTime {
    CFTimeInterval deltaTime = currentTime - previousTimeInterval;
    previousTimeInterval = currentTime;
    
    double xPosition = joystickNob.position.x;
    CGVector displacement = CGVectorMake(deltaTime * xPosition * playerSpeed, 0);
    SKAction *move = [SKAction moveBy:displacement duration:0];
    [player runAction:move];
}

@end
