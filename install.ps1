# MegaClaw Vault â€” Auto-Installer
# Run on any Windows OpenClaw machine:
# irm https://raw.githubusercontent.com/rogergrubb/megaclaw-vault/main/install.ps1 | iex

$WORKSPACE = "$env:USERPROFILE\.openclaw\workspace"
$VAULT_DIR = "$WORKSPACE\megaclaw-vault"

Write-Host "Installing MegaClaw Vault client..." -ForegroundColor Cyan

# Create folder
New-Item -ItemType Directory -Force -Path $VAULT_DIR | Out-Null

# Write the client file
$client = @'
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
'@

$client | Out-File -FilePath "$VAULT_DIR\megaclaw-client.js" -Encoding utf8 -Force

# Quick connectivity test
Write-Host "Testing live connection..." -ForegroundColor Yellow
$API = "https://script.google.com/macros/s/AKfycbyPY1h46Sak0WMcXb2bOTBbQQNriaa-7vEG-DCGSWNt0AnXIpb08H-k46nzDzy645jlSA/exec"
$KEY = "59e5af8fbb2b87e2f9fca16492fabd36e4da90e1ed0dfcca"

try {
  $result = Invoke-RestMethod -Uri "$API`?key=$KEY&project=MegaClaw&q=install-test" -Method GET -MaximumRedirection 10
  if ($result.success -eq $true) {
    Write-Host "SUCCESS â€” MegaClaw Vault connected." -ForegroundColor Green
  } else {
    Write-Host "WARNING: $($result | ConvertTo-Json -Compress)" -ForegroundColor Yellow
  }
} catch {
  Write-Host "ERROR: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Client installed at: $VAULT_DIR\megaclaw-client.js" -ForegroundColor Cyan
Write-Host "Done." -ForegroundColor Green
