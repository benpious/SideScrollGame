//
//  LevelNavStructs.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 2/27/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#ifndef SideScrollGame_LevelNavStructs_h
#define SideScrollGame_LevelNavStructs_h

typedef struct levelNode  levelNode;
typedef struct levelPath levelPath;

/*
 links an object to the node it is currently in. Useful for the AI in computing a path
 to a specific object such as the player
 */
typedef struct {
    
    NSObject<SGEntityProtocol>* object;
    levelNode* currNode;
    
} gameStateNode;

/*
 Generated in the level with calls from the engine, then passed to each sgcharacter.
 Allows the AI to easily find its location and the player's location in the level
    In the future, there may be seperate gameStateNode arrays for allies, so that the AI can
 try to send orders to other agents.
 */
typedef struct {
    gameStateNode* myPos;
    gameStateNode* playerPos;
    gameStateNode** entityPositions;
    
} gameState;

/*
 for the benefit of the AI -- this struct contains info about
 a path from one node to another
 the point is the point on the node that the AI should use to move,
 and the action is the action the AI should take to reach that node
 */
struct levelPath {
    levelNode* nextNode;
    float point;
    SGAction* action;
};

struct levelNode {
    levelPath** leaves;
    int numLeaves;
    int identifier;
    SGHitMask* area;
    
};

#endif
