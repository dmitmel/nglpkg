ng.module(
	"ng.lib.app2d.draw",
	"ng.lib.app2d.base",
	"ng.lib.app2d.sdlgl",
	"ng.wrap.sdl2.structs",
	"ng.wrap.ffi",
	"ng.resource"
)
ng.resource(
	"ng.lib.app2d.pixel",
	".bmp"
)

-- This part's the awful bit
-- If you avoid importing this mess, the rest of ng.app2d can be used for 3D applications.

table.insert(ng.app2d.ctxInitializers, function ()
	local w = ng.app2d.current
	local unsignedIntBuf = ffi.new("unsigned int[1]")
	local rectBuf = ffi.new("float[8]",
		0, 0,
		1, 0,
		1, 1,
		0, 1
	)
	w.gl.glGenBuffers(1, unsignedIntBuf)
	w.gl.glBindBuffer(w.gl.GL_ARRAY_BUFFER, unsignedIntBuf[0])
	w.gl.glBufferData(w.gl.GL_ARRAY_BUFFER, ffi.sizeof(rectBuf), rectBuf, w.gl.GL_STATIC_DRAW)

	local function reportSLError(tp1, tp2, program)
		local tmp = ffi.new("int [1]")
		w.gl["glGet" .. tp1 .. "iv"](program, tp2, tmp)
		if tmp[0] == 0 then
			w.gl["glGet" .. tp1 .. "iv"](program, w.gl.GL_INFO_LOG_LENGTH, tmp)
			local errbuf = ffi.new("char[?]", tmp[0]);
			w.gl["glGet" .. tp1  .. "InfoLog"](program, tmp[0], tmp, errbuf)
			-- If empty, the shader probably wasn't created properly to begin with.
			error(ffi.string(errbuf, tmp[0]))
		end
	end
	local function newShader(src, t)
		local shader = w.gl.glCreateShader(t)
		local ptr = ffi.new("const char *[1]")
		ptr[0] = src
		local len = ffi.new("int [1]")
		len[0] = #src
		w.gl.glShaderSource(shader, 1, ptr, len)
		w.gl.glCompileShader(shader)
		reportSLError("Shader", w.gl.GL_COMPILE_STATUS, shader)
		return shader
	end
	local vert = newShader([[
		uniform mat3 rMat;
		uniform mat3 tMat;
		varying vec2 tc;
		void main() {
			tc = (tMat * vec3(gl_Vertex.xy, 1.0)).xy;
			gl_Position = vec4((rMat * vec3(gl_Vertex.xy, 1.0)).xy, 1.0, 1.0);
		}
	]], w.gl.GL_VERTEX_SHADER)
	local frag = newShader([[
		uniform sampler2D tex;
		uniform vec4 col;
		varying vec2 tc;
		void main() {
			gl_FragColor = texture2D(tex, tc) * col;
		}
	]], w.gl.GL_FRAGMENT_SHADER)
	local program = w.gl.glCreateProgram()
	w.gl.glAttachShader(program, vert)
	w.gl.glAttachShader(program, frag)
	w.gl.glLinkProgram(program)
	reportSLError("Program", w.gl.GL_LINK_STATUS, program)
	w.gl.glUseProgram(program)
	w.rmUniform = w.gl.glGetUniformLocation(program, "rMat")
	w.tmUniform = w.gl.glGetUniformLocation(program, "tMat")
	w.colUniform = w.gl.glGetUniformLocation(program, "col")
	w.gl.glUniform1i(w.gl.glGetUniformLocation(program, "tex"), 0)

	w.gl.glEnableVertexAttribArray(0)
	w.gl.glVertexAttribPointer(0, 2, w.gl.GL_FLOAT, 0, 8, nil)

	w.pixel = ng.app2d.texFromBMP(ng.resources["ng.lib.app2d.pixel"])
end)

function ng.app2d.texFromBMP(data, mode)
	local w = ng.app2d.current
	local rwfc = ng.sdl2.SDL_RWFromConstMem(data, #data)
	local surf = ng.sdl2.SDL_LoadBMP_RW(rwfc, 1)

	local unsignedIntBuf = ffi.new("unsigned int[1]")
	w.gl.glGenTextures(1, unsignedIntBuf)
	w.gl.glBindTexture(w.gl.GL_TEXTURE_2D, unsignedIntBuf[0])

	w.gl.glTexParameteri(w.gl.GL_TEXTURE_2D, w.gl.GL_TEXTURE_WRAP_S, w.gl.GL_REPEAT)
	w.gl.glTexParameteri(w.gl.GL_TEXTURE_2D, w.gl.GL_TEXTURE_WRAP_T, w.gl.GL_REPEAT)
	w.gl.glTexParameteri(w.gl.GL_TEXTURE_2D, w.gl.GL_TEXTURE_MIN_FILTER, w.gl.GL_NEAREST)
	w.gl.glTexParameteri(w.gl.GL_TEXTURE_2D, w.gl.GL_TEXTURE_MAG_FILTER, w.gl.GL_NEAREST)

	local surf2 = ng.sdl2.SDL_CreateRGBSurface(0, surf.w, surf.h, 32, 0xFF0000, 0xFF00, 0xFF, 0xFF000000)
	ng.sdl2.SDL_UpperBlit(surf, nil, surf2, nil)
	ng.sdl2.SDL_FreeSurface(surf)

	ng.sdl2.SDL_LockSurface(surf2)
	if mode == "font" then
		for i = 0, surf.h - 1 do
			local target = ffi.cast("uint32_t *", ffi.cast("uint8_t *", surf2.pixels) + (surf2.pitch * i))
			for j = 0, surf.w - 1 do
				local val = target[j]
				target[j] = ((val % 0x100) * 0x1000000) + 0xFFFFFF
			end
		end
	end
	w.gl.glTexImage2D(w.gl.GL_TEXTURE_2D, 0, w.gl.GL_RGBA, surf2.w, surf2.h, 0, w.gl.GL_BGRA, w.gl.GL_UNSIGNED_INT_8_8_8_8_REV, surf2.pixels)
	ng.sdl2.SDL_UnlockSurface(surf2)
	ng.sdl2.SDL_FreeSurface(surf2)

	return unsignedIntBuf[0]
end

function ng.app2d.makeMatrix(xA, yA, xB, yB, sz, p4)
	if sz then
		xB = xB + xA
		yB = yB + yA
	end
	local xQ, yQ = ng.app2d.invertViewport(xA, yA)
	local xE, yE = ng.app2d.invertViewport(xB, yB)
	xE, yE = xE - xQ, yE - yQ
	if p4 then
		return {
			xE, 0, 0,
			0, yE, 0,
			xQ, yQ, 1
		}
	else
		return {
			xE, yE, 0,
			0, 0, 0,
			xQ, yQ, 1
		}
	end
end

-- None of this is really handled correctly, but:
-- Rectangles are supposed to be {x, y, width, height}
-- Screen rectangles are supposed to be in *pixels*, and from the *top-left*

function ng.app2d.texRect(tex, rRect, tRect, col)
	local w = ng.app2d.current
	local rn = ffi.new("float[9]", ng.app2d.makeMatrix(rRect[1], rRect[2], rRect[3], rRect[4], true, true))
	local tn = ffi.new("float[9]",
		tRect[3], 0, 0,
		0, tRect[4], 0,
		tRect[1], tRect[2], 1
	)
	w.gl.glUniformMatrix3fv(w.rmUniform, 1, 0, rn)
	w.gl.glUniformMatrix3fv(w.tmUniform, 1, 0, tn)
	w.gl.glUniform4f(w.colUniform, unpack(col))
	w.gl.glBindTexture(w.gl.GL_TEXTURE_2D, tex)
	w.gl.glDrawArrays(w.gl.GL_QUADS, 0, 4)
end

function ng.app2d.texLine(tex, fromTo, tRect, col)
	local w = ng.app2d.current
	-- Don't ask what the maths does. It will drive you nuts.
	local rn = ffi.new("float[9]", ng.app2d.makeMatrix(fromTo[1], fromTo[2], fromTo[3], fromTo[4], false, false))
	local tn = ffi.new("float[9]",
		tRect[3], 0, 0,
		0, tRect[4], 0,
		tRect[1], tRect[2], 1
	)
	w.gl.glUniformMatrix3fv(w.rmUniform, 1, 0, rn)
	w.gl.glUniformMatrix3fv(w.tmUniform, 1, 0, tn)
	w.gl.glUniform4f(w.colUniform, unpack(col))
	w.gl.glBindTexture(w.gl.GL_TEXTURE_2D, tex)
	w.gl.glDrawArrays(w.gl.GL_LINES, 0, 2)
end

function ng.app2d.point(x, y, col)
	local w = ng.app2d.current
	x, y = ng.app2d.invertViewport(x, y)
	local rn = ffi.new("float[9]",
		0, 0, 0,
		0, 0, 0,
		x, y, 1
	)
	local tn = ffi.new("float[9]",
		1, 0, 0,
		0, 1, 0,
		0, 0, 1
	)
	w.gl.glUniformMatrix3fv(w.rmUniform, 1, 0, rn)
	w.gl.glUniformMatrix3fv(w.tmUniform, 1, 0, tn)
	w.gl.glUniform4f(w.colUniform, unpack(col))
	w.gl.glBindTexture(w.gl.GL_TEXTURE_2D, w.pixel)
	w.gl.glDrawArrays(w.gl.GL_POINTS, 0, 1)
end

function ng.app2d.lineEx(fromTo, col)
	local w = ng.app2d.current
	ng.app2d.texLine(w.pixel, fromTo, {0, 0, 1, 1}, col)
	ng.app2d.point(fromTo[3], fromTo[4], col)
end
