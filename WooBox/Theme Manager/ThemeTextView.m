//
//  ThemeTextView.m

#import "ThemeManager.h"
#import "ThemeTextView.h"

@implementation ThemeTextView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:ThemeManagerDidChangeThemes object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyTheme];
}

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    @catch (NSException *exception) {
        // do nothing, only unregistering self from notifications
    }
}


#pragma mark -
#pragma mark - apply theme

- (void)applyTheme {
    UIFont *font = nil;
    if (_type == 0) {
        font = [[ThemeManager sharedManager] fontForKey:@"font1" withSizeKey:@"fSize2"];
    }
    else if ( _type == 2) {
        font = [[ThemeManager sharedManager] fontForKey:@"font0" withSizeKey:@"fSize2"];
    }
    else if (_type == 1 || _type == 3) {
        font = [[ThemeManager sharedManager] fontForKey:@"font1" withSizeKey:@"fSize2"];
    }
    self.font = font;
    
    UIColor *textColor, *background = nil;
    
    if (_type == 0 || _type == 1) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color1"];
//        background = [[ThemeManager sharedManager] colorForKey:@"background"];
    }
    else if (_type == 2) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color2"];
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColor.lightGrayColor.CGColor;
        self.layer.masksToBounds = YES;
        //        background = [[ThemeManager sharedManager] colorForKey:@"background"];
    }
    self.textColor = textColor;
//    self.backgroundColor = background;
}


#pragma mark -
#pragma mark - set observer for change theme

- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}

@end
