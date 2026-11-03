const m = chrome.runtime.getManifest();
document.getElementById("build").textContent = `${m.version_name || m.version} · ${self.EXT_CONFIG.environment}`;
