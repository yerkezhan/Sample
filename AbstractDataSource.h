//
//  AbstractDataSource.h
//
//  Copyright © 2016. All rights reserved.
//

@protocol FavouriteEmployeeDelegate <UITableViewDelegate>
-(void)tableViewReloadAtIndexPath: (NSIndexPath*)indexPath;
@end


@interface AbstractDataSource : NSObject<UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray* objects;
@property (strong, nonatomic) NSMutableArray* allobjects;
@property (strong, nonatomic) NSMutableArray* titles;
@property (strong, nonatomic) NSString* fetchName;
@property (strong, nonatomic) OrgObject* company1;
@property (nonatomic) ENTITY_TYPE entityType;
@property (nonatomic) int dataCount;
@property (nonatomic) NSIndexPath *myIndex;
@property id<FavouriteEmployeeDelegate> customDelegate;

-(id)getObjectAtIndexPath:(NSIndexPath *)indexPath;

- (void)configureForCompanies;
- (void)configureForDepartmentsOfCompany;
- (void)configureForEmployeesOfCompany;

@end
