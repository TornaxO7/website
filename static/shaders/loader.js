// three 2d points
const VERTICES = [
  -3.0, -1.0,
  1.0, -1.0,
  1.0, 3.0,
];

const vertexCode = `#version 300 es
  in vec2 pos;

  void main() {
    gl_Position = vec4(pos, 0., 1.);
  }
`;

function resizeCanvasToDisplaySize(canvas) {
  const dpr = window.devicePixelRatio || 1;
  const displayWidth  = Math.floor(canvas.clientWidth  * dpr);
  const displayHeight = Math.floor(canvas.clientHeight * dpr);

  if (canvas.width !== displayWidth || canvas.height !== displayHeight) {
    canvas.width  = displayWidth;
    canvas.height = displayHeight;
    return true;
  }
  return false;
}

async function fetchFragmentCode(url) {
  const response = await fetch(url);
  return await response.text();
}

function compileShader(gl, type, source) {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  const success = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
  if (success) {
    return shader;
  }

  const nameType = type == gl.VERTEX_SHADER ? "vertex" : "fragment";

  console.log(`Couldn't compile ${nameType} shader: ${gl.getShaderInfoLog(shader)}`);
  gl.deleteShader(shader);
  return null;
}

function createShaderProgram(gl, vsSource, fsSource) {
  const vertexShader = compileShader(gl, gl.VERTEX_SHADER, vsSource);
  const fragmentShader = compileShader(gl, gl.FRAGMENT_SHADER, fsSource);

  const vertexShaderCompileFailed = vertexShader === null;
  const fragmentShaderCompileFailed = fragmentShader === null;
  if (vertexShaderCompileFailed || fragmentShaderCompileFailed) {
    return null;
  }

  const shaderProgram = gl.createProgram();
  gl.attachShader(shaderProgram, vertexShader);
  gl.attachShader(shaderProgram, fragmentShader);
  gl.linkProgram(shaderProgram);

  const linking_failed = !gl.getProgramParameter(shaderProgram, gl.LINK_STATUS); 
  if (linking_failed) {
    console.log(`Couldn't link shader: ${gl.getProgramInfoLog(shaderProgram)}`);
    return null;
  }

  return shaderProgram;
}

export async function loadShader(url) {
  const canvas = document.querySelector("#shader-background");
  const gl = canvas.getContext("webgl2");
  if (!gl) {
    console.log("No webgl2 available :(");
    return;
  }

  const fragmentCode = await fetchFragmentCode(url);
  const shaderProgram = createShaderProgram(gl, vertexCode, fragmentCode);
  if (!shaderProgram) {
    console.log("Couldn't create shader program :(");
    return;
  }

  const locations = {
    vPos: gl.getAttribLocation(shaderProgram, "pos"),
    resolution: gl.getUniformLocation(shaderProgram, "iResolution"),
    time: gl.getUniformLocation(shaderProgram, "iTime"),
    seed: gl.getUniformLocation(shaderProgram, "iSeed"),
  };

  const posBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, posBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(VERTICES), gl.STATIC_DRAW);

  var voa = gl.createVertexArray();
  gl.bindVertexArray(voa);
  gl.enableVertexAttribArray(locations.vPos);

  // basically describe vertex buffer
  const size = 2;
  const type = gl.FLOAT;
  const normalize = false;
  const stride = 0;
  const offset = 0;
  gl.vertexAttribPointer(locations.vPos, size, type, normalize, stride, offset);
  gl.bindVertexArray(voa);

  // for `gl_FragCoord`
  gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);

  gl.clearColor(1., 0., 0., 1.);
  gl.clear(gl.COLOR_BUFFER_BIT);

  gl.useProgram(shaderProgram);
  gl.uniform1f(locations.seed, Math.random());

  function render() {
    if (resizeCanvasToDisplaySize(gl.canvas)) {
      gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
      gl.uniform2f(locations.resolution, gl.canvas.width, gl.canvas.height);
    }

    gl.uniform1f(locations.time, performance.now() / 1000);
    gl.drawArrays(gl.TRIANGLES, 0, 3);
    requestAnimationFrame(render);
  }

  requestAnimationFrame(render);
}
