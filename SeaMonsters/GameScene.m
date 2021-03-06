//
//  GameScene.m
//  SeaMonsters
//
//  Created by Asif Alli on 2022-06-12.
//

#import "GameScene.h"
#import "CoreMotion/CoreMotion.h"
#import "GameKit/GameKit.h"

@implementation GameScene {
    SKSpriteNode *player;
    SKSpriteNode *enemyHermitCrab; //= [SKSpriteNode spriteNodeWithImageNamed:@"HermitCrab.png"];

    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
    //Nodes
    SKNode *joystick;
    SKNode *joystickNob;
    CMMotionManager *motionManager;
    
    //Bools
    BOOL joystickAction;
    
    //Measure
    CGFloat knobRadius;
    
    //Sprite Engine
    CFTimeInterval previousTimeInterval;
    BOOL playerIsFacingRight;
    double playerSpeed;
    BOOL joystickDirection;
    int movementOffsetX;
    int movementOffsetY;
    NSTimer *gameTimer;
    
    //Score
    SKLabelNode * scoreLabel;
    int score;
}

- (void)didMoveToView:(SKView *)view {
    scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"AvenirNextCondensed-Bold"];
    scoreLabel.zPosition=2;
    [scoreLabel setPosition:CGPointMake(20, 160)];
    [self addChild:scoreLabel];
    score = 0;
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %i",score]];
    
    movementOffsetX = 0;
    movementOffsetY = 0;
    knobRadius = 50.0;
    joystickAction = NO;
    
    previousTimeInterval = 0;
    playerIsFacingRight = YES;
    playerSpeed = 4.0;
    
    player = [self childNodeWithName:@"Player"];
    enemyHermitCrab = [self childNodeWithName:@"HermitCrab"];
    //enemyHermitCrab = [SKSpriteNode spriteNodeWithImageNamed:@"HermitCrab.png"];
    
    //player = [Level1 childNodeWithName:@"Player"];
    //player = [SKSpriteNode no childNodeWithName:@"Player"];
    joystick = [self childNodeWithName:@"Joystick"];
    joystickNob = [joystick childNodeWithName:@"Knob"];
    joystickDirection = 1;
    
    //[player setPosition:CGPointMake(-275, 95)];
    player.zPosition=1;
    //[self addChild:player];
    
    SKEmitterNode *particles = [SKEmitterNode nodeWithFileNamed:@"Bubbles"];
    if(particles!=nil){
        //particles.position.x = 512;
        [particles setPosition:CGPointMake(512, 0)];
        [particles advanceSimulationTime:10];
        [self addChild:particles];
    }
    
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(createEnemy) userInfo:nil repeats:YES];
    
    //player setPhysicsBody:<#(SKPhysicsBody * _Nullable)#>
    //[player setPhysicsBody:[SKPhysicsBody bodyWithTexture: [player texture] size: [player size]]];
    [player setPhysicsBody: [SKPhysicsBody  bodyWithTexture: [player texture] size: [player size]]];
    player.physicsBody.categoryBitMask=1;
    
    self.physicsWorld.contactDelegate=self;
    
    
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
    NSString *direction = @"";
    for(UITouch *touch in touches) {
        
        CGPoint position = [touch locationInNode:joystick];
        double length = sqrt(pow(position.y,2) + pow(position.x,2));
        double angle = atan2(position.y,position.x);
        //NSLog(@"%@", [NSString stringWithFormat:@"position.x=%f, position.y=%f, length=%f, angle=%f",position.x,position.y,length,angle]);
        if(knobRadius>length){
            joystickNob.position = position;
        }else{
            joystickNob.position = CGPointMake(cos(angle) * knobRadius,sin(angle)*knobRadius);
        }
        
        if(position.x>0 && position.x <=54){
            direction = @"Right";
            //NSLog(direction);
            
            joystickDirection=1;
            //[player setPosition:CGPointMake(player.position.x+1, player.position.y)];
            //player.position.x +=1;
            movementOffsetX=3;
        }
        if(position.x<0 && position.x >=-54){
            direction = @"Left";
            //NSLog(direction);
            joystickDirection=0;
            //[player setPosition:CGPointMake(player.position.x-1, player.position.y)];
            //player.position.y -=1;
            movementOffsetX=-3;
        }
        if(position.y>0 && position.y<=54){
            direction = @"Up";
            //NSLog(direction);
            joystickDirection=2;
            //[player setPosition:CGPointMake(player.position.x+1, player.position.y)];
            //player.position.x +=1;
            movementOffsetY=-3;
        }
        if(position.y<0 && position.y>=-54){
            direction = @"Down";
            //NSLog(direction);
            joystickDirection=3;
            //[player setPosition:CGPointMake(player.position.x-1, player.position.y)];
            //player.position.y -=1;
            movementOffsetY=3;
        }
        NSLog(@"%@", [NSString stringWithFormat:@"dir=%@, position.x=%f, position.y=%f",direction, position.x,position.y]);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        //[self touchUpAtPoint:[t locationInNode:self]];
        double xJoystickCoordinate = [touch locationInNode:joystick].x;
        double yJoystickCoordinate = [touch locationInNode:joystick].y;
        CGFloat xLimit = 200.0;
        CGFloat yLimit = 200.0;
        if(xJoystickCoordinate>-xLimit && xJoystickCoordinate<xLimit){
            [self resetKnobPosition];
        }
        
        if(yJoystickCoordinate>-yLimit && yJoystickCoordinate<yLimit){
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
    /*
    double xPosition = joystickNob.position.x;
    double yPosition = joystickNob.position.y;
    CGVector displacement = CGVectorMake(deltaTime * xPosition * playerSpeed, 0);
    SKAction *move = [SKAction moveBy:displacement duration:0];
    //[player runAction:move];
    */
    if(!joystickAction){
        movementOffsetX=0;
        movementOffsetY=0;
    }

    [player setPosition:CGPointMake(player.position.x+movementOffsetX, player.position.y+movementOffsetY)];
    
    
}

-(void) createEnemy{
    id randomDistribution = [GKRandomDistribution distributionWithLowestValue:-350 highestValue:350];
    //SKNode *sprite = [self childNodeWithName:@"HermitCrab"];
    //SKSpriteNode *sprite = [SKSpriteNode nodeWithFileNamed:@"HermitCrab"];
    //SKSpriteNode *enemyHermitCrab = [SKSpriteNode spriteNodeWithImageNamed:@"HermitCrab.png"];
    enemyHermitCrab = [SKSpriteNode spriteNodeWithImageNamed:@"HermitCrab.png"];
    //enemyHermitCrab = [self childNodeWithName:@"HermitCrab"];
    double aspectRatio = enemyHermitCrab.size.width/enemyHermitCrab.size.height;
    CGFloat preferredWidth = 30;
    enemyHermitCrab.size = CGSizeMake( preferredWidth,preferredWidth/aspectRatio );
    
    [enemyHermitCrab setPosition:CGPointMake(200, [randomDistribution nextInt])];
    [enemyHermitCrab setName:@"enemy"];
    [enemyHermitCrab setZPosition:1];
    [self addChild:enemyHermitCrab];
    
    [enemyHermitCrab setPhysicsBody:[SKPhysicsBody bodyWithTexture: [enemyHermitCrab texture] size: [enemyHermitCrab size]]];
    //[sprite setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:200]];
    [enemyHermitCrab.physicsBody setVelocity:CGVectorMake(-100, 0)];
    [enemyHermitCrab.physicsBody setLinearDamping:5];
    [enemyHermitCrab.physicsBody setContactTestBitMask:1];
    [enemyHermitCrab.physicsBody setCategoryBitMask:0];
}

-(void) didBeginContact:(SKPhysicsContact *)contact {
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    
    if(nodeA==nil) return;
    if(nodeB==nil) return;
    
    //if(nodeA==player && nodeB==enemyHermitCrab)
    if(nodeA==player)
       [self playerHit: nodeB];
    //else
    //    [self playerHit:nodeA];
}

-(void) playerHit: (SKNode *) node {
    //[player removeFromParent];
    NSLog(@"Hit!!");
    score++;
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %i",score]];
}

@end
