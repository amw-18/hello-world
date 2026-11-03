importScripts("config.js");
chrome.runtime.onInstalled.addListener(() => {
  const m = chrome.runtime.getManifest();
  // Stand-in for the PostHog event: version and build SHA ride on every event.
  console.log("installed", { extension_version: m.version, build_sha: self.EXT_CONFIG.buildSha, environment: self.EXT_CONFIG.environment });
});
