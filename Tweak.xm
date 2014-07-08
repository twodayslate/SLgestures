#import <UIKit/UIKit.h>
#import "CydiaSubstrate.h"

@interface SBSearchViewController : UIViewController <UIGestureRecognizerDelegate>
-(void)dismiss;
@end 

static BOOL added = NO;

%hook SBSearchViewController

-(int)numberOfSectionsInTableView:(UITableView *)arg1 {
	if(!added) {
		UITapGestureRecognizer *bioTap = [[%c(UITapGestureRecognizer) alloc] initWithTarget:self action:@selector(handleUITap:)];
		bioTap.delegate = self;
		bioTap.cancelsTouchesInView = NO;
		bioTap.numberOfTapsRequired = 1; 
		[arg1 addGestureRecognizer:bioTap];
		[bioTap release];
		added = YES;
	}
	
	return %orig;
}

%new 
- (void)handleUITap:(UITapGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateEnded) [self dismiss];
}
%end