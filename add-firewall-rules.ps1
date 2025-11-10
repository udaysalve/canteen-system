# Add firewall rules for Canteen System
# Run as Administrator

Write-Host "Adding firewall rules..." -ForegroundColor Yellow

# Remove old rules
Remove-NetFirewallRule -DisplayName "Canteen*" -ErrorAction SilentlyContinue

# Add new rules
New-NetFirewallRule -DisplayName "Canteen - Port 8080" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow -Profile Any
New-NetFirewallRule -DisplayName "Canteen - Port 3000" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow -Profile Any
New-NetFirewallRule -DisplayName "Canteen - Port 3001" -Direction Inbound -LocalPort 3001 -Protocol TCP -Action Allow -Profile Any

Write-Host "Firewall rules added successfully!" -ForegroundColor Green
Write-Host "Ports 8080, 3000, and 3001 are now open" -ForegroundColor Green
