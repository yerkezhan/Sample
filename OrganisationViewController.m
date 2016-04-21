//
//  OrganisationViewController.m
//
//  Copyright © 2016 . All rights reserved.
//

#import "OrganisationViewController.h"
#import "EmployeesViewController.h"
#import "AbstractDataSource.h"

@interface OrganisationViewController ()
@property (strong, nonatomic) AbstractDataSource *dataSourse;
@property (weak, nonatomic) IBOutlet CustomTable *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;
@end

@implementation OrganisationViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _myTitle.text = _myCompany1.title;
    
    self.dataSourse = [[AbstractDataSource alloc] init];
    self.dataSourse.company1 = _myCompany1;

    switch (_myType) {
        case ENTITY_TYPE_COMPANY:
            [self.dataSourse configureForCompanies];
            break;
        case ENTITY_TYPE_DEPARTMENT:
            [self.dataSourse configureForDepartmentsOfCompany];
        default:
            break;
    }
    _mainTable.dataSource = self.dataSourse;
    _mainTable.delegate = self;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mainTable reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_myType) {
        case ENTITY_TYPE_COMPANY:
            [self performSegueWithIdentifier:segueCompToEmp sender:[self.dataSourse getObjectAtIndexPath:indexPath]];
            break;
        case ENTITY_TYPE_DEPARTMENT:
            [self performSegueWithIdentifier:segueDeptToEmp sender:[self.dataSourse getObjectAtIndexPath:indexPath]];
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueCompToEmp] || [segue.identifier isEqualToString:segueDeptToEmp]) {
        [(EmployeesViewController *)segue.destinationViewController setMyCompany1:sender];
        
    }
}

@end
