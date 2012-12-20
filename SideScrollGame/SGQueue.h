//
//  SGQueue.h
//  SideScrollGame
//
//  Created by Benjamin Pious on 12/16/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct node  node;
struct node {
    node* next;
    id data;

};

@interface SGQueue : NSObject
@property (assign) int length;
@property (readonly, assign) node* head;
-(void) offer: (id) object;
-(id) pop;

@end
