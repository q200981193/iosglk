/* GlkFileTypes.h: Miscellaneous file-related objc classes
	for IosGlk, the iOS implementation of the Glk API.
	Designed by Andrew Plotkin <erkyrath@eblong.com>
	http://eblong.com/zarf/glk/
*/

#import <Foundation/Foundation.h>
#include "glk.h"

@interface GlkFileRefPrompt : NSObject {
	glui32 usage;
	glui32 fmode;
	NSString *dirname;
	NSString *filename;
}

- (id) initWithUsage:(glui32)usage fmode:(glui32)fmode dirname:(NSString *)dirname;

@property (nonatomic) glui32 usage;
@property (nonatomic) glui32 fmode;
@property (nonatomic, retain) NSString *dirname;
@property (nonatomic, retain) NSString *filename;

@end


@interface GlkFileThumb : NSObject {
	NSString *label;
	NSString *pathname;
	NSDate *modtime;
}

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *pathname;
@property (nonatomic, retain) NSDate *modtime;

@end

