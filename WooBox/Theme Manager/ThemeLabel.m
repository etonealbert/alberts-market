//
//  ThemeLabel.m

#import "ThemeLabel.h"

@implementation ThemeLabel


#pragma mark -
#pragma mark - init methods

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
    if(_type == 0 || _type == 22) {
        font = [[ThemeManager sharedManager] fontForKey:@"font0" withSizeKey:@"fSize4"];
    }
    if (_type == 1 || _type == 2 || _type == 10) {
        font = [[ThemeManager sharedManager] fontForKey:@"font1" withSizeKey:@"fSize2"];
    }
    else if (_type == 3) {
        font = [[ThemeManager sharedManager] fontForKey:@"font0" withSizeKey:@"fSize7"];
    }
    else if (_type == 4 || _type == 7) {
        font = [[ThemeManager sharedManager] fontForKey:@"font2" withSizeKey:@"fSize2"];
    }
    else if (_type == 5) {
        font = [[ThemeManager sharedManager] fontForKey:@"font2" withSizeKey:@"fSize3"];
    }
    else if (_type == 6) {
        font = [[ThemeManager sharedManager] fontForKey:@"font2" withSizeKey:@"fSize4"];
    }
    else if (_type == 8) {
        font = [[ThemeManager sharedManager] fontForKey:@"font1" withSizeKey:@"fSize1"];
    }
    else if (_type == 9 ||_type == 11 ||_type == 12 || _type == 15) {
        font = [[ThemeManager sharedManager] fontForKey:@"font2" withSizeKey:@"fSize3"];
    }
    else if (_type == 10 || _type == 13 || _type == 14 || _type == 17 || _type == 18 || _type == 19) {
        font = [[ThemeManager sharedManager] fontForKey:@"font1" withSizeKey:@"fSize2"];
    }
    else if (_type == 16) {
        font = [[ThemeManager sharedManager] fontForKey:@"font0" withSizeKey:@"fSize2"];
    }
    else if (_type == 21) {
        font = [[ThemeManager sharedManager] fontForKey:@"font1" withSizeKey:@"fSize0"];
    }
    self.font = font;
    
    UIColor *textColor = nil;
    if (_type == 0){
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color2"];
    }
    if (_type == 1 || _type == 3 || _type == 4 || _type == 6 || _type == 7 || _type == 9 || _type == 11 || _type == 12 || _type == 14) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color1"];
    }
    else if (_type == 2 || _type == 8) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"color4"];
    }
    else if (_type == 3) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color2"];
    }
    else if (_type == 5) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"];
    }
    else if ( _type == 10|| _type == 13) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"color9"];
    }
    else if ( _type == 12 ) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Primary_Default_Color"];
    }
    else if (_type == 13 ) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"color6"];
    }
    else if (_type == 15 ) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"background"];
    }
    else if (_type == 16 ) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"color8"];
    }
    else if (_type == 18) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"Secondary_Color1"];
    }
    else if (_type == 19) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"pColor1"];
    }
    else if (_type == 21 || _type == 22) {
        textColor = [[ThemeManager sharedManager] colorForKey:@"textColorSecondary"];
    }

    [self setTextColor:textColor];
    
    UIColor *backgroundColor = nil;
    if (_type == 20) {
        self.layer.cornerRadius = self.frame.size.height/2;
        self.layer.masksToBounds = YES;
    }
    
    [self setBackgroundColor:backgroundColor];
}

#pragma mark -
#pragma mark - set observer for change theme

- (void)themeDidChangeNotification:(NSNotification *)notification {
    [self applyTheme];
}
@end
