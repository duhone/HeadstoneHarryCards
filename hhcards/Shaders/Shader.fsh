//
//  Shader.fsh
//  hhcards
//
//  Created by Eric Duhon on 2/8/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
