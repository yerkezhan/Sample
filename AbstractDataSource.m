//
//  AbstractDataSource.m
//
//  Copyright © 2016. All rights reserved.
//

#import "Utility.h"
#import "Request.h"
#import "DBManager.h"
#import "AbstractDataSource.h"
#import "CustomTableViewCell.h"


@implementation AbstractDataSource

-(id)getObjectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[_objects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _objects.count;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_entityType == ENTITY_TYPE_EMPLOYEE) {
        return [_titles objectAtIndex:section];
    }
    return nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_objects objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrgObject* entityOrg;
    EmpObject* entityEmp;
    
    static NSString *myIdentifier;
    switch (_entityType) {
        case ENTITY_TYPE_COMPANY:
            entityOrg = (OrgObject*)[[_objects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            myIdentifier = @"companyCell";
            break;
        case ENTITY_TYPE_DEPARTMENT:
            entityOrg = (OrgObject*)[[_objects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            myIdentifier = @"departmentCell";
            break;
        case ENTITY_TYPE_EMPLOYEE:
            entityEmp = (EmpObject*)[[_objects objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            myIdentifier = @"employeeCell";
            break;
        default:
            break;
    }
    
    CustomTableViewCell * cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] init];
    }
    
    switch (_entityType) {
        case ENTITY_TYPE_COMPANY: case ENTITY_TYPE_DEPARTMENT:
        {
            NSString *title = entityOrg.title;
            cell.titleLabel.text = title;
            
            NSString *newstr = [[title substringToIndex:1] uppercaseString];
            int k = [newstr characterAtIndex:0];
            
            cell.logoImage.backgroundColor = [Utility getCurrentColor:k];
            cell.letterLabel.text = newstr;
            break;
        }
        case ENTITY_TYPE_EMPLOYEE:
        {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@", entityEmp.lname, entityEmp.fname];
            cell.positionLabel.text = entityEmp.position;
            
            cell.logoImage.image = [UIImage imageNamed:@"contactAva"];
            cell.logoImage.image = entityEmp.myPhoto;
            [cell.starButton setImage:[UIImage imageNamed:@"listNonFavourite"] forState:UIControlStateNormal];
            if (entityEmp.isFav) {
                [cell.starButton setImage:[UIImage imageNamed:@"listFavourite"] forState:UIControlStateNormal];
            }
            cell.starButton.myIndexPath = indexPath;
            [cell.starButton addTarget:self action:@selector(indexPathForPressedFavouriteButton:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)indexPathForPressedFavouriteButton:(CustomButton *)button
{
    NSIndexPath *indexPath = button.myIndexPath;
    EmpObject* emp = [self getObjectAtIndexPath:indexPath];
    EmpObject* another = [emp copy];
    another.isFav = !another.isFav;
    if([[DBManager sharedInstance] saveEmployeeAndUpdate:another]){
        emp = another;
        [_customDelegate tableViewReloadAtIndexPath:indexPath];
    }
}

-(void)configureForCompanies
{
    NSMutableArray* array = [[DBManager sharedInstance] getOrgUnits:0 andIsDept:NO];
    _dataCount = (int)array.count;
    _allobjects = array;
    _objects = [NSMutableArray arrayWithObject:array];
    if (_objects == nil) _objects = [[NSMutableArray alloc] initWithObjects:@[], nil];
    _fetchName = allCompanies;
    _entityType = ENTITY_TYPE_COMPANY;
}

-(void)configureForDepartmentsOfCompany
{
    NSMutableArray* array = [[DBManager sharedInstance] getOrgUnits:_company1.orgID andIsDept:YES];
    _dataCount = (int)array.count;
    _allobjects = array;
    _objects = [NSMutableArray arrayWithObject:array];
    if (_objects == nil) _objects = [[NSMutableArray alloc] initWithObjects:@[], nil];
    _fetchName = allDepartments;
    _entityType = ENTITY_TYPE_DEPARTMENT;
}

-(void)configureForEmployeesOfCompany
{
    _fetchName = allEmployees;
    _entityType = ENTITY_TYPE_EMPLOYEE;
    NSMutableDictionary* dic = [[DBManager sharedInstance] getEmployees:_company1 isFav:0];
    _allobjects = [dic objectForKey:@"allobjects"];
    _objects = [dic objectForKey:@"objects"];
    _titles = [dic objectForKey:@"titles"];
    _dataCount = [[dic objectForKey:@"dataCount"] intValue];
}

@end
