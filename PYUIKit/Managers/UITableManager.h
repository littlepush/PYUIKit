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
    UITableManagerEventCanInsertCell            = PYTableManagerEventUserDefined + 21,
    UITableManagerEventGetCellClass             = PYTableManagerEventGetCellClass,
    UITableManagerEventGetSectionTitle          = PYTableManagerEventUserDefined + 16,
    UITableManagerEventGetSectionFooter         = PYTableManagerEventUserDefined + 17,
    UITableManagerEventGetSectionFooterTitle    = PYTableManagerEventUserDefined + 18,
    UITableManagerEventGetSectionHeaderTitle    = PYTableManagerEventUserDefined + 19,
    UITableManagerEventGetHeightOfSectionFooter = PYTableManagerEventUserDefined + 20,
    UITableManagerEventDeletingTitle            = PYTableManagerEventUserDefined + 22
};

@interface UITableManager : PYActionDispatcher<PYTableManagerProtocol>

/*!
 @brief The cell class
 */
- (Class)classOfCellAtIndex:(NSIndexPath *)index;

/*!
 @brief The default cell class
 */
@property (nonatomic, assign)   Class           defaultCellClass;

/*!
 @brief Set different cell class for different section
 */
- (void)setCellClass:(Class)cellClass forSection:(NSUInteger)section;

/*!
 @brief Enable editing for every cell.
 */
@property (nonatomic, assign)   BOOL            enableEditing;

/*!
 @brief Editing style: Delete
 */
@property (nonatomic, assign, setter=setEnableDeleting:) BOOL isEnableDeleting;

/*!
 @brief Editing style: Insert/Re-Order
 */
@property (nonatomic, assign, setter=setEnableInsert:)  BOOL isEanbleInsert;

/*!
 @brief Is current table view updating its content data source.
 */
@property (nonatomic, readonly) BOOL            isUpdating;

/*!
 @brief The datasource.
 */
@property (nonatomic, readonly) NSArray         *contentDataSource;

/*!
 @brief Get the section count
 */
@property (nonatomic, readonly) NSUInteger      sectionCount;

/*!
 @brief If show section header view
 */
@property (nonatomic, assign)   BOOL            isShowSectionHeader;

/*!
 @brief If show section footer view
 */
@property (nonatomic, assign)   BOOL            isShowSectionFooter;

/*!
 @brief If current data source is multiple section
 */
@property (nonatomic, readonly) BOOL            isMultiSection;

/*!
 @brief Pull Down Refresh Container View
 */
@property (nonatomic, readonly) UIView          *pullDownContainerView;
/*!
 @brief Pull Up Load More Container View
 */
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

/*!
 @brief Has finished updating content, reset the pull down/up container statue
 */
- (void)finishUpdateContent;

/*!
 @brief Did cancel updating content, reset the pull down/up container statue
 */
- (void)cancelUpdateContent;

/*!
 @brief Append new data to the end of list
 */
- (void)appendNewDataToEOL:(NSArray *)dataArray scrollToBottom:(BOOL)scrollToBottom;

/*!
 @brief Insert new data to the top of list
 */
- (void)insertNewDataToTOL:(NSArray *)dataArray scrollToTop:(BOOL)scrollToTop;

@end

// @littlepush
// littlepush@gmail.com
// PYLab
