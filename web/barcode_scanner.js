let _zxingReader = null;
let _scannerActive = false;

window.startBarcodeScanner = async function(dartCallback) {
  if (_scannerActive) return;

  const overlay = document.getElementById('barcode-overlay');
  const video = document.getElementById('barcode-video');
  const hint = document.getElementById('barcode-hint');

  overlay.classList.add('active');
  hint.textContent = 'Inquadra il codice a barre';

  try {
    _zxingReader = new ZXing.BrowserMultiFormatReader();
    _scannerActive = true;

    await _zxingReader.decodeFromConstraints(
      { video: { facingMode: { ideal: 'environment' } } },
      video,
      (result, err) => {
        if (result) {
          const code = result.getText();
          hint.textContent = '✅ ' + code;
          window.stopBarcodeScanner();
          if (dartCallback && typeof dartCallback === 'function') {
            dartCallback(code);
          }
        }
      }
    );
  } catch (e) {
    hint.textContent = '❌ Camera non disponibile: ' + e.message;
    console.error('BarcodeScanner error:', e);
  }
};

window.stopBarcodeScanner = function() {
  if (_zxingReader) {
    try { _zxingReader.reset(); } catch (_) {}
    _zxingReader = null;
  }
  _scannerActive = false;
  const overlay = document.getElementById('barcode-overlay');
  if (overlay) overlay.classList.remove('active');
  const video = document.getElementById('barcode-video');
  if (video && video.srcObject) {
    video.srcObject.getTracks().forEach(t => t.stop());
    video.srcObject = null;
  }
};
