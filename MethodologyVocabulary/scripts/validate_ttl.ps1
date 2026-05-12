param(
  [string]$Root = ".",
  [switch]$Strict
)

$ErrorActionPreference = "Stop"
$rootPath = (Resolve-Path $Root).Path
Write-Host "Validating TTL files under: $rootPath"

$ttlFiles = Get-ChildItem -Path $rootPath -Recurse -Filter *.ttl -File
if ($ttlFiles.Count -eq 0) {
  Write-Host "No .ttl files found."
  exit 0
}

$missing = @()
$importRegex = [regex]'owl:imports\s*<([^>]+)>'

foreach ($file in $ttlFiles) {
  $content = Get-Content -LiteralPath $file.FullName -Raw
  $matches = $importRegex.Matches($content)
  foreach ($m in $matches) {
    $imp = $m.Groups[1].Value
    if ($imp -match '://') { continue }
    $target = Join-Path $file.DirectoryName $imp
    if (-not (Test-Path -LiteralPath $target)) {
      $missing += [PSCustomObject]@{ Source = $file.FullName; Import = $imp; Target = $target }
    }
  }
}

if ($missing.Count -gt 0) {
  Write-Host "`nMissing local imports:" -ForegroundColor Red
  $missing | ForEach-Object {
    Write-Host "- $($_.Source) imports <$($_.Import)> -> missing at $($_.Target)" -ForegroundColor Red
  }
  exit 1
}

Write-Host "Local import path check passed." -ForegroundColor Green

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
  Write-Host "Python not found. Skipping RDF parse validation." -ForegroundColor Yellow
  if ($Strict) { exit 1 }
  exit 0
}

$tmpPy = Join-Path $env:TEMP "validate_ttl_tmp.py"
@"
import sys
from pathlib import Path
import rdflib

root = Path(sys.argv[1])
errors = []
for p in root.rglob("*.ttl"):
    try:
        g = rdflib.Graph()
        g.parse(p.as_posix(), format="turtle")
    except Exception as e:
        errors.append((str(p), str(e)))

if errors:
    print("PARSE_ERRORS", len(errors))
    for p, e in errors:
        print(f"ERR|{p}|{e}")
    sys.exit(1)

print("RDF parse validation passed.")
"@ | Set-Content -LiteralPath $tmpPy -Encoding UTF8

try {
  & python $tmpPy $rootPath
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally {
  Remove-Item -LiteralPath $tmpPy -ErrorAction SilentlyContinue
}

Write-Host "All checks passed." -ForegroundColor Green
