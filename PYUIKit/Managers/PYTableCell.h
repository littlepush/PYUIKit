//
//  PYTableCell.h
//  PYUIKit
//
//  Created by Push Chen on 11/29/13.
//  Copyright (c) 2013 Push Lab. All rights reserved.
//

/*
 LGPL V3 Lisence
 This file is part of cleandns.
 
 PYUIKit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 PYData is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with cleandns.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 LISENCE FOR IPY
 COPYRIGHT (c) 2013, Push Chen.
 ALL RIGHTS RESERVED.
 
 REDISTRIBUTION AND USE IN SOURCE AND BINARY
 FORMS, WITH OR WITHOUT MODIFICATION, ARE
 PERMITTED PROVIDED THAT THE FOLLOWING CONDITIONS
 ARE MET:
 
 YOU USE IT, AND YOU JUST USE IT!.
 WHY NOT USE THIS LIBRARY IN YOUR CODE TO MAKE
 THE DEVELOPMENT HAPPIER!
 ENJOY YOUR LIFE AND BE FAR AWAY FROM BUGS.
 */

#import <Foundation/Foundation.h>
#import "PYTableManagerProtocol.h"

@protocol PYTableCell <NSObject>

@required

// Calculate the height of a cell
+ (NSNumber *)heightOfCellWithSpecifiedContentItem:(id)contentItem;

// Rend the cell with specified item.
- (void)rendCellWithSpecifiedContentItem:(id)contentItem;

@optional

// Calculate the height of a cell in specified list
+ (NSNumber *)heightOfCellWithSpecifiedContentItem:(id)contentItem forSpecifiedList:(NSString *)identifier;

// Rend the cel with content and list identifier
- (void)rendCellWithSpecifiedContentItem:(id)contentItem forSpecifiedList:(NSString *)identifier;

// When the cell want to delete itself, the container should
// suppor this delete event to modify the content datasource.
@property (nonatomic, copy, setter = setDeleteEventCallback:)   PYTableManagerCellEvent deleteEvent;
// Bind the delete event call back block
- (void)setDeleteEventCallback:(PYTableManagerCellEvent)deleteBlock;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
