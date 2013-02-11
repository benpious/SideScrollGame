//
//  SGViewController.m
//  SideScrollGame
//
//  Created by Benjamin Pious on 11/5/12.
//  Copyright (c) 2012 Benjamin Pious. All rights reserved.
//

#import "SGViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface SGViewController () {
    GLuint _program;
    GLuint _normalMappingProgram;
    GLuint triBuffer;
}

@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation SGViewController

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [_context release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    

    [self setupGL];
    
    CGRect screenSize = [[self view] frame];
    _engine = [[SGGameEngine alloc] initWithLevelPlist: @"levelt" ScreenSize: screenSize];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    
    [EAGLContext setCurrentContext:self.context];
    
    //enable transparency in textures
    glEnable (GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [self loadShaders];
    //[self loadNormalMappingShaders];
 
    // test stuff, delete when finished
    moving = NO;
    min = 5;
    currAction = idle;
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);

    
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glGenBuffers(1, &triBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, triBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 18, ((SGCharacter*)[[_engine characters] objectAtIndex:0]).vertexCoords, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    
    glBindVertexArrayOES(0);
        
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
            
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{    
    [_engine eventLoopCallBack];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    NSArray* objects = [_engine objectsToDraw];
    
    for (int i=0; i< [objects count]; i++) {
        NSObject<SGEntityProtocol>* current = [objects objectAtIndex:i];
        
        //turn off antialiasing of textures
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, current.textureCoords);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, current.vertexCoords);
            
        // Render the object with GLKit
        [current.effect prepareToDraw];
        
        glDrawArrays(GL_TRIANGLES, 0, 18);
        
        
        // Render the object again with ES2
        glUseProgram(_program);
                 
    }
    
    [objects release];

}

#pragma mark -  OpenGL ES 2 shader compilation
-(BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
        
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
        
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_program, ATTRIB_NORMAL, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;

}


- (BOOL)loadNormalMappingShaders
{
    GLuint vertShader, normFragShader;
    NSString *vertShaderPathname, *normFragShaderPathName;
    
    // Create shader program.
    _normalMappingProgram = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    
    // Create and compile normal mapping fragment shader.
    normFragShaderPathName = [[NSBundle mainBundle] pathForResource:@"NormalShader" ofType:@"fsh"];
    if (![self compileShader:&normFragShader type:GL_FRAGMENT_SHADER file:normFragShaderPathName]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_normalMappingProgram, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_normalMappingProgram, normFragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_normalMappingProgram, ATTRIB_VERTEX, "position");
    glBindAttribLocation(_normalMappingProgram, ATTRIB_NORMAL, "normal");
    // Link program.
    if (![self linkProgram:_normalMappingProgram]) {
        NSLog(@"Failed to link program: %d", _normalMappingProgram);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }

        if (normFragShader) {
            glDeleteShader(normFragShader);
            normFragShader = 0;
        }
        if (_normalMappingProgram) {
            glDeleteProgram(_normalMappingProgram);
            _normalMappingProgram = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }

    if (normFragShader) {
        glDetachShader(_program, normFragShader);
        glDeleteShader(normFragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark touch recognition methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    moving = YES;
    UITouch* aTouch = [touches anyObject];
    beginning = [aTouch locationInView:nil];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currAction = idle;
    [((SGCharacter*)[[_engine characters] objectAtIndex:0]) setNextAnimation:0];
    UITouch* aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:nil];

    [_engine applyTouchUpWithLocation: loc ];
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:nil];
    
    
    float deltaX = loc.x - beginning.x;
    float deltaY = loc.y - beginning.y;
    
    float angle;
    float radiansAngle;
    
    //does not work fix WRT the non-negative one
    if (deltaY == 0 || deltaX == 0) {
        
        angle = 90.0f;
        radiansAngle = GLKMathDegreesToRadians(90.0f);
    }
    
    else
    {
        angle = 270.0f + GLKMathRadiansToDegrees(atanf(fabsf(deltaX)/fabsf(deltaY)));
        radiansAngle = GLKMathDegreesToRadians(270.0f) + atanf(fabsf(deltaX)/fabsf(deltaY));
    }
    

    if (deltaY < 0 && deltaX > 0 ) {
        radiansAngle = GLKMathDegreesToRadians(270.0f) - atanf(fabsf(deltaX)/fabsf(deltaY));
        angle =  270.0f - GLKMathRadiansToDegrees(atanf(fabsf(deltaX)/fabsf(deltaY)));
    }
    
    if  (deltaY > 0 && deltaX > 0) {
        radiansAngle = GLKMathDegreesToRadians(90.0f) + atanf(fabsf(deltaX)/fabsf(deltaY));
        angle = 90.0f + GLKMathRadiansToDegrees(atanf(fabsf(deltaX)/fabsf(deltaY)));
    }
    
    if  (deltaY > 0 && deltaX < 0) {
        radiansAngle = GLKMathDegreesToRadians(90.0f) - atanf(fabsf(deltaX)/fabsf(deltaY));
        angle = 90.0f - GLKMathRadiansToDegrees( atanf(fabsf(deltaX)/fabsf(deltaY)));
    }
    
    [_engine applyJoystickMovewithAngle:angle XPos:beginning.x YPos:beginning.y Radians: radiansAngle Size: (CGSize) [[self view] frame].size ];
    
}


@end
