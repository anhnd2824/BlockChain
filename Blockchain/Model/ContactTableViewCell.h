//
//  ContactTableViewCell.h
//  Blockchain
//
//  Created by Tuannq on 5/8/17.
//  Copyright © 2017 Tuannq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "SWTableViewCell.h"

@interface ContactTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

- (void) setModel:(Contact *) contactObject;
@end
