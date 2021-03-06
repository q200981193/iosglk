/* GlkUtilities.m: Miscellaneous C-callable functions
	for IosGlk, the iOS implementation of the Glk API.
	Designed by Andrew Plotkin <erkyrath@eblong.com>
	http://eblong.com/zarf/glk/
*/

/*	A few utility functions that don't fit into any ObjC classes. (Either because they need to be C-callable, or just because.)
*/

#import "GlkUtilities.h"

/* Turn a string into pure-ASCII data -- in fact, into hex data. I'm not concerned with efficiency here, obviously. The string will begin with two underscores to distinguish it from "normal" strings. (I know, bad escaping is the devil's playground.)
*/
NSString *StringToDumbEncoding(NSString *str) {
	NSData *indata = [str dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char *inbytes = (unsigned char *)indata.bytes;
	NSMutableData *outdata = [NSMutableData dataWithLength:2+(indata.length)*2];
	unsigned char *outbytes = outdata.mutableBytes;
	*outbytes++ = '_';
	*outbytes++ = '_';
	for (int ix=0; ix<indata.length; ix++) {
		unsigned char ch = inbytes[ix];
		unsigned nybhi = ((ch >> 4) & 0xF);
		if (nybhi <= 9)
			nybhi += '0';
		else
			nybhi += ('A'-10);
		*outbytes++ = nybhi;
		unsigned nyblo = (ch & 0xF);
		if (nyblo <= 9)
			nyblo += '0';
		else
			nyblo += ('A'-10);
		*outbytes++ = nyblo;
	}
	
	return [[[NSString alloc] initWithData:outdata encoding:NSASCIIStringEncoding] autorelease];
}

/* Turn a string generated by the above dumb encoding back into a normal string. If it doesn't look like a dumb-encoded string, or if the decoding fails, this returns nil.
*/
NSString *StringFromDumbEncoding(NSString *str) {
	NSData *indata = [str dataUsingEncoding:NSASCIIStringEncoding];
	if (!indata || indata.length < 4)
		return nil;
	unsigned char *inbytes = (unsigned char *)indata.bytes;
	if (!inbytes || inbytes[0] != '_' || inbytes[1] != '_')
		return nil;
	int outlength = (indata.length-2) / 2;
	NSMutableData *outdata = [NSMutableData dataWithLength:outlength];
	unsigned char *outbytes = outdata.mutableBytes;
	for (int ix=0; ix<outlength; ix++) {
		unsigned char nybhi = inbytes[2+ix*2];
		unsigned char nyblo = inbytes[2+ix*2+1];
		if (nybhi >= '0' && nybhi <= '9')
			nybhi -= '0';
		else if (nybhi >= 'A' && nybhi <= 'F')
			nybhi -= ('A'-10);
		else
			return nil;
		if (nyblo >= '0' && nyblo <= '9')
			nyblo -= '0';
		else if (nyblo >= 'A' && nyblo <= 'F')
			nyblo -= ('A'-10);
		else
			return nil;
		outbytes[ix] = (nybhi << 4) | (nyblo);
	}
	
	return [[[NSString alloc] initWithData:outdata encoding:NSUTF8StringEncoding] autorelease];
}

/* Return a string showing the size and origin of a rectangle. (For debugging.) */
NSString *StringFromRect(CGRect rect) {
	return [NSString stringWithFormat:@"%.1fx%.1f at %.1f,%.1f", 
		rect.size.width, rect.size.height, rect.origin.x, rect.origin.y];
}

/* Return a string showing the extent of a rectangle. (For debugging.) */
NSString *StringFromRectAlt(CGRect rect) {
	return [NSString stringWithFormat:@"%.1f..%.1f,%.1f..%.1f", 
		rect.origin.x, rect.origin.x+rect.size.width, rect.origin.y, rect.origin.y+rect.size.height];
}

/* Return a string showing a size. (For debugging.) */
NSString *StringFromSize(CGSize size) {
	return [NSString stringWithFormat:@"%.1fx%.1f", size.width, size.height];
}

/* Return a string showing a point. (For debugging.) */
NSString *StringFromPoint(CGPoint pt) {
	return [NSString stringWithFormat:@"%.1f,%.1f", pt.x, pt.y];
}

/* Return a simple description of a string. (For debugging.) */
NSString *StringToCondensedString(NSString *str) {
	if (str.length == 0)
		return @"<empty string>";
	NSMutableString *res = [NSMutableString stringWithCapacity:str.length];
	int ix = 0;
	while (ix<str.length) {
		int bx = ix;
		unichar ch = [str characterAtIndex:ix];
		ix++;
		while (ix<str.length && [str characterAtIndex:ix] == ch)
			ix++;
		if (ch < 32) {
			[res appendFormat:@"(%d*^%c)", ix-bx, (int)(ch+64)];
		}
		else if (ix-bx == 1) {
			[res appendFormat:@"%C", ch];
		}
		else {
			[res appendFormat:@"(%d*%C)", ix-bx, ch];
		}
	}
	return res;
}


CGPoint RectCenter(CGRect rect) {
	CGPoint pt;
	pt.x = rect.origin.x + 0.5*rect.size.width;
	pt.y = rect.origin.y + 0.5*rect.size.height;
	return pt;
}

CGFloat DistancePoints(CGPoint p1, CGPoint p2) {
	CGFloat dx = p1.x - p2.x;
	CGFloat dy = p1.y - p2.y;
	return hypotf(dx, dy);
}

UIEdgeInsets UIEdgeInsetsInvert(UIEdgeInsets margins) {
	return UIEdgeInsetsMake(-margins.top, -margins.left, -margins.bottom, -margins.right);
}

UIEdgeInsets UIEdgeInsetsRectDiff(CGRect rect1, CGRect rect2) {
	UIEdgeInsets res;
	res.left = rect2.origin.x - rect1.origin.x;
	res.top = rect2.origin.y - rect1.origin.y;
	res.right = (rect1.size.width - rect2.size.width) - res.left;
	res.bottom = (rect1.size.height - rect2.size.height) - res.top;
	return res;
}

CGSize CGSizeEven(CGSize size) {
	int val = ceilf(size.width);
	if (val & 1)
		val++;
	size.width = val;
	
	val = ceilf(size.height);
	if (val & 1)
		val++;
	size.height = val;
	
	return size;
}


/* Log a C string to console. */
void nslogc(char *str) {
	NSLog(@"%s", str);
}

extern void sleep_curthread(NSTimeInterval val) {
	[NSThread sleepForTimeInterval:val];
}
