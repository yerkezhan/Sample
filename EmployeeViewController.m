//
//  EmployeeViewController.m
//
//  Copyright © 2016. All rights reserved.
//

#import "EmployeeViewController.h"
#import "CustomTableViewCell.h"
#import "Constant.h"
#import "ContactViewController.h"

@interface EmployeeViewController ()
@property (strong, nonatomic) AbstractDataSource *dataSourse;
@property (weak, nonatomic) IBOutlet CustomSearch *mainSearch;
@property (weak, nonatomic) IBOutlet CustomTable *mainTable;
@property (weak, nonatomic) IBOutlet UILabel *companyTitle;
@end

@implementation EmployeeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _companyTitle.text = _myCompany1.title;
    
    self.dataSourse = [[AbstractDataSource alloc] init];
    self.dataSourse.customDelegate = self;
    self.dataSourse.company1 = _myCompany1;
    
    [self.dataSourse configureForEmployeesOfCompany];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueEmpToCont]) {
        [(ContactViewController *)segue.destinationViewController setMyCompany:_myCompany1];
        [(ContactViewController *)segue.destinationViewController setMyEmployee:sender];
    }
}

#pragma mark TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:segueEmpToCont sender:[self.dataSourse getObjectAtIndexPath:indexPath]];
}

#pragma mark FavouriteEmployee Delegate

-(void)tableViewReloadAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            EmpObject* emp = (EmpObject*)[self.dataSourse getObjectAtIndexPath:indexPath];
            if (emp.isFav) {
                CGRect rectInTableView = [_mainTable rectForRowAtIndexPath:indexPath];
                CGRect rectInSuperview = [_mainTable convertRect:rectInTableView toView:[_mainTable superview]];
                UIImageView* im = [[UIImageView alloc] initWithFrame:CGRectMake(11, rectInSuperview.origin.y+12, 45, 45)];
                CustomTableViewCell *cell = (CustomTableViewCell*)[_mainTable cellForRowAtIndexPath:indexPath];
                im.image = cell.logoImage.image;
                im.layer.cornerRadius = im.frame.size.height/2;
                im.layer.masksToBounds = YES;
                [self.tabBarController.tabBar.superview insertSubview:im aboveSubview:self.tabBarController.tabBar];
                
                [UIView animateWithDuration:0.7 animations:^{
                    [im setFrame:CGRectMake(3*self.view.frame.size.width/10-10, self.view.frame.size.height-40, 20, 20)];
                } completion:^(BOOL finished) {
                    [im removeFromSuperview];
                }];
            }
            
        });
    });
}

@end
