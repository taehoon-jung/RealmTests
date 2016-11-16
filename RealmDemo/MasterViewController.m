//
//  MasterViewController.m
//  RealmDemo
//
//  Created by taehoon.jung on 2016. 11. 13..
//  Copyright © 2016년 thlife. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import <Realm/Realm.h>
#import "Dog.h"

@interface MasterViewController ()

@property RLMResults *objects;
@property (nonatomic, strong) Person *owner;

@property (nonatomic, strong) RLMNotificationToken *token;


@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.objects = [self loadDogs];
    
    __weak __typeof(self) weakSelf = self;
    self.token = [self.objects addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        
        NSLog(@"%@ / %@ / %@", results, change, error);
        
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        UITableView *tv = strongSelf.tableView;
        // Initial run of the query will pass nil for the change information
        if (!change) {
            [tv reloadData];
            return;
        }
        
        // changes is non-nil, so we just need to update the tableview
        [tv beginUpdates];
        [tv deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tv endUpdates];

    }];
    
    
    if (!self.owner) {
        self.owner = [[Person alloc] initWithValue:@{@"name": @"taehoon",
                                                     @"birthdate": [NSDate date]}];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:self.owner];
        [realm commitWriteTransaction];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RLMResults *)loadDogs {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name != nil"];
    return [[Dog objectsWithPredicate:predicate] sortedResultsUsingProperty:@"idx" ascending:NO];
}

- (NSUInteger)maxIdx {
    
    RLMResults *result = [[Dog allObjects] sortedResultsUsingProperty:@"idx" ascending:NO];
    
    return [[result.firstObject valueForKey:@"idx"] unsignedIntegerValue];
}


- (void)insertNewObject:(id)sender {
    
    NSString *pk = self.owner.name;
    __block NSUInteger maxIdx = [self maxIdx];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        @autoreleasepool {
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            Dog *newDog = [[Dog alloc] initWithValue:@{@"name": [NSString stringWithFormat:@"Dog-%lf", [[NSDate date] timeIntervalSince1970]]}];
            newDog.idx = ++maxIdx;

            Person *owner = [Person objectForPrimaryKey:pk];
            newDog.owner = owner;
            
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:newDog];
            [realm commitWriteTransaction];
        }
    });
    
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Dog *dog = [self.objects objectAtIndex:indexPath.row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:dog];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Dog *object = [self.objects objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ / %@", object.name, object.owner.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", object.idx];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Dog *item = [self.objects objectAtIndex:indexPath.row];
        NSString *dogName = item.name;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            @autoreleasepool {
                RLMRealm *realm = [RLMRealm defaultRealm];
                
                Dog *willDeleteDog = [Dog objectForPrimaryKey:dogName];
                
                [realm beginWriteTransaction];
                [realm deleteObject:willDeleteDog];
                [realm commitWriteTransaction];
            }
        });
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
