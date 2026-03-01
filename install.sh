#!/bin/bash
# MegaClaw Vault â€” Auto-Installer (Mac/Linux)
# Run: curl -fsSL https://raw.githubusercontent.com/rogergrubb/megaclaw-vault/main/install.sh | bash

WORKSPACE="$HOME/.openclaw/workspace"
VAULT_DIR="$WORKSPACE/megaclaw-vault"

echo "Installing MegaClaw Vault client..."
mkdir -p "$VAULT_DIR"

cat > "$VAULT_DIR/megaclaw-client.js" << 'EOF'
const MEGACLAW_API = "https://script.google.com/macros/s/AKfycbyPY1h46Sak0WMcXb2bOTBbQQNriaa-7vEG-DCGSWNt0AnXIpb08H-k46nzDzy645jlSA/exec";
const MEGACLAW_KEY = "59e5af8fbb2b87e2f9fca16492fabd36e4da90e1ed0dfcca";

// Projects: BrainCandy | MegaClaw | PaperVault | SellFastNow | MultiPowerAI | BookFactory | Brainforge | MapAndMingle

function _url(params) {
  return MEGACLAW_API + "?key=" + MEGACLAW_KEY + (params ? "&" + params : "");
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
    method: "PUT", headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ project, content, tags })
  });
  return r.json();
}
module.exports = { readMemory, writeMemory, searchMemories, updateMemory };
EOF

echo "Testing live connection..."
API="https://script.google.com/macros/s/AKfycbyPY1h46Sak0WMcXb2bOTBbQQNriaa-7vEG-DCGSWNt0AnXIpb08H-k46nzDzy645jlSA/exec"
KEY="59e5af8fbb2b87e2f9fca16492fabd36e4da90e1ed0dfcca"

RESULT=$(curl -sL "$API?key=$KEY&project=MegaClaw&q=install-test")
if echo "$RESULT" | grep -q '"success":true'; then
  echo "SUCCESS â€” MegaClaw Vault connected."
else
  echo "WARNING: $RESULT"
fi

echo "Client installed at: $VAULT_DIR/megaclaw-client.js"
echo "Done."
