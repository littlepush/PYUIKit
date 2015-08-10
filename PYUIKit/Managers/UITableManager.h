//
//  UITableManager.h
//  PYUIKit
//
//  Created by Push Chen on 4/7/13.
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
#import <PYCore/PYCore.h>

typedef NS_OPTIONS(NSUInteger, UITableManagerEvent) {
    UITableManagerEventGetSectionHeader         = PYTableManagerEventUserDefined + 1,
    UITableManagerEventGetHeightOfSectionHeader = PYTableManagerEventUserDefined + 2,
    UITableManagerEventOnRefreshList            = PYTableManagerEventUserDefined + 3,
    UITableManagerEventOnLoadMoreList           = PYTableManagerEventUserDefined + 4,
    UITableManagerEventCancelUpdating           = PYTableManagerEventUserDefined + 5,
    UITableManagerEventWillAllowRefreshList     = PYTableManagerEventUserDefined + 6,
    UITableManagerEventWillAllowLoadMoreList    = PYTableManagerEventUserDefined + 7,
    UITableManagerEventWillGiveUpRefreshList    = PYTableManagerEventUserDefined + 8,
    UITableManagerEventWillGiveUpLoadMoreList   = PYTableManagerEventUserDefined + 9,
    UITableManagerEventBeginToRefreshList       = PYTableManagerEventUserDefined + 10,
    UITableManagerEventBeginToLoadMoreList      = PYTableManagerEventUserDefined + 11,
    UITableManagerEventEndUpdateContent         = PYTableManagerEventUserDefined + 12,
    UITableManagerEventSectionIndexTitle        = PYTableManagerEventUserDefined + 13,
    UITableManagerEventCanDeleteCell            = PYTableManagerEventUserDefined + 14,
    UITableManagerEventGetCellClass             = PYTableManagerEventGetCellClass,
    UITableManagerEventGetSectionTitle          = PYTableManagerEventUserDefined + 16,
    UITableManagerEventGetSectionFooter         = PYTableManagerEventUserDefined + 17,
    UITableManagerEventGetSectionFooterTitle    = PYTableManagerEventUserDefined + 18,
    UITableManagerEventGetSectionHeaderTitle    = PYTableManagerEventUserDefined + 19,
    UITableManagerEventGetHeightOfSectionFooter = PYTableManagerEventUserDefined + 20,
};

@interface UITableManager : PYActionDispatcher<PYTableManagerProtocol>

// The cell class
- (Class)classOfCellAtIndex:(NSIndexPath *)index;

// Set the cell class
@property (nonatomic, assign)   Class           defaultCellClass;
- (void)setCellClass:(Class)cellClass forSection:(NSUInteger)section;

// Enable editing for every cell.
@property (nonatomic, assign)   BOOL            enableEditing;

// Is current table view updating is content data source.
@property (nonatomic, readonly) BOOL            isUpdating;

// The datasource.
@property (nonatomic, readonly) NSArray         *contentDataSource;

// Get the section count
@property (nonatomic, readonly) NSUInteger      sectionCount;
@property (nonatomic, assign)   BOOL            isShowSectionHeader;
@property (nonatomic, assign)   BOOL            isShowSectionFooter;

// If current data source is multiple section
@property (nonatomic, readonly) BOOL            isMultiSection;

@property (nonatomic, readonly) UIView          *pullDownContainerView;
@property (nonatomic, readonly) UIView          *pullUpContainerView;

/*!
 @brief Style to create a cell, default is UITableViewCellStyle
 */
@property (nonatomic, assign)   UITableViewCellStyle    newCellStyle;

// Multiple Section Table Manager.
// The Data Source must be a double-level array.
- (void)bindTableView:(id)tableView
       withDataSource:(NSArray *)dataSource
         sectionCount:(NSUInteger)count;
- (void)bindTableView:(id)tableView
       withDataSource:(NSArray *)dataSource
         sectionCount:(NSUInteger)count
    showSectionHeader:(BOOL)showHeader;
- (void)bindTableView:(id)tableView
withMultipleSectionDataSource:(NSArray *)datasource;
- (void)bindTableView:(id)tableView
withMultipleSectionDataSource:(NSArray *)datasource
    showSectionHeader:(BOOL)showHeader;
- (void)reloadTableDataWithDataSource:(NSArray *)dataSource
                         sectionCount:(NSUInteger)count;
- (void)reloadTableDataWithDataSource:(NSArray *)dataSource
                         sectionCount:(NSUInteger)count
                    showSectionHeader:(BOOL)showHeader;
- (void)reloadTableDataWithMultipleSectionDataSource:(NSArray *)dataSource;
- (void)reloadTableDataWithMultipleSectionDataSource:(NSArray *)dataSource
                                   showSectionHeader:(BOOL)showHeader;

// Finish Updating Content
- (void)finishUpdateContent;
- (void)cancelUpdateContent;

// Append new data to the end of list
- (void)appendNewDataToEOL:(NSArray *)dataArray scrollToBottom:(BOOL)scrollToBottom;

// Insert new data to the top of list
- (void)insertNewDataToTOL:(NSArray *)dataArray scrollToTop:(BOOL)scrollToTop;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
