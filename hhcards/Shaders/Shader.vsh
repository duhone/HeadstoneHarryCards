//
//  Shader.vsh
//  hhcards
//
//  Created by Eric Duhon on 2/8/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate) / 2.0;

    colorVarying = color;
}
