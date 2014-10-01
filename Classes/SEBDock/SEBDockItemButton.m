//
//  SEBDockItem.m
//  SafeExamBrowser
//
//  Created by Daniel R. Schneider on 24/09/14.
//
//

#import "SEBDockItemButton.h"

@implementation SEBDockItemButton


- (id) initWithFrame:(NSRect)frameRect icon:(NSImage *)itemIcon title:(NSString *)itemTitle
 {
    self = [super initWithFrame:frameRect];
    if (self) {
        // Get image size
        CGFloat iconSize = self.frame.size.width;
        [itemIcon setSize: NSMakeSize(iconSize, iconSize)];
        self.image = itemIcon;
        
        [self setButtonType:NSMomentaryPushInButton];
        [self setImagePosition:NSImageOnly];
        [self setBordered:NO];
        
//        [self setTarget:self];
//        [self setAction:@selector(buttonPressed)];
        
        // Create text label for dock item, if there was a title set for the item
        if (itemTitle) {
            NSRect frameRect = NSMakeRect(0,0,155,21); // This will change based on the size you need
            self.label = [[NSTextField alloc] initWithFrame:frameRect];
            [self.label setTextColor:[NSColor whiteColor]];
            self.label.bezeled = NO;
            self.label.editable = NO;
            self.label.drawsBackground = NO;
            [self.label setFont:[NSFont boldSystemFontOfSize:14]];
            [self.label.cell setLineBreakMode:NSLineBreakByTruncatingMiddle];
            self.label.stringValue = itemTitle;
            NSSize dockItemLabelSize = [self.label intrinsicContentSize];
            [self.label setAlignment:NSCenterTextAlignment];
            CGFloat dockItemLabelWidth = dockItemLabelSize.width + 14;
            if (dockItemLabelWidth > 610) {
                dockItemLabelWidth = 610;
            }
            [self.label setFrameSize:NSMakeSize(dockItemLabelWidth, dockItemLabelSize.height + 3)];
            NSView *dockItemLabelView = [[NSView alloc] initWithFrame:self.label.frame];
            [dockItemLabelView addSubview:self.label];
            [dockItemLabelView setContentHuggingPriority:NSLayoutPriorityFittingSizeCompression-1.0 forOrientation:NSLayoutConstraintOrientationVertical];
            
            NSViewController *controller = [[NSViewController alloc] init];
            controller.view = dockItemLabelView;
            
            NSPopover *popover = [[NSPopover alloc] init];
            [popover setContentSize:dockItemLabelView.frame.size];
            [popover setContentViewController:controller];
            [popover setAppearance:NSPopoverAppearanceHUD];
            [popover setAnimates:NO];
            self.labelPopover = popover;
        }
    }
    return self;
}


// Create popup menu for dock item with a passed NSMenu
- (void)setSEBDockMenu:(NSMenu *)menu
{
//    [super setMenu:menu];
    [self setUsesSEBDockMenu:YES];
}


- (NSMenu *)SEBDockMenu
{
    return self.SEBDockMenu;
}


- (void)setUsesSEBDockMenu:(BOOL)useSEBDockMenu
{
    if (self.SEBDockMenuPopover == nil && useSEBDockMenu)
    {
        NSSize SEBDockMenuSize = [self.SEBDockMenu size];
        CGFloat SEBDockMenuWidth = SEBDockMenuSize.width + 14;
        if (SEBDockMenuWidth > 500) {
            SEBDockMenuWidth = 500;
        }
//        [[self.SEBDockMenu size] = NSMakeSize(SEBDockMenuWidth, SEBDockMenuSize.height + 3)];
        NSView *SEBDockMenuView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, SEBDockMenuSize.width, SEBDockMenuSize.height)];
        NSCell *SEBDockMenuCell = [[NSCell alloc] init];
        SEBDockMenuCell.menu = self.SEBDockMenu;
//        [SEBDockMenuView addSubview:SEBDockMenuCell];
//        [SEBDockMenuView setContentHuggingPriority:NSLayoutPriorityFittingSizeCompression-1.0 forOrientation:NSLayoutConstraintOrientationVertical];
//        
        NSViewController *controller = [[NSViewController alloc] init];
        controller.view = SEBDockMenuCell;
        
        NSPopover *popover = [[NSPopover alloc] init];
        [popover setContentSize:SEBDockMenuView.frame.size];
        [popover setContentViewController:controller];
        [popover setAppearance:NSPopoverAppearanceHUD];
        [popover setAnimates:NO];
        self.SEBDockMenuPopover = popover;
    }
    else if (self.SEBDockMenuPopover != nil && !useSEBDockMenu)
    {
        self.SEBDockMenuPopover = nil;
    }
}


- (BOOL)usesSEBDockMenu
{
    return (popUpCell != nil);
}


- (void)runPopUp:(NSEvent *)theEvent
{
    // Set the menu the popup will use
    [popUpCell setMenu:[self menu]];
    
    // and show it
    [popUpCell performClickWithFrame:[self bounds] inView:self];
    
    [self setNeedsDisplay: YES];
}


- (void)mouseDown:(NSEvent*)theEvent
{
    if ([self usesSEBDockMenu])
    {
        [self runPopUp:theEvent];
    }
    else
    {
        [super mouseDown:theEvent];
    }
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
[self createTrackingArea];

}


- (void)mouseEntered:(NSEvent *)theEvent
{
    [self.labelPopover showRelativeToRect:[self bounds] ofView:self preferredEdge:NSMaxYEdge];
}


- (void)mouseExited:(NSEvent *)theEvent
{
    [self.labelPopover close];
}


- (void)updateTrackingAreas
{
    [self removeTrackingArea:trackingArea];
    [self createTrackingArea];
    [super updateTrackingAreas]; // Needed, according to the NSView documentation
}


- (void) createTrackingArea
{
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:trackingArea];
    
    NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
    mouseLocation = [self convertPoint: mouseLocation
                              fromView: nil];
    
    if (NSPointInRect(mouseLocation, [self bounds])) {
            [self mouseEntered: nil];
        } else {
            [self mouseExited: nil];
        }
}
    
@end
