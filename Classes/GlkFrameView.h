/* GlkFrameView.h: Main view class
	for IosGlk, the iOS implementation of the Glk API.
	Designed by Andrew Plotkin <erkyrath@eblong.com>
	http://eblong.com/zarf/glk/
*/

#import <UIKit/UIKit.h>

@class GlkLibrary;

@interface GlkFrameView : UIView {
	/* How much of the view bounds to reserve for the keyboard. */
	CGFloat keyboardHeight;
	
	/* Maps tags (NSNumbers) to GlkWindowViews. (But pair windows are excluded.) */
	NSMutableDictionary *windowviews;
}

@property (nonatomic, retain) NSMutableDictionary *windowviews;
@property (nonatomic) CGFloat keyboardHeight;

- (void) updateFromLibraryState:(GlkLibrary *)library;
- (void) updateFromLibrarySize:(GlkLibrary *)library;

@end
