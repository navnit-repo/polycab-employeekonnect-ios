//
//  JSONStructure.h
//  demo
//
//  Created by Ashish Tiwari on 20/05/13.
//
//

#import <Foundation/Foundation.h>


@protocol JSONStructure

- (id) toJSON;
- (int) getJsonStructureId;
- (id) toBean:(id) jsonObject;

@end
