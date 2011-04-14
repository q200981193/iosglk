/* GlkFileSelectViewController./: View controller class for the load/save dialog
	for IosGlk, the iOS implementation of the Glk API.
	Designed by Andrew Plotkin <erkyrath@eblong.com>
	http://eblong.com/zarf/glk/
*/

#import "GlkFileSelectViewController.h"
#import "GlkFileTypes.h"
#import "GlkAppWrapper.h"
#import "GlkUtilities.h"


@implementation GlkFileSelectViewController

@synthesize prompt;
@synthesize filelist;

- (id) initWithNibName:(NSString *)nibName prompt:(GlkFileRefPrompt *)promptref bundle:(NSBundle *)nibBundle {
	self = [super initWithNibName:nibName bundle:nibBundle];
	if (self) {
		self.prompt = promptref;
		self.filelist = [NSMutableArray arrayWithCapacity:16];
	}
	return self;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"Load"; //### localize and customize
	
	UIBarButtonItem *cancelbutton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(buttonCancel:)] autorelease];
	
	self.navigationItem.leftBarButtonItem = cancelbutton;
	self.navigationItem.rightBarButtonItem = [self editButtonItem];
	
	[filelist removeAllObjects];
	NSArray *ls = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:prompt.dirname error:nil];
	if (ls) {
		for (NSString *filename in ls) {
			NSString *pathname = [prompt.dirname stringByAppendingPathComponent:filename];
			NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:pathname error:nil];
			if (!attrs)
				continue;
			if (![NSFileTypeRegular isEqualToString:[attrs fileType]])
				continue;
				
			NSString *label = StringFromDumbEncoding(filename);
			if (!label)
				continue;
			
			GlkFileThumb *thumb = [[[GlkFileThumb alloc] init] autorelease];
			thumb.pathname = pathname;
			thumb.modtime = [attrs fileModificationDate];
			thumb.label = label;
			
			[filelist addObject:thumb];
		}
	}
	
	//### sort by modtime
}

- (void) viewDidUnload {
	[super viewDidUnload];
}

- (void) dealloc {
	self.prompt = nil;
	self.filelist = nil;
	[super dealloc];
}

- (IBAction) buttonCancel:(id)sender {
	NSLog(@"buttonCancel");
	[self dismissModalViewControllerAnimated:YES];
	[[GlkAppWrapper singleton] acceptEventSpecial];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


// Table view data source methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return filelist.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	// This is boilerplate and I haven't touched it.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	GlkFileThumb *thumb = nil;
	
	int row = indexPath.row;
	if (row >= 0 && row < filelist.count)
		thumb = [filelist objectAtIndex:row];
		
	/* Make the cell look right... */
	if (!thumb) {
		// shouldn't happen
		cell.textLabel.text = @"(null)";
	}
	else {
		cell.textLabel.text = thumb.label;
	}

	return cell;
}


// Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//### return that puppy and close everything
}


- (void) didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

	// Release any cached data, images, etc. that aren't in use.
}

@end

