//
//  EmployeeViewController.h
//
//  Copyright © 2016. All rights reserved.
//

#import "OrgObject.h"
#import "AbstractDataSource.h"

@interface EmployeeViewController : UIViewController<FavouriteEmployeeDelegate, UITableViewDelegate>

@property OrgObject* myCompany1;

@end
