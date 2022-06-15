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
    SKNode *joystick;
    SKNode *player;
    SKNode *joystickNob;
    BOOL joystickAction;
    CGFloat knobRadius;
}

- (void)didMoveToView:(SKView *)view {
    knobRadius = 50.0;
    joystickAction = NO;
    player = [self childNodeWithName:@"Player"];
    joystick = [self childNodeWithName:@"Joystick"];
    joystickNob = [joystick childNodeWithName:@"Knob"];
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
//    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
