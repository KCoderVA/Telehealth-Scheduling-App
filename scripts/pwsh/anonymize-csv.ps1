Param(
    [string]$MasterSchedulePath = "src/sharepoint/MasterSchedule/TelehealthMasterSched_CombiTable.csv",
    [string]$ReservationLogPath = "src/sharepoint/ReservationLog/App_ReservationLog.csv",
    [string]$OutputDir = "src/sharepoint"
)
Write-Host "Starting anonymization..." -ForegroundColor Cyan
If(-not (Test-Path $MasterSchedulePath)) { Write-Host "Master schedule not found: $MasterSchedulePath" -ForegroundColor Red; Exit 1 }
If(-not (Test-Path $ReservationLogPath)) { Write-Host "Reservation log not found: $ReservationLogPath" -ForegroundColor Red; Exit 1 }
$emailMap = @{}
$nameMap = @{}
$phoneMap = @{}
$ipMap = @{}
$extMap = @{}
$emailCounter = 1
$nameCounter = 1
$phoneCounter = 1
$ipCounter = 1
$extCounter = 1
Function Get-EmailReplacement($value){ if([string]::IsNullOrWhiteSpace($value)){ return $value }; if($value -notmatch '@'){ return $value }; if($emailMap.ContainsKey($value)){ return $emailMap[$value] }; $rep = ('user' + $emailCounter.ToString('0000') + '@va.gov'); $emailMap[$value] = $rep; $emailCounter++; return $rep }
Function Get-NameReplacement($value){ if([string]::IsNullOrWhiteSpace($value)){ return $value }; if($nameMap.ContainsKey($value)){ return $nameMap[$value] }; $rep = ('Person' + $nameCounter.ToString('0000')); $nameMap[$value] = $rep; $nameCounter++; return $rep }
Function Get-PhoneReplacement($value){ if([string]::IsNullOrWhiteSpace($value)){ return $value }; if($phoneMap.ContainsKey($value)){ return $phoneMap[$value] }; $suffix = ($phoneCounter.ToString('0000')); $repFormatted = '(555) 010-' + $suffix; $repDigits = '555010' + $suffix; if( ($value -match '^\(') -or ($value -match '^\([0-9]{3}\)') ){ $phoneMap[$value] = $repFormatted } else { $phoneMap[$value] = $repDigits }; $phoneCounter++; return $phoneMap[$value] }
Function Get-IpReplacement($value){ if([string]::IsNullOrWhiteSpace($value)){ return $value }; if($ipMap.ContainsKey($value)){ return $ipMap[$value] }; if($value -notmatch '^\d+\.\d+\.\d+\.\d+$'){ return $value }; $rep = '10.200.' + ($ipCounter.ToString('000')) + '.' + ($ipCounter.ToString('000')); $ipMap[$value] = $rep; $ipCounter++; return $rep }
Function Get-ExtReplacement($value){ if([string]::IsNullOrWhiteSpace($value)){ return $value }; if($extMap.ContainsKey($value)){ return $extMap[$value] }; if($value -notmatch '^[0-9]{5}$'){ return $value }; $rep = '29' + $extCounter.ToString('000'); $extMap[$value] = $rep; $extCounter++; return $rep }
Function Process-Table($rows){ if(-not $rows -or $rows.Count -eq 0){ return $rows }; $headers = $rows[0].PsObject.Properties.Name; $emailHeaders = $headers | Where-Object { $_ -match 'Email' }; $nameHeaders = $headers | Where-Object { $_ -match 'Name' }; $phoneHeaders = $headers | Where-Object { $_ -match 'Phone|Cell' }; $ipHeaders = $headers | Where-Object { $_ -match 'IPaddress' }; $extHeaders = $headers | Where-Object { $_ -match 'Extension' }; foreach($r in $rows){ foreach($h in $emailHeaders){ $r.$h = Get-EmailReplacement($r.$h) }; foreach($h in $nameHeaders){ $r.$h = Get-NameReplacement($r.$h) }; foreach($h in $phoneHeaders){ $r.$h = Get-PhoneReplacement($r.$h) }; foreach($h in $ipHeaders){ $r.$h = Get-IpReplacement($r.$h) }; foreach($h in $extHeaders){ $r.$h = Get-ExtReplacement($r.$h) } }; return $rows }
$master = @()
try { $master = Import-Csv -Path $MasterSchedulePath -ErrorAction Stop } catch {
    Write-Host "Fallback raw parse for master schedule (duplicate headers detected)." -ForegroundColor Yellow
    $rawLines = Get-Content -Path $MasterSchedulePath
    if($rawLines.Count -gt 0){
        $headerLine = $rawLines[0]
        $cols = $headerLine -split ','
        $uniqueHeaders = @()
        $tracker = @{}
        foreach($c in $cols){
            if($tracker.ContainsKey($c)){ $tracker[$c]++ ; $uniqueHeaders += ($c + '_' + $tracker[$c]) } else { $tracker[$c]=0 ; $uniqueHeaders += $c }
        }
        $dataLines = $rawLines | Select-Object -Skip 1
        $master = $dataLines | ConvertFrom-Csv -Header $uniqueHeaders
    }
}
$reserv = Import-Csv -Path $ReservationLogPath
Write-Host "Records loaded: Master=$($master.Count) Reservation=$($reserv.Count)" -ForegroundColor Yellow
$masterAnon = Process-Table $master
$reservAnon = Process-Table $reserv
$masterOut = Join-Path $OutputDir 'MasterSchedule/TelehealthMasterSched_CombiTable_ANON_full.csv'
$reservOut = Join-Path $OutputDir 'ReservationLog/App_ReservationLog_ANON_full.csv'
New-Item -ItemType Directory -Force -Path (Split-Path $masterOut) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $reservOut) | Out-Null
$masterAnon | Export-Csv -Path $masterOut -NoTypeInformation -Encoding UTF8
$reservAnon | Export-Csv -Path $reservOut -NoTypeInformation -Encoding UTF8
Function New-Count($orig,$anon){ "Rows original=$($orig.Count) anonymized=$($anon.Count)" }
$report = @()
$report += "Master schedule: $(New-Count $master $masterAnon)"
$report += "Reservation log: $(New-Count $reserv $reservAnon)"
$report += "Unique emails replaced: $($emailMap.Count)"
$report += "Unique names replaced: $($nameMap.Count)"
$report += "Unique phones replaced: $($phoneMap.Count)"
$report += "Unique IPs replaced: $($ipMap.Count)"
$report += "Unique extensions replaced: $($extMap.Count)"
$report += "Timestamp: $(Get-Date -Format o)"
$reportPath = 'docs/anonymization-report.txt'
$report | Out-File -FilePath $reportPath -Encoding UTF8
Write-Host "Anonymization complete." -ForegroundColor Green
Write-Host "Report: $reportPath" -ForegroundColor Cyan
Write-Host "Master output: $masterOut" -ForegroundColor Cyan
Write-Host "Reservation output: $reservOut" -ForegroundColor Cyan
