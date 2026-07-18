<!-- ========================================== -->
<!-- ADEV-LITE GENERATOR (MOTOR NATIVO PERCHANCE) -->
<!-- ========================================== -->

<style>
  /* --- TUS ESTILOS MORADOS (COPIADOS DE TU CSS) --- */
  :root {
    --b1-color-0: #3e0346; --b1-color-1: rgba(255, 255, 255, 0.08);
    --b1-color-2: #a850f5; --b1-color-6: #f4b2e5;
    --bg-color: #1d032b; --border-n1: 1px solid rgba(177, 1, 230, 0.082);
    --shadow-n1: inset 5px 5px 4px rgba(0, 0, 14, 0.51), inset -5px -5px 4px rgba(70, 44, 84, 0.3);
    --gradie-n1: linear-gradient(265deg, #34034f,#1d032b);
  }

  body { background: var(--bg-color); font-family: sans-serif; color: #fff; }

  /* --- ESTILOS ADEV GRID --- */
  .adev-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1.5rem;
    padding: 1rem;
    width: 100%;
    box-sizing: border-box;
  }

  .adev-card {
    background: var(--b1-color-1);
    backdrop-filter: blur(10px);
    border: var(--border-n1);
    box-shadow: var(--shadow-n1);
    border-radius: 8px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    position: relative;
    aspect-ratio: 1/1; /* Cuadrado por defecto */
    transition: transform 0.2s;
  }

  .adev-card:hover { transform: translateY(-5px); border-color: #a850f5; }

  .adev-image-wrapper {
    width: 100%; height: 100%;
    background: #000;
    display: flex; align-items: center; justify-content: center;
    position: relative;
  }

  .adev-image-wrapper img {
    width: 100%; height: 100%; object-fit: cover;
    cursor: pointer;
  }

  .adev-loader {
    position: absolute; inset: 0;
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    color: var(--b1-color-6);
    background: rgba(0,0,0,0.5);
    z-index: 2;
  }

  .spinner {
    width: 30px; height: 30px;
    border: 3px solid rgba(255,255,255,0.3);
    border-top-color: var(--b1-color-2);
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }
  @keyframes spin { to { transform: rotate(360deg); } }

  .adev-data-panel {
    padding: 10px;
    background: rgba(0,0,0,0.6);
    border-top: 1px solid var(--border-n1);
    font-size: 0.8rem;
    color: #ccc;
  }

  .adev-prompt {
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    margin-bottom: 5px; color: #fff;
  }

  .adev-actions { display: flex; gap: 5px; margin-top: 5px; }
  
  .adev-btn-small {
    flex: 1; padding: 4px; font-size: 0.7rem;
    background: rgba(255,255,255,0.1); border: none;
    color: #fff; border-radius: 4px; cursor: pointer;
  }
  .adev-btn-small:hover { background: var(--b1-color-2); }

  /* Controles Globales */
  .adev-global-controls {
    grid-column: 1 / -1;
    padding: 20px;
    background: var(--b1-color-1);
    border-radius: 8px;
    margin-bottom: 20px;
    border: var(--border-n1);
    text-align: center;
  }

  .adev-btn-main {
    padding: 12px 24px; font-size: 1rem;
    background: linear-gradient(135deg, #a850f5, #87289d);
    color: white; border: none; border-radius: 6px;
    cursor: pointer; font-weight: bold;
    box-shadow: 0 4px 15px rgba(168, 80, 245, 0.4);
  }
  .adev-btn-main:hover { filter: brightness(1.1); transform: translateY(-2px); }
  .adev-btn-main:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }

  /* Panel de Control Manual */
  .control-panel {
    max-width: 600px; margin: 20px auto; padding: 20px;
    background: var(--b1-color-1); backdrop-filter: blur(10px);
    border-radius: 13px; border: var(--border-n1);
  }
  textarea {
    width: 100%; height: 80px; box-sizing: border-box;
    background: var(--gradie-n1); color: #fff;
    border: var(--border-n1); border-radius: 8px;
    padding: 10px; font-family: monospace;
  }
</style>

<div id="adev-app-root">
  <!-- El contenido se genera aquí -->
</div>

<!-- Panel de Control Manual para Pruebas -->
<div class="control-panel">
  <h2 style="color: var(--b1-color-6); text-align: center; margin-top:0;">🎨 ADEV Generator</h2>
  <textarea id="test-prompt" placeholder="Escribe tu prompt aquí...">cyberpunk city with neon lights, detailed, 8k, purple theme</textarea>
  <div style="text-align: center; margin-top: 15px;">
    <button onclick="runTest()" class="adev-btn-main">✨ GENERAR LOTE (4 imgs)</button>
  </div>
</div>

<script>
/**
 * ADEV-LITE CORE (Usando generateImage nativo de Perchance)
 */
const ADEV_CONFIG = {
  defaultResolution: "512x512",
  defaultGuidance: 7
};

let adevGeneratedItems = []; 

async function adevGenerate(inputData) {
  const root = document.getElementById('adev-app-root');
  root.innerHTML = ''; 

  let config = {};
  if (typeof inputData === 'string') {
    config = { prompt: inputData, numImages: 4 };
  } else if (typeof inputData === 'object' && inputData !== null) {
    config = inputData;
  } else {
    root.innerHTML = `<div class="adev-loader" style="color:red; grid-column:1/-1">Error: Formato no válido.</div>`;
    return;
  }

  if (!config.prompt || config.prompt.trim() === "") {
    root.innerHTML = `<div class="adev-loader" style="color:red; grid-column:1/-1">Error: El prompt está vacío.</div>`;
    return;
  }
  
  const numImages = Math.min(Math.max(config.numImages || 4, 1), 20); // Límite seguro 20
  renderLayout(numImages);

  const generationPromises = [];
  
  for (let i = 0; i < numImages; i++) {
    const id = `adev-img-${Date.now()}-${i}`;
    const seed = config.seed === -1 || config.seed === undefined ? Math.floor(Math.random() * 999999) : (config.seed + i);
    
    createImageCard(id, config.prompt, seed);
    
    // USAMOS LA FUNCIÓN NATIVA generateImage()
    const promise = (async () => {
      try {
        const options = { 
          resolution: config.resolution || ADEV_CONFIG.defaultResolution,
          seed: seed,
          guidanceScale: config.guidanceScale || ADEV_CONFIG.defaultGuidance
        };
        
        // ¡Aquí ocurre la magia! generateImage maneja auth y colas.
        const dataUrl = await generateImage(config.prompt, options);
        
        updateImageCard(id, dataUrl, `Seed: ${seed} | OK`);
        adevGeneratedItems.push({
          id: id,
          dataUrl: dataUrl,
          prompt: config.prompt,
          params: `Seed: ${seed}`,
          filename: `img_${seed}.png`
        });
        return dataUrl;
      } catch (err) {
        console.error(err);
        updateImageCardError(id, "Falló");
        throw err;
      }
    })();
    
    generationPromises.push(promise);
  }

  Promise.all(generationPromises).then(() => enableZipButton());
}

// Funciones de UI (Renderizado)
function renderLayout(total) {
  const root = document.getElementById('adev-app-root');
  root.innerHTML = `
    <div class="adev-global-controls">
      <h3 style="margin-top:0; color: var(--b1-color-6)">Generando ${total} imágenes...</h3>
      <button id="adev-zip-btn" class="adev-btn-main" disabled onclick="adevDownloadZip()">⬇️ Descargar ZIP Completo</button>
      <p style="font-size:0.8rem; color:#aaa; margin:10px 0 0 0;">Incluye imágenes + metadata.json</p>
    </div>
    <div class="adev-container" id="adev-grid"></div>
  `;
  adevGeneratedItems = [];
}

function createImageCard(id, prompt, seed) {
  const grid = document.getElementById('adev-grid');
  const card = document.createElement('div');
  card.className = 'adev-card';
  card.id = id;
  card.innerHTML = `
    <div class="adev-image-wrapper">
      <div class="adev-loader">
        <div class="spinner"></div>
        <div style="margin-top:10px; font-size:0.8rem">Procesando...</div>
      </div>
    </div>
    <div class="adev-data-panel">
      <div class="adev-prompt" title="${prompt}">${prompt}</div>
      <div class="adev-params" style="font-size:0.7rem; color:#888">Seed: ${seed}</div>
      <div class="adev-actions">
        <button class="adev-btn-small" onclick="adevSaveLocal('${id}')">💾 Guardar</button>
      </div>
    </div>
  `;
  grid.appendChild(card);
}

function updateImageCard(id, dataUrl, paramsText) {
  const card = document.getElementById(id);
  if (!card) return;
  const loader = card.querySelector('.adev-loader');
  if(loader) loader.remove();
  
  const imgWrapper = card.querySelector('.adev-image-wrapper');
  const img = document.createElement('img');
  img.src = dataUrl;
  img.onclick = () => window.open(dataUrl, '_blank'); // Click para abrir en grande
  imgWrapper.appendChild(img);
  
  const paramsDiv = card.querySelector('.adev-params');
  if(paramsDiv) paramsDiv.textContent = paramsText;
}

function updateImageCardError(id, msg) {
  const card = document.getElementById(id);
  if (!card) return;
  const loader = card.querySelector('.adev-loader');
  if(loader) {
    loader.innerHTML = `<span style="color:red; font-weight:bold">${msg}</span>`;
    loader.style.background = "rgba(50,0,0,0.8)";
  }
}

function enableZipButton() {
  const btn = document.getElementById('adev-zip-btn');
  if (btn) {
    btn.disabled = false;
    btn.textContent = `⬇️ Descargar ZIP (${adevGeneratedItems.length} imgs)`;
    btn.style.background = "linear-gradient(135deg, #00b894, #00cec9)";
  }
}

// Funciones de Descarga (ZIP y Local)
async function adevDownloadZip() {
  if (adevGeneratedItems.length === 0) return;
  const btn = document.getElementById('adev-zip-btn');
  const originalText = btn.textContent;
  btn.textContent = "🔄 Empaquetando...";
  btn.disabled = true;

  try {
    if (typeof JSZip === 'undefined') {
      await new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = "https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js";
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
      });
    }

    const zip = new JSZip();
    const imgFolder = zip.folder("imagenes_adev");
    const metadata = adevGeneratedItems.map(item => ({
      filename: item.filename,
      prompt: item.prompt,
      params: item.params
    }));
    zip.file("metadata.json", JSON.stringify(metadata, null, 2));

    adevGeneratedItems.forEach(item => {
      const base64Data = item.dataUrl.split(',')[1];
      imgFolder.file(item.filename, base64Data, {base64: true});
    });

    const content = await zip.generateAsync({type: "blob"});
    const url = URL.createObjectURL(content);
    const a = document.createElement('a');
    a.href = url;
    a.download = `adev-lote-${Date.now()}.zip`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);

    btn.textContent = "✅ ¡Listo!";
    setTimeout(() => { btn.textContent = originalText; btn.disabled = false; }, 3000);

  } catch (e) {
    alert("Error ZIP: " + e.message);
    btn.disabled = false;
  }
}

window.adevSaveLocal = function(id) {
  const item = adevGeneratedItems.find(i => i.id === id);
  if (!item) return;
  const a = document.createElement('a');
  a.href = item.dataUrl;
  a.download = item.filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
};

window.adevGenerate = adevGenerate;

function runTest() {
  const prompt = document.getElementById('test-prompt').value;
  window.adevGenerate({
    prompt: prompt,
    numImages: 4,
    resolution: "512x512",
    guidanceScale: 7,
    seed: -1
  });
}
</script>
