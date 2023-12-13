# Export-ModuleMember -Function Convert-Timestamp
# Export-ModuleMember -Function Format-BytesToString
Function Convert-Timestamp {
param (
    $timestamp,
    [switch]$Days,
    [switch]$Hours,
    [switch]$Minutes,
    [switch]$Seconds
)
    $timeSpan = New-TimeSpan -Seconds $timestamp
    $bDays = [math]::Floor($timeSpan.Days)
    $bHours = $timeSpan.Hours
    $bMinutes = $timeSpan.Minutes
    $bSeconds = $timeSpan.Seconds
        
    if ($Days -eq $True) {
        return $bDays
    } elseif ($Hours -eq $True) {
        return $bHours
    } elseif ($Minutes -eq $True) {
        return $bMinutes
    } elseif ($Seconds -eq $True) {
        return $bSeconds
    } else {
        return "$bDays" + ':' + "$bHours" + ':' + "$bMinutes" + ':' + "$bSeconds"
    }
}

Function Format-BytesToString {
param(
    $byte_size
) 
    if ($byte_size -lt 1024) {
        return ('{0,15}  B ' -f [double]$byte_size)
    }
    elseif (($byte_size -lt 0x100000) -and ($byte_size -gt 1024)) { 
        $byte_size /= 0x400  # KB
        return ('{0,15:n3} KB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x100000) -and ($byte_size -lt 0x40000000)) {
        $byte_size /= 0x100000  # MB
        return ('{0,15:n3} MB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x40000000) -and ($byte_size -lt 0x10000000000)) {
        $byte_size /= 0x40000000  # GB
        return ('{0,15:n3} GB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x10000000000) -and ($byte_size -lt 0x3FFFFFFFFFFFC)) {
        $byte_size /= 0x10000000000  # TB
        return ('{0,15:n3} TB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x3FFFFFFFFFFFC) -and ($byte_size -lt 0x1000000000000000)) {
        $byte_size /= 0x3FFFFFFFFFFFC  # PB
        return ('{0,15:n3} PB ' -f $byte_size)
    }
}

Function Show-Performance {
param (
    [switch]$Force
)
    if ($Force) {
        $Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(120, 50)
    }
    $max_length = [System.Console]::get_BufferWidth()
    if ($max_length -lt 110) {
        throw 'Please make sure your console window is at least 110 characters wide'
    }
    for ($i = 0; $i -lt 7; $i++) {
        Write-Host (" " * ($max_length - 1))
    }
    
    $counterList = @(
        '\Processor(_Total)\% Processor Time',
        '\Memory\% Committed Bytes In Use',
        '\Memory\Committed Bytes',
        '\PhysicalDisk(_Total)\Disk Read Bytes/sec',
        '\PhysicalDisk(_Total)\Disk Write Bytes/sec',
        '\Network Interface(*)\Bytes Received/sec',
        '\Network Interface(*)\Bytes Sent/sec'
    )
    $timestamp = 0

    $disk_read_sum = 0
    $disk_write_sum = 0
    $network_received_sum = 0
    $network_sent_sum = 0
    
    while ($true) {
        #_alloc_space_Get-Performance
        $max_height = [System.Console]::get_WindowHeight()
        [System.Console]::SetCursorPosition(0, $max_height - 8)
        
        $originalCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
        [System.Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
        $currentTime = Get-Date -Format "MMM. dd, yyyy   HH:mm:ss"
        [System.Threading.Thread]::CurrentThread.CurrentCulture = $originalCulture
        
        $counterData = Get-Counter -Counter $counterList
        $counterValues = $counterData.CounterSamples | ForEach-Object { [math]::Round($_.CookedValue, 3) }
        $memory_total = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum
    
        Write-Host $currentTime -ForegroundColor Green -NoNewline
        Write-Host "                " -NoNewline
        Write-Host ('{0,4:n0}:' -f (Convert-Timestamp -timestamp $timestamp -Days)) -ForegroundColor DarkCyan -NoNewline
        Write-Host ('{0,3:n0}:' -f (Convert-Timestamp -timestamp $timestamp -Hours)) -ForegroundColor DarkCyan -NoNewline
        Write-Host ('{0,3:n0}:' -f (Convert-Timestamp -timestamp $timestamp -Minutes)) -ForegroundColor DarkCyan -NoNewline
        Write-Host ('{0,3:n0}' -f (Convert-Timestamp -timestamp $timestamp -Seconds)) -ForegroundColor DarkCyan

        Write-Host "CPU     Usage    : " -ForegroundColor DarkYellow -NoNewline
        Write-Host ('{0,15:n3}  %' -f $($counterValues[0]))
    
        Write-Host "Memory  Usage    : " -ForegroundColor DarkYellow -NoNewline
        Write-Host ('{0,15:n3}  %' -f $($counterValues[1])) -NoNewline
        Write-Host ' ' -NoNewline
        Write-Host (Format-BytesToString($($counterValues[2]))) -NoNewline
        Write-Host ('{0,21:n} B ' -f $($counterValues[2])) -ForegroundColor DarkGray -NoNewline
        Write-Host '/' -ForegroundColor DarkGray -NoNewline
        Write-Host ('{0,21:n} B ' -f $memory_total) -ForegroundColor DarkGray
    
        $disk_read_sum += $($counterValues[3])
    
        Write-Host "Disk    Read     : " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($($counterValues[3]))) -NoNewline
        Write-Host ('{0,15:n}  B ' -f $($counterValues[3])) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($disk_read_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total' -ForegroundColor DarkCyan
        
        $disk_write_sum += $($counterValues[4])
        
        Write-Host "Disk    Write    : " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($($counterValues[4]))) -NoNewline
        Write-Host ('{0,15:n}  B ' -f $($counterValues[4])) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($disk_write_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total' -ForegroundColor DarkCyan
    
        $network_index_length = ($counterValues.Length - 5) / 2
        
        $network_received_index = 5
        $sum = 0
        for ($index = $network_received_index; $index -lt ($network_received_index + $network_index_length); $index++) {
            $sum += $counterValues[$index]
        }
        $network_received_value = $sum
        $network_received_sum += $network_received_value
        
        $network_sent_index = $network_received_index + $network_index_length
        $sum = 0
        for ($index = $network_sent_index; $index -lt ($network_sent_index + $network_index_length); $index++) {
            $sum += $counterValues[$index]
        }
        $network_sent_value = $sum
        $network_sent_sum += $network_sent_value
        
        Write-Host "Network Received : " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($network_received_value)) -NoNewline
        Write-Host ('{0,15:n}  B ' -f $network_received_value) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($network_received_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total' -ForegroundColor DarkCyan
    
        Write-Host "Network Sent     : " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($network_sent_value)) -NoNewline
        Write-Host ('{0,15:n}  B ' -f $network_sent_value) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($network_sent_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total' -ForegroundColor DarkCyan
        
        $timestamp += 1
        
        if ([System.Console]::KeyAvailable) {
            if ([System.Console]::ReadKey($true).Key -eq 'q') {
                break
            }
        }
    }
}
