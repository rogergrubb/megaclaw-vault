// ============================================================
// MegaClaw Vault - OpenClaw Memory Client
// Drop this into any OpenClaw instance workspace
// ============================================================

const MEGACLAW_API = "https://script.google.com/macros/s/AKfycbyPY1h46Sak0WMcXb2bOTBbQQNriaa-7vEG-DCGSWNt0AnXIpb08H-k46nzDzy645jlSA/exec";
const MEGACLAW_KEY = "59e5af8fbb2b87e2f9fca16492fabd36e4da90e1ed0dfcca";

// Projects available:
// BrainCandy | MegaClaw | PaperVault | SellFastNow
// MultiPowerAI | BookFactory | Brainforge | MapAndMingle

function _url(params) {
  const base = MEGACLAW_API + "?key=" + MEGACLAW_KEY;
  return base + (params ? "&" + params : "");
}

async function readMemory(project, key) {
  const r = await fetch(_url("project=" + encodeURIComponent(project) + "&q=" + encodeURIComponent(key)));
  return r.json();
}

async function writeMemory(project, key, content, tags = []) {
  const r = await fetch(_url("project=" + encodeURIComponent(project)), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ project, key, content, tags })
  });
  return r.json();
}

async function searchMemories(project, query) {
  const r = await fetch(_url("project=" + encodeURIComponent(project) + "&q=" + encodeURIComponent(query)));
  return r.json();
}

async function updateMemory(id, project, content, tags) {
  const r = await fetch(_url("id=" + encodeURIComponent(id) + "&project=" + encodeURIComponent(project)), {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ project, content, tags })
  });
  return r.json();
}

async function deleteMemory(id, project) {
  const r = await fetch(_url("id=" + encodeURIComponent(id) + "&project=" + encodeURIComponent(project)), {
    method: "DELETE"
  });
  return r.json();
}

module.exports = { readMemory, writeMemory, searchMemories, updateMemory, deleteMemory };
