'use strict';

const N = 512
const ALPHA = 1.4

function createShader(gl, type, name) {
    let shader = gl.createShader(type)
    let source = document.getElementById(name).text

    gl.shaderSource(shader, source.trimStart())
    gl.compileShader(shader)

    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
        throw ("Something went wrong. (compilation)")

    return shader
}

function createProgram(gl, shaders, transformFeedbackVaryings) {
    let program = gl.createProgram()

    for (let shader of shaders)
        gl.attachShader(program, createShader(gl, ...shader));

    if (transformFeedbackVaryings)
        gl.transformFeedbackVaryings(
            program,
            transformFeedbackVaryings,
            gl.INTERLEAVED_ATTRIBS
        )

    gl.linkProgram(program)

    if (!gl.getProgramParameter(program, gl.LINK_STATUS))
        throw "Something went wrong. (linking)"

    return program
}

function main() {
    const canvas = document.getElementById("display")
    const gl = canvas.getContext("webgl2")

    const update_program = createProgram(
        gl,
        [
            [gl.VERTEX_SHADER, "update-vs"],
            [gl.FRAGMENT_SHADER, "update-fs"]
        ],
        ["v_Position"]
    )

    const render_program = createProgram(
        gl,
        [
            [gl.VERTEX_SHADER, "render-vs"],
            [gl.FRAGMENT_SHADER, "render-fs"]
        ]
    )

    const update_locations = {
        i_Position: gl.getAttribLocation(update_program, "i_Position"),
        u_Alpha: gl.getUniformLocation(update_program, "u_Alpha")
    }

    const render_locations = {
        i_Position: gl.getAttribLocation(render_program, "i_Position")
    }

    // Generate 3 * N random floats in [0, 1]
    let positions = Float32Array.from(
        self.crypto.getRandomValues(new Uint32Array(3 * N)),
        v => v / 0xFFFFFFFF
    )

    let buffer = (data, usage) => {
        const buf = gl.createBuffer()

        gl.bindBuffer(gl.ARRAY_BUFFER, buf)
        gl.bufferData(gl.ARRAY_BUFFER, data, usage)

        return buf
    }

    const position_buffers = [
        buffer(positions, gl.DYNAMIC_DRAW),
        buffer(positions, gl.DYNAMIC_DRAW)
    ]

    let vertexArray = pairs => {
        const va = gl.createVertexArray()

        gl.bindVertexArray(va)

        for (const [buf, loc] of pairs) {
            gl.bindBuffer(gl.ARRAY_BUFFER, buf)
            gl.enableVertexAttribArray(loc)
            gl.vertexAttribPointer(loc, 3, gl.FLOAT, false, 0, 0)
        }

        return va
    }

    const update_vaos = position_buffers.map(v => vertexArray([[v, update_locations.i_Position]]))
    const render_vaos = position_buffers.map(v => vertexArray([[v, render_locations.i_Position]]))

    let transformFeedback = buf => {
        const feedback = gl.createTransformFeedback()

        gl.bindTransformFeedback(gl.TRANSFORM_FEEDBACK, feedback)
        gl.bindBufferBase(gl.TRANSFORM_FEEDBACK_BUFFER, 0, buf)

        return feedback
    }

    const feedbacks = position_buffers.map(v => transformFeedback(v))

    gl.bindBuffer(gl.ARRAY_BUFFER, null)
    gl.bindBuffer(gl.TRANSFORM_FEEDBACK_BUFFER, null)

    let current = {
        update: update_vaos[0],
        feedback: feedbacks[1],
        render: render_vaos[1]
    }

    let next = {
        update: update_vaos[1],
        feedback: feedbacks[0],
        render: render_vaos[0]
    }

    let render = _ => {
        gl.clearColor(0x16 / 0xFF, 0x16 / 0xFF, 0x1D / 0xFF, 1.)
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

        gl.useProgram(update_program)
        gl.bindVertexArray(current.update)

        gl.uniform1f(update_locations.u_Alpha, ALPHA)

        gl.enable(gl.RASTERIZER_DISCARD)

        gl.bindTransformFeedback(gl.TRANSFORM_FEEDBACK, current.feedback)
        gl.beginTransformFeedback(gl.POINTS)
        gl.drawArrays(gl.POINTS, 0, N)
        gl.endTransformFeedback()
        gl.bindTransformFeedback(gl.TRANSFORM_FEEDBACK, null)

        gl.disable(gl.RASTERIZER_DISCARD)

        gl.useProgram(render_program)
        gl.bindVertexArray(current.render)
        gl.viewport(0, 0, gl.canvas.width, gl.canvas.height)
        gl.drawArrays(gl.POINTS, 0, N)

        current = [next, next = current][0]

        requestAnimationFrame(render)
    }

    requestAnimationFrame(render)
}

window.addEventListener("load", main)
