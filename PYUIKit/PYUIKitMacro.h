//
//  PYUIKitMacro.h
//  PYUIKit
//
//  Created by Push Chen on 7/24/13.
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

#ifndef PYUIKit_PYUIKitMacro_h
#define PYUIKit_PYUIKitMacro_h

#define PYIsRetina                                                  \
    ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]	\
    && [[UIScreen mainScreen] scale] == 2.0)

// Float Equal
#ifndef PYFLOATEQUAL
#define PYFLOATEQUAL( f1, f2 )                  (PYABSF((f1) - (f2)) < 0.001)
#endif

#ifdef DEBUG
#define DUMPRect(r)                                                 \
    __print_logHead(__FUNCTION__, __LINE__);                        \
    printf("%s:(%f,%f,%f,%f)\n", #r, (r).origin.x, (r).origin.y,\
            (r).size.width, (r).size.height)
#else
#define DUMPRect(r)
#endif

#endif

// @littlepush
// littlepush@gmail.com
// PYLab
