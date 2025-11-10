# PowerShell script to configure Windows Firewall for Canteen System
# This script must be run as Administrator

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  Configuring Windows Firewall for Canteen System" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Right-click on PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host "Then run this script again" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "✓ Running as Administrator" -ForegroundColor Green
Write-Host ""

# Remove old rules
Write-Host "Removing old firewall rules..." -ForegroundColor Yellow
Remove-NetFirewallRule -DisplayName "Canteen*" -ErrorAction SilentlyContinue
Write-Host "✓ Old rules removed" -ForegroundColor Green
Write-Host ""

# Add new rules
Write-Host "Creating new firewall rules..." -ForegroundColor Yellow
Write-Host ""

# Port 8080 (Frontend)
Write-Host "[1/3] Adding rule for Port 8080 (Frontend)..." -ForegroundColor Cyan
New-NetFirewallRule -DisplayName "Canteen - Port 8080" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow -Profile Any | Out-Null
Write-Host "✓ Port 8080 allowed" -ForegroundColor Green

# Port 3000 (Backend)
Write-Host "[2/3] Adding rule for Port 3000 (Backend)..." -ForegroundColor Cyan
New-NetFirewallRule -DisplayName "Canteen - Port 3000" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow -Profile Any | Out-Null
Write-Host "✓ Port 3000 allowed" -ForegroundColor Green

# Port 3001 (Sync Server)
Write-Host "[3/3] Adding rule for Port 3001 (Sync Server)..." -ForegroundColor Cyan
New-NetFirewallRule -DisplayName "Canteen - Port 3001" -Direction Inbound -LocalPort 3001 -Protocol TCP -Action Allow -Profile Any | Out-Null
Write-Host "✓ Port 3001 allowed" -ForegroundColor Green

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ✓ Firewall Configuration Complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Firewall rules created:" -ForegroundColor Yellow
Write-Host "  ✓ Port 8080 (Frontend Server)" -ForegroundColor Green
Write-Host "  ✓ Port 3000 (Backend Server)" -ForegroundColor Green
Write-Host "  ✓ Port 3001 (Sync Server)" -ForegroundColor Green
Write-Host ""
Write-Host "Mobile devices can now connect!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Make sure servers are running" -ForegroundColor White
Write-Host "  2. Connect mobile to same WiFi" -ForegroundColor White
Write-Host "  3. Access: http://10.199.240.223:8080/c3.html" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"
