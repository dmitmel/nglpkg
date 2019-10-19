ng.module(
	"ng.wrap.gl",
	"ng.wrap.ffi"
)

--@> DOC.functions = "ng."
function ng.createGL(getProcAddress)
	--@> DOC.functions = nil
	--@: Creates an OpenGL binding object.
	--@: Note: The version of OpenGL this supports is "2.1 minus legacy stuff".
	--@: The "minus legacy stuff" requires the exact allowed subset to be documented.

	local ictx = {}

	--@> DOC.echo = true
	--@> ng.doc.section("Enums, Part I")
	-- Booleans
	ictx.GL_FALSE = 0
	ictx.GL_TRUE = 1

	-- Errors
	ictx.GL_NO_ERROR = 0
	ictx.GL_INVALID_ENUM = 0x500
	ictx.GL_INVALID_VALUE = 0x501
	ictx.GL_INVALID_OPERATION = 0x502
	ictx.GL_STACK_OVERFLOW = 0x503
	ictx.GL_STACK_UNDERFLOW = 0x504
	ictx.GL_OUT_OF_MEMORY = 0x505

	-- glGetString
	ictx.GL_VENDOR = 0x1F00
	ictx.GL_RENDERER = 0x1F01
	ictx.GL_VERSION = 0x1F02
	ictx.GL_EXTENSIONS = 0x1F03
	ictx.GL_SHADING_LANGUAGE_VERSION = 0x8B8C

	-- glClear
	ictx.GL_DEPTH_BUFFER_BIT = 0x100
	ictx.GL_ACCUM_BUFFER_BIT = 0x200
	ictx.GL_STENCIL_BUFFER_BIT = 0x400
	ictx.GL_COLOR_BUFFER_BIT = 0x4000
	ictx.GL_COLOUR_BUFFER_BIT = ictx.GL_COLOR_BUFFER_BIT
	--@> ng.doc.section("Enums, Part II")
	-- glEnable/glDisable
	ictx.GL_LINE_STIPPLE = 0xB24
	ictx.GL_CULL_FACE = 0xB44
	ictx.GL_DEPTH_TEST = 0x0B71
	ictx.GL_STENCIL_TEST = 0xB90
	ictx.GL_ALPHA_TEST = 0x0BC0
	ictx.GL_BLEND = 0x0BE2
	ictx.GL_SCISSOR_TEST = 0xC11
	ictx.GL_CLIP_PLANE0 = 0x3000
	ictx.GL_VERTEX_PROGRAM_POINT_SIZE = 0x8642
	ictx.GL_VERTEX_PROGRAM_TWO_SIDE = 0x8643

	-- glBindBuffer
	ictx.GL_ARRAY_BUFFER = 0x8892
	ictx.GL_ELEMENT_ARRAY_BUFFER = 0x8893

	-- Buffer types
	ictx.GL_STATIC_DRAW = 0x88E4
	ictx.GL_DYNAMIC_DRAW = 0x88E8

	-- Primitives
	ictx.GL_POINTS = 0
	ictx.GL_LINES = 1
	ictx.GL_LINE_STRIP = 2
	ictx.GL_LINE_LOOP = 3
	ictx.GL_TRIANGLES = 4
	ictx.GL_TRIANGLE_STRIP = 5
	ictx.GL_TRIANGLE_FAN = 6
	ictx.GL_QUADS = 7
	ictx.GL_QUAD_STRIP = 8
	ictx.GL_POLYGON = 9

	--@> ng.doc.section("Enums, Part III")
	-- glCreateShader
	ictx.GL_FRAGMENT_SHADER = 0x8B30
	ictx.GL_VERTEX_SHADER = 0x8B31

	-- shader/program vars
	ictx.GL_COMPILE_STATUS = 0x8B81
	ictx.GL_INFO_LOG_LENGTH = 0x8B84
	ictx.GL_LINK_STATUS = 0x8B82

	-- glBindTexture
	ictx.GL_TEXTURE0 = 0x84C0

	ictx.GL_FRONT = 0x404
	ictx.GL_BACK = 0x405
	ictx.GL_FRONT_AND_BACK = 0x408

	ictx.GL_CW = 0x900
	ictx.GL_CCW = 0x901

	ictx.GL_TEXTURE_1D = 0xDE0
	ictx.GL_TEXTURE_2D = 0xDE1
	ictx.GL_TEXTURE_3D = 0x806F
	ictx.GL_TEXTURE_CUBE_MAP = 0x8513
	ictx.GL_TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515
	ictx.GL_TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516
	ictx.GL_TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517
	ictx.GL_TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518
	ictx.GL_TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519
	ictx.GL_TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A

	--@> ng.doc.section("Enums, Part IV")
	-- Texture Parameters
	ictx.GL_TEXTURE_MAG_FILTER = 0x2800
	ictx.GL_TEXTURE_MIN_FILTER = 0x2801
	ictx.GL_TEXTURE_WRAP_S = 0x2802
	ictx.GL_TEXTURE_WRAP_T = 0x2803
	ictx.GL_TEXTURE_WRAP_R = 0x8072
	ictx.GL_TEXTURE_MIN_LOD = 0x813A
	ictx.GL_TEXTURE_MAX_LOD = 0x813B
	ictx.GL_TEXTURE_BASE_LEVEL = 0x813C
	ictx.GL_TEXTURE_MAX_LEVEL = 0x813D
	ictx.GL_TEXTURE_PRIORITY = 0x8066
	-- COMPARE_MODE/COMPARE_FUNC seem to be texenv
	ictx.GL_GENERATE_MIPMAP = 0x8191

	ictx.GL_ZERO = 0
	ictx.GL_ONE = 1
	ictx.GL_SRC_COLOR = 0x300
	ictx.GL_ONE_MINUS_SRC_COLOR = 0x301
	ictx.GL_SRC_ALPHA = 0x302
	ictx.GL_ONE_MINUS_SRC_ALPHA = 0x303
	ictx.GL_DST_ALPHA = 0x304
	ictx.GL_ONE_MINUS_DST_ALPHA = 0x305
	ictx.GL_DST_COLOR = 0x306
	ictx.GL_ONE_MINUS_DST_COLOR = 0x307
	ictx.GL_SRC_ALPHA_SATURATE = 0x308
	ictx.GL_CONSTANT_COLOR = 0x8001
	ictx.GL_ONE_MINUS_CONSTANT_COLOR = 0x8002
	ictx.GL_CONSTANT_ALPHA = 0x8003
	ictx.GL_ONE_MINUS_CONSTANT_ALPHA = 0x8004
	-- where 'COLOR' is mentioned, there are 'COLOUR' aliases
	--@> DOC.echo = false
	ictx.GL_SRC_COLOUR = ictx.GL_SRC_COLOR
	ictx.GL_ONE_MINUS_SRC_COLOUR = ictx.GL_ONE_MINUS_SRC_COLOR
	ictx.GL_DST_COLOUR = ictx.GL_DST_COLOR
	ictx.GL_ONE_MINUS_DST_COLOUR = ictx.GL_ONE_MINUS_DST_COLOR
	ictx.GL_CONSTANT_COLOUR = ictx.GL_CONSTANT_COLOR
	ictx.GL_ONE_MINUS_CONSTANT_COLOUR = ictx.GL_ONE_MINUS_CONSTANT_COLOR
	--@> DOC.echo = true
	--@> ng.doc.section("Enums, Part V")
	ictx.GL_FUNC_ADD = 0x8006
	ictx.GL_FUNC_SUBTRACT = 0x800A
	ictx.GL_FUNC_REVERSE_SUBTRACT = 0x800B
	ictx.GL_MIN = 0x8007
	ictx.GL_MAX = 0x8008

	ictx.GL_NEVER = 0x200
	ictx.GL_LESS = 0x201
	ictx.GL_EQUAL = 0x202
	ictx.GL_LEQUAL = 0x203
	ictx.GL_GREATER = 0x204
	ictx.GL_NOTEQUAL = 0x205
	ictx.GL_GEQUAL = 0x206
	ictx.GL_ALWAYS = 0x207

	ictx.GL_POLYGON_OFFSET_FILL = 0x8037
	ictx.GL_POLYGON_OFFSET_LINE = 0x2A02
	ictx.GL_POLYGON_OFFSET_POINT = 0x2A01

	ictx.GL_KEEP = 0x1E00
	ictx.GL_REPLACE = 0x1E01
	ictx.GL_INCR = 0x1E02
	ictx.GL_INCR_WRAP = 0x8507
	ictx.GL_DECR = 0x1E03
	ictx.GL_DECR_WRAP = 0x8508
	ictx.GL_INVERT = 0x150A

	--@> ng.doc.section("Enums, Part VI")
	ictx.GL_NEAREST = 0x2600
	ictx.GL_LINEAR = 0x2601
	ictx.GL_NEAREST_MIPMAP_NEAREST = 0x2700
	ictx.GL_LINEAR_MIPMAP_NEAREST = 0x2701
	ictx.GL_NEAREST_MIPMAP_LINEAR = 0x2702
	ictx.GL_LINEAR_MIPMAP_LINEAR = 0x2703

	ictx.GL_CLAMP = 0x2900
	ictx.GL_CLAMP_TO_BORDER = 0x812D
	ictx.GL_CLAMP_TO_EDGE = 0x812F
	ictx.GL_MIRRORED_REPEAT = 0x8370
	ictx.GL_REPEAT = 0x2901

	ictx.GL_RGB = 0x1907
	ictx.GL_RGBA = 0x1908
	ictx.GL_BGR = 0x80E0
	ictx.GL_BGRA = 0x80E1

	ictx.GL_BYTE = 0x1400
	ictx.GL_UNSIGNED_BYTE = 0x1401
	ictx.GL_SHORT = 0x1402
	ictx.GL_UNSIGNED_SHORT = 0x1403
	ictx.GL_INT = 0x1404
	ictx.GL_UNSIGNED_INT = 0x1405
	ictx.GL_FLOAT = 0x1406
	ictx.GL_2_BYTES = 0x1407
	ictx.GL_3_BYTES = 0x1408
	ictx.GL_4_BYTES = 0x1409
	ictx.GL_DOUBLE = 0x140A

	ictx.GL_UNSIGNED_INT_8_8_8_8 = 0x8035
	ictx.GL_UNSIGNED_INT_8_8_8_8_REV = 0x8367
	--@> ng.doc.section("Enums, Part VII")
	-- all the EXT_framebuffer_object things
	ictx.GL_FRAMEBUFFER_EXT = 0x8D40
	ictx.GL_RENDERBUFFER_EXT = 0x8D41
	ictx.GL_STENCIL_INDEX1_EXT = 0x8D46
	ictx.GL_STENCIL_INDEX4_EXT = 0x8D47
	ictx.GL_STENCIL_INDEX8_EXT = 0x8D48
	ictx.GL_STENCIL_INDEX16_EXT = 0x8D49
	ictx.GL_COLOR_ATTACHMENT0_EXT = 0x8CE0
	ictx.GL_COLOUR_ATTACHMENT0_EXT = ictx.GL_COLOR_ATTACHMENT0_EXT
	-- omitted: 15 other constants
	ictx.GL_DEPTH_ATTACHMENT_EXT = 0x8D00
	ictx.GL_STENCIL_ATTACHMENT_EXT = 0x8D20
	-- not actually directly part of the extension, but it's sort of there.
	ictx.GL_STENCIL_INDEX = 0x1901
	ictx.GL_DEPTH_COMPONENT = 0x1902
	--@> DOC.echo = false

	--- Gets a function pointer according to the given signature.
	local function f(rt, n, ...)
		local tp = rt .. " (*) ("
		local args = {...}
		for i = 1, #args do
			if i ~= 1 then
				tp = tp .. ", "
			end
			tp = tp .. args[i]
		end
		tp = tp .. ")"
		ictx[n] = ffi.cast(tp, getProcAddress(n))
	end

	--@> ng.doc.section("Meta")
	--@> DOC.echo = true
	f("void", "glFlush")
	--  Flushes all buffers, guaranteeing that all GL commands will be done.
	f("void", "glFinish")
	--  Ensures all GL commands are done before it returns.
	f("int", "glGetError")
	--  Gets the current error, resetting it to GL_NO_ERROR.
	f("char *", "glGetString", "int")
	-- property
	--  Gets a static string.
	--  property is one of: GL_VENDOR, GL_RENDERER, GL_VERSION, GL_EXTENSIONS, GL_SHADING_LANGUAGE_VERSION

	--@> ng.doc.section("Renderbuffers")
	f("void", "glGenRenderbuffersEXT", "int", "unsigned int *")
	-- n buffers
	--  Generate a set of renderbuffer objects.
	--  Note that renderbuffers act as no-output *substitutes* for textures,
	--   and are not required if all attachments are to be textures.
	f("void", "glBindRenderbufferEXT", "int", "unsigned int")
	-- target renderbuffer
	--  Binds a renderbuffer to a target, which must be GL_RENDERBUFFER_EXT.
	f("void", "glDeleteRenderbuffersEXT", "int", "unsigned int *")
	-- n buffers
	--  Delete a set of renderbuffer objects.

	--@> ng.doc.section("Framebuffers")
	f("void", "glGenFramebuffersEXT", "int", "unsigned int *")
	-- n buffers
	--  Generate a set of framebuffer objects.
	f("void", "glBindFramebufferEXT", "int", "unsigned int")
	-- target framebuffer
	--  Binds a framebuffer to a target, which must be GL_FRAMEBUFFER_EXT.
	--  This changes the target of all drawing functions.
	--  The framebuffer ID 0 is the primary framebuffer.
	f("void", "glDeleteFramebuffersEXT", "int", "unsigned int *")
	-- n buffers
	--  Delete a set of framebuffer objects.

	f("void", "glRenderbufferStorageEXT", "int", "int", "int", "int")
	-- target iformat w h
	--  Sets up a renderbuffer. The target must be GL_RENDERBUFFER_EXT.
	--  The iformat must be one of:
	--  GL_RGB, GL_RGBA, GL_DEPTH_COMPONENT, GL_STENCIL_INDEX.
	--  (It is possible there are other formats - documentation is unclear.)
	f("void", "glFramebufferRenderbufferEXT", "int", "int", "int", "unsigned int")
	-- target1 at target2 rb
	--  Attaches or detaches a renderbuffer and framebuffer.
	--  target1 and target2 must be GL_FRAMEBUFFER_EXT and GL_RENDERBUFFER_EXT respectively.
	--  at is one of:
	--  GL_COLO[U]R_ATTACHMENT0_EXT + n, GL_DEPTH_ATTACHMENT_EXT, or GL_STENCIL_ATTACHMENT_EXT.
	--  rb is a renderbuffer ID, or 0.
	--  Any existing renderbuffer is detached.
	--  If rb is not 0, then that renderbuffer is attached.

	--@> ng.doc.section("Framebuffers II")
	f("void", "glFramebufferTexture1DEXT", "int", "int", "int", "unsigned int", "int")
	-- target1 at target2 tex level
	--  Attaches a given mipmap level of a texture to a framebuffer attachment.
	--  This works similarly to glFramebufferRenderbufferEXT, with anything attached on the same attachment being detached.
	--  target1 must be GL_FRAMEBUFFER_EXT, while target2 must be a valid target for the texture (this has importance with cube-map textures).
	--  at must be a valid attachment as documented in glFramebufferRenderbufferEXT.
	--  tex must be 0 (to leave detached) or a valid texture.
	f("void", "glFramebufferTexture2DEXT", "int", "int", "int", "unsigned int", "int")
	-- target1 at target2 tex level
	--  See glFramebufferTexture1DEXT.
	f("void", "glFramebufferTexture3DEXT", "int", "int", "int", "unsigned int", "int", "int")
	-- target1 at target2 tex level z
	--  See glFramebufferTexture1DEXT, but as this is part of 2D rendering, a z-offset within the texture is specified as a target.
	f("void", "glReadPixels", "int", "int", "int", "int", "unsigned int", "unsigned int", "void *")
	-- x y width height iformat type data
	-- 'iformat' is roughly the same as glRenderbufferStorageEXT's parameter
	-- 'type' is roughly the sort of thing accepted by the TexImage type

	--@> ng.doc.section("Drawing Control")
	f("void", "glEnable", "int")
	-- cap
	--  Enables a 'server-side' OpenGL capability.
	--   One of: GL_ALPHA_TEST, GL_DEPTH_TEST, GL_STENCIL_TEST, GL_SCISSOR_TEST, GL_BLEND, GL_CLIP_PLANE0 + x,
	--   GL_VERTEX_PROGRAM_POINT_SIZE, GL_VERTEX_PROGRAM_TWO_SIDE,
	--   GL_LINE_STIPPLE, GL_CULL_FACE
	f("void", "glDisable", "int")
	-- cap
	--  Disables a 'server-side' OpenGL capability. See glEnable for a list.

	f("void", "glAlphaFunc", "int", "float")
	-- func ref
	--  Sets the alpha test function to one of
	--  GL_NEVER, GL_LESS, GL_EQUAL, GL_LEQUAL, GL_GREATER, GL_NOTEQUAL, GL_GEQUAL, GL_ALWAYS

	f("void", "glStencilFunc", "int", "int", "unsigned int")
	-- func ref andmask
	--  See glStencilFuncSeparate with a target of GL_FRONT_AND_BACK.
	f("void", "glStencilFuncSeparate", "int", "int", "int", "unsigned int")
	-- target func ref andmask
	--  Updates one of: GL_FRONT, GL_BACK, or both (GL_FRONT_AND_BACK) stencil test functions to one of the comparison operators (see glAlphaFunc)

	--@> ng.doc.section("Drawing Control II")
	f("void", "glStencilMask", "unsigned int")
	-- mask
	--  See glStencilMaskSeparate with a target of GL_FRONT_AND_BACK.
	f("void", "glStencilMaskSeparate", "int", "unsigned int")
	-- target mask
	--  Updates one of: GL_FRONT, GL_BACK, or both (GL_FRONT_AND_BACK) stencil masks, controlling which bits can be written to.

	f("void", "glStencilOp", "int", "int", "int")
	-- sfail dpfail dppass
	--  See glStencilOpSeparate, with target GL_FRONT_AND_BACK.
	f("void", "glStencilOpSeparate", "int", "int", "int", "int")
	-- face sfail dpfail dppass
	--  Sets the stencil write operation.
	--  sfail/dpfail/dppass are the different operations for different cases.
	--  They can be one of: GL_KEEP, GL_ZERO, GL_REPLACE, GL_INCR, GL_INCR_WRAP, GL_DECR, GL_DECR_WRAP, and GL_INVERT.

	f("void", "glDepthMask", "int")
	-- flag
	--  Enables (!= 0) or disables (== 0) depth writing.
	f("void", "glColorMask", "int", "int", "int", "int")
	-- r g b a
	--  Enables (!= 0) or disables (== 0) colour writing to various channels.
	--  Can also be referred to as glColourMask.
	ictx.glColourMask = ictx.glColorMask

	--@> ng.doc.section("Drawing Control III")
	f("void", "glBlendFunc", "int", "int")
	-- sfactor dfactor
	--  Sets the source & destination blending factors. Factors can be any of
	--  GL_ZERO, GL_ONE,
	--  GL_SRC_COLO[U]R, GL_DST_COLO[U]R, GL_SRC_ALPHA, GL_DST_ALPHA,
	--  GL_ONE_MINUS_SRC_COLO[U]R, GL_ONE_MINUS_DST_COLO[U]R, GL_ONE_MINUS_SRC_ALPHA, GL_ONE_MINUS_DST_ALPHA,
	--  GL_CONSTANT_COLO[U]R, GL_ONE_MINUS_CONSTANT_COLO[U]R, GL_CONSTANT_ALPHA, GL_ONE_MINUS_CONSTANT_ALPHA, GL_SRC_ALPHA_SATURATE
	f("void", "glBlendFuncSeparate", "int", "int", "int", "int")
	-- rgbs rgbd as ad
	--  Sets the source & destination blending factors for both RGB and alpha.
	--  See glBlendFunc for available factors.
	f("void", "glBlendColor", "float", "float", "float", "float")
	-- r g b a
	--  Sets the blending constant colour. The RGBA values given here are from 0 to 1.
	--  Can also be referred to as glBlendColour.
	ictx.glBlendColour = ictx.glBlendColor
	f("void", "glBlendEquation", "int")
	-- mode
	--  Sets the blending equation to one of: GL_FUNC_ADD, GL_FUNC_SUBTRACT, GL_FUNC_REVERSE_SUBTRACT, GL_MIN, GL_MAX.

	--@> ng.doc.section("Drawing Control IV")
	f("void", "glCullFace", "int")
	-- mode
	--  Sets the culling mode to one of: GL_FRONT, GL_BACK, GL_FRONT_AND_BACK.
	--  GL_BACK is the initial value.
	--  You need to enable GL_CULL_FACE to use this.
	f("void", "glFrontFace", "int")
	-- mode
	--  Sets the definition of 'front face' to one of: GL_CW, GL_CCW.
	--  GL_CW is the initial value.
	f("void", "glLineWidth", "float")
	-- width
	--  Sets the line width.
	f("void", "glLineStipple", "int", "unsigned short")
	-- factor pattern
	--  Sets a line stipple pattern. You need to enable GL_LINE_STIPPLE to use this.
	f("void", "glViewport", "int", "int", "int", "int")
	-- x y width height
	--  Sets the scaling used from normalized (-1 to 1) coordinates to window coordinates. Under usual circumstances you should set this to (0, 0, w, h).
	f("void", "glPolygonOffset", "float", "float")
	-- scale units
	--  Alters polygon depth by some amount before the depth test is performed.
	f("void", "glDepthRange", "double", "double")
	-- near far
	--  Sets the range of depth. Depth internally in OpenGL spans -1 (near) to 1 (far), but must be mapped to a different (0 to 1) range for putting into the depth buffer. This changes that range.
	f("void", "glScissor", "int", "int", "int", "int")
	-- x y width height
	--  Sets the scissor rectangle. You need to enable GL_SCISSOR_TEST to use this.

	--@> ng.doc.section("Attachment Control")
	f("void", "glDrawBuffer", "int")
	-- buffer
	--  Sets one attachment to output fragment colour to. This is a property of the target framebuffer.
	--  While there are many specified valid values, the relevant ones are dependent on target.
	--  For framebuffer 0, GL_NONE, GL_FRONT and GL_BACK are the targets of importance.
	--  Note that in this case, glDrawBuffers should not be used.
	--  For user-created framebuffers, GL_NONE and GL_COLO[U]R_ATTACHMENT0_EXT + n are valid where those attachments exist.
	f("void", "glDrawBuffers", "int", "const int *")
	-- count buffers
	--  Sets the attachments to output fragment colour to. For further information, see glDrawBuffer.

	--@> ng.doc.section("Clear")
	f("void", "glClear", "unsigned int")
	-- bufferBits
	--  Clears the indicated buffers (an OR of GL_*_BUFFER_BIT) to the corresponding current clear values.
	f("void", "glClearColor", "float", "float", "float", "float")
	-- r g b a
	--  Sets the colour clear value. The RGBA values given here are from 0 to 1.
	--  Can also be referred to as glClearColour.
	ictx.glClearColour = ictx.glClearColor
	f("void", "glClearDepth", "double")
	-- depth
	--  Sets the depth clear value. Must be in the 0 to 1 range of depth values.
	f("void", "glClearAccum", "float", "float", "float", "float")
	-- red green blue alpha
	--  Sets the accum clear value. The RGBA values given here are from 0 to 1.
	f("void", "glClearStencil", "int")
	-- s
	--  Sets the stencil clear value.

	--@> ng.doc.section("Shaders")
	f("unsigned int", "glCreateShader", "int")
	-- type
	--  Creates a shader object.
	--  One of: GL_VERTEX_SHADER, GL_FRAGMENT_SHADER
	f("void", "glShaderSource", "unsigned int", "int", "const char **", "const int *")
	-- shader count strings length
	--  Provides source for a shader object.
	f("void", "glCompileShader", "unsigned int")
	-- shader
	--  Compiles a shader object.
	f("void", "glGetShaderInfoLog", "unsigned int", "int", "int *", "char *")
	-- shader maxLength length infoLog
	--  Get an info log for a shader.
	f("void", "glGetShaderiv", "unsigned int", "int", "int *")
	-- shader parameter result
	--  Gets a shader object parameter. One of: GL_COMPILE_STATUS, GL_INFO_LOG_LENGTH
	f("void", "glAttachShader", "unsigned int", "unsigned int")
	-- program shader
	--  Attach a shader object.
	f("void", "glDeleteShader", "unsigned int")
	-- shader
	--  Deletes a shader object.

	--@> ng.doc.section("Shader Programs")
	f("unsigned int", "glCreateProgram")
	--  Creates a shader program.
	f("void", "glLinkProgram", "unsigned int")
	-- program
	--  Links a program object.
	f("void", "glUseProgram", "unsigned int")
	-- program
	--  Use a program object.
	f("void", "glGetProgramInfoLog", "unsigned int", "int", "int *", "char *")
	-- program maxLength length infoLog
	--  Get an info log for a program.
	f("void", "glGetProgramiv", "unsigned int", "int", "int *")
	-- program parameter result
	--  Gets a program object parameter. One of: GL_LINK_STATUS, GL_INFO_LOG_LENGTH
	f("void", "glDeleteProgram", "unsigned int")
	-- program
	--  Deletes a shader program.

	f("int", "glGetAttribLocation", "unsigned int", "const char *")
	-- program name
	--  Gets a vertex attribute index for a given program & attribute name.
	f("int", "glGetUniformLocation", "unsigned int", "const char *")
	-- program name
	--  Gets a uniform index for a given program & uniform name.

	--@> ng.doc.section("Shader Program Uniforms")
	--@> DOC.echo = false
	local function vau(pfx, tp, tpc, tpl)
		f("void", "gl" .. pfx .. "1" .. tpc, tpl, tp)
		-- location v0
		f("void", "gl" .. pfx .. "2" .. tpc, tpl, tp, tp)
		-- location v0 v1
		f("void", "gl" .. pfx .. "3" .. tpc, tpl, tp, tp, tp)
		-- location v0 v1 v2
		f("void", "gl" .. pfx .. "4" .. tpc, tpl, tp, tp, tp, tp)
		-- location v0 v1 v2 v3
	end
	local function vav(pfx, tp, tpc, tpl)
		-- location count value
		f("void", "gl" .. pfx .. "1" .. tpc .. "v", tpl, "int", tp)
		f("void", "gl" .. pfx .. "2" .. tpc .. "v", tpl, "int", tp)
		f("void", "gl" .. pfx .. "3" .. tpc .. "v", tpl, "int", tp)
		f("void", "gl" .. pfx .. "4" .. tpc .. "v", tpl, "int", tp)
	end
	local function vax(pfx, tp, tpc, tpl)
		-- location value
		f("void", "gl" .. pfx .. "1" .. tpc .. "v", tpl, tp)
		f("void", "gl" .. pfx .. "2" .. tpc .. "v", tpl, tp)
		f("void", "gl" .. pfx .. "3" .. tpc .. "v", tpl, tp)
		f("void", "gl" .. pfx .. "4" .. tpc .. "v", tpl, tp)
	end
	--@> DOC.echo = true
	--? Sets a float or vector uniform.
	vau("Uniform", "float", "f", "int")
	vau("Uniform", "int", "i", "int")

	vav("Uniform", "const float *", "f", "int")
	vav("Uniform", "const int *", "i", "int")

	--? Sets a matrix uniform.
	-- location count transpose value
	f("void", "glUniformMatrix2fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix3fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix4fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix2x3fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix2x4fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix3x2fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix3x4fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix4x2fv", "int", "int", "int", "const float *")
	--=
	f("void", "glUniformMatrix4x3fv", "int", "int", "int", "const float *")
	--=

	--@> ng.doc.section("Textures")
	f("void", "glGenTextures", "int", "unsigned int *")
	-- n buffers
	--  Generate a set of texture objects.
	f("void", "glBindTexture", "int", "unsigned int")
	-- target buffer
	--  Bind a texture to one of: GL_TEXTURE_1D, GL_TEXTURE_2D, GL_TEXTURE_3D, GL_TEXTURE_CUBE_MAP
	f("void", "glDeleteTextures", "int", "unsigned int *")
	-- n buffers
	--  Delete a set of texture objects.
	--  Need to handle the other texture things
	f("void", "glActiveTexture", "int")
	-- textureUnit
	--  Set the active texture unit, which must be GL_TEXTURE0 + the texture unit number.
	f("void", "glTexImage1D", "int", "int", "int", "int", "int", "int", "int", "void *")
	-- target level internalFormat width border format type data
	--  Sets up a 1D texture. To actually use it you'll need to set some texture parameters.
	f("void", "glTexImage2D", "int", "int", "int", "int", "int", "int", "int", "int", "void *")
	-- target level internalFormat width height border format type data
	--  Sets up a 2D texture. To actually use it you'll need to set some texture parameters.
	f("void", "glTexImage3D", "int", "int", "int", "int", "int", "int", "int", "int", "int", "void *")
	-- target level internalFormat width height depth border format type data
	--  Sets up a 3D texture. To actually use it you'll need to set some texture parameters.
	--@> ng.doc.section("Texture Parameters")
	f("void", "glTexParameteri", "int", "int", "int")
	-- target prop value
	--  Sets a texture parameter. Can be one of: GL_TEXTURE_MIN_FILTER, GL_TEXTURE_MAG_FILTER, GL_TEXTURE_MIN_LOD, GL_TEXTURE_MAX_LOD, GL_TEXTURE_BASE_LEVEL, GL_TEXTURE_MAX_LEVEL, GL_TEXTURE_WRAP_S, GL_TEXTURE_WRAP_T, GL_TEXTURE_WRAP_R, GL_TEXTURE_PRIORITY, GL_TEXTURE_COMPARE_MODE, GL_TEXTURE_COMPARE_FUNC, GL_DEPTH_TEXTURE_MODE, GL_GENERATE_MIPMAP
	f("void", "glTexParameterf", "int", "int", "float")
	-- target prop value
	--  Sets a texture parameter. See glTexParameteri for available parameters.
	--@> ng.doc.section("Textures II")
	f("void", "glGenerateMipmapEXT", "int")
	-- target
	--  Generates the mipmaps for a texture.
	f("void", "glCopyTexImage1D", "int", "int", "int", "int", "int", "int", "int")
	-- target level internalFormat x y width border
	--  Sets up a 1D texture from the framebuffer. To actually use it you'll need to set some texture parameters.
	f("void", "glCopyTexImage2D", "int", "int", "int", "int", "int", "int", "int", "int")
	-- target level internalFormat x y width height border
	--  Sets up a 2D texture from the framebuffer. To actually use it you'll need to set some texture parameters.

	--@> ng.doc.section("Buffers")
	f("void", "glGenBuffers", "int", "unsigned int *")
	-- n buffers
	--  Generate a set of buffer objects.
	f("void", "glBindBuffer", "int", "unsigned int")
	-- target buffer
	--  Bind a buffer a target, one of: GL_ARRAY_BUFFER, GL_ELEMENT_ARRAY_BUFFER.
	f("void", "glDeleteBuffers", "int", "unsigned int *")
	-- n buffers
	--  Delete a set of buffer objects.

	f("void", "glBufferData", "int", "ptrdiff_t", "const void *", "int")
	-- target size data usage
	--  Sets up a buffer. If data is null, the data is uninitialized.
	--  Usage can be one of GL_STATIC_DRAW, GL_DYNAMIC_DRAW.
	-- glMapBuffer/glUnmapBuffer too slow to be practical last I checked

	--@> ng.doc.section("Vertex Attributes")
	f("void", "glEnableVertexAttribArray", "unsigned int")
	-- index
	--  Enable a vertex attribute array. Note that 0 is vertex position.
	f("void", "glVertexAttribPointer", "unsigned int", "int", "int", "int", "int", "const void *")
	-- index size type normalized stride pointer
	--  Set a vertex attribute pointer.
	--  If any non-zero buffer is bound, then the pointer is set there - otherwise it points into memory.
	--  size is the amount of components per vector (1 to 4).
	--  Type can be one of: GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT, GL_UNSIGNED_SHORT, GL_INT, GL_UNSIGNED_INT, GL_FLOAT, GL_DOUBLE.
	--  Normalized enables automatic normalization of the vectors.
	--  Stride is the distance between vectors. A stride of 0 is replaced with the size of a vector.
	--  Pointer is the offset in memory or in the buffer (as appropriate) to read from.
	f("void", "glDisableVertexAttribArray", "unsigned int")
	-- index
	--  Disable a vertex attribute array. Note that 0 is vertex position.

	--@> ng.doc.section("Drawing")
	f("void", "glDrawArrays", "int", "int", "int")
	-- mode first count
	--  Draws primitives from vertex attribute arrays.
	f("void", "glDrawElements", "int", "int", "int", "void *")
	-- mode first count alwaysnull
	--  Draws primitives from vertex attribute arrays, with ordering from the GL_ELEMENT_ARRAY_BUFFER.
	--  alwaysnull must be always null.
	--  This is the Mac OS X friendly subset - see:
	--  https://people.eecs.ku.edu/~jrmiller/Courses/672/InClass/3DModeling/glDrawElements.html
	--@> DOC.echo = false
	return ictx
end
