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

Function Format-PercentageColor {
param (
    [Double]$Percentage,
    [Switch]$NoNewline
)
    if ($NoNewline) {
        if ($Percentage -lt 0.0) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor White -NoNewline
        }
        elseif ($Percentage -lt 12.5) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Cyan -NoNewline
        } 
        elseif (($Percentage -ge 12.5) -and ($Percentage -lt 25.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkCyan -NoNewline
        }
        elseif (($Percentage -ge 25.0) -and ($Percentage -lt 37.5)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Green -NoNewline
        }
        elseif (($Percentage -ge 37.5) -and ($Percentage -lt 50.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkGreen -NoNewline
        }
        elseif (($Percentage -ge 50.0) -and ($Percentage -lt 62.5)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Yellow -NoNewline
        }
        elseif (($Percentage -ge 62.5) -and ($Percentage -lt 75.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkYellow -NoNewline
        }
        elseif (($Percentage -ge 75.0) -and ($Percentage -lt 87.5)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Magenta -NoNewline
        }
        elseif (($Percentage -ge 87.5) -and ($Percentage -lt 100.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Red -NoNewline
        }
        elseif ($Percentage -ge 100.0) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkRed -NoNewline
        }
    }
    else {
        if ($Percentage -lt 0.0) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor White
        }
        elseif ($Percentage -lt 12.5) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Cyan
        } 
        elseif (($Percentage -ge 12.5) -and ($Percentage -lt 25.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkCyan
        }
        elseif (($Percentage -ge 25.0) -and ($Percentage -lt 37.5)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Green
        }
        elseif (($Percentage -ge 37.5) -and ($Percentage -lt 50.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkGreen
        }
        elseif (($Percentage -ge 50.0) -and ($Percentage -lt 62.5)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Yellow
        }
        elseif (($Percentage -ge 62.5) -and ($Percentage -lt 75.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkYellow
        }
        elseif (($Percentage -ge 75.0) -and ($Percentage -lt 87.5)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Magenta
        }
        elseif (($Percentage -ge 87.5) -and ($Percentage -lt 100.0)) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor Red
        }
        elseif ($Percentage -ge 100.0) {
            Write-Host ('{0,15:n3}  %' -f $Percentage) -ForegroundColor DarkRed
        }
    }
}

Function Format-PercentageColorSplit7NoNewline {
param (
    [Double]$Percentage
)
    if ($Percentage -lt 0.0) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor White -NoNewline
    }
    elseif ($Percentage -lt 12.5) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor Cyan -NoNewline
    } 
    elseif (($Percentage -ge 12.5) -and ($Percentage -lt 25.0)) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor DarkCyan -NoNewline
    }
    elseif (($Percentage -ge 25.0) -and ($Percentage -lt 37.5)) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor Green -NoNewline
    }
    elseif (($Percentage -ge 37.5) -and ($Percentage -lt 50.0)) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor DarkGreen -NoNewline
    }
    elseif (($Percentage -ge 50.0) -and ($Percentage -lt 62.5)) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor Yellow -NoNewline
    }
    elseif (($Percentage -ge 62.5) -and ($Percentage -lt 75.0)) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor DarkYellow -NoNewline
    }
    elseif (($Percentage -ge 75.0) -and ($Percentage -lt 87.5)) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor Magenta -NoNewline
    }
    elseif (($Percentage -ge 87.5) -and ($Percentage -lt 100.0)) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor Red -NoNewline
    }
    elseif ($Percentage -ge 100.0) {
        Write-Host ('{0,7:n3} %' -f $Percentage) -ForegroundColor DarkRed -NoNewline
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
    for ($i = 0; $i -lt 8; $i++) {
        Write-Host (" " * ($max_length - 1))
    }
    
    $counterList = @(
        '\Processor(_Total)\% Processor Time',   # 0
        '\Processor(_Total)\% User Time'         # 1
        '\Processor(_Total)\% Privileged Time'   # 2
        '\Processor(_Total)\% DPC Time'          # 3
        '\Memory\% Committed Bytes In Use',      # 4
        '\Memory\Available Bytes',               # 5
        '\Process(_total)\Working Set',          # 6 total
        '\Memory\Committed Bytes',               # 7 
        '\Memory\Commit Limit',                  # 8 total
        
        '\Hyper-V Dynamic Memory VM(vm)\guest available memory' # 9
        '\Hyper-V Dynamic Memory VM(vm)\physical memory'        # 10

        '\PhysicalDisk(_Total)\Disk Read Bytes/sec', # 11
        '\PhysicalDisk(_Total)\Disk Write Bytes/sec',# 12

        '\Network Interface(*)\Bytes Received/sec',  # 13
        '\Network Interface(*)\Bytes Sent/sec'   # 14



    )
    $timestamp = 0

    $disk_read_sum = 0
    $disk_write_sum = 0
    $network_received_sum = 0
    $network_sent_sum = 0
    
    while ($true) {
        #_alloc_space_Get-Performance
        $max_height = [System.Console]::get_WindowHeight()
        $cursor_start_height = $max_height - 11
        [System.Console]::SetCursorPosition(0, $cursor_start_height)
        
        $originalCulture = [System.Threading.Thread]::CurrentThread.CurrentCulture
        [System.Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
        $currentTime = Get-Date -Format "MMM. dd, yyyy   HH:mm:ss"
        [System.Threading.Thread]::CurrentThread.CurrentCulture = $originalCulture
        
        try {
            $Script:counterData = Get-Counter -Counter $counterList -ErrorAction Ignore
        }
        catch {
            continue
        }
        
        $counterValues = $counterData.CounterSamples | ForEach-Object { [math]::Round($_.CookedValue, 3) }
        $memory_total = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum

        $cpu_usage = $counterValues[0]
        $cpu_user_usage = $counterValues[1]
        $cpu_privileged_usage = $counterValues[2]
        $cpu_dpc_usage = $counterValues[3]
        $memory_avail = $counterValues[5]
        $memory_used = $memory_total - $memory_avail
        $memory_usage_percentage = $memory_used / $memory_total * 100
        $disk_read = $counterValues[11]
        $disk_write = $counterValues[12]
        
        # $process_working_set = $counterValues[6]
        
        $memory_committed_percentage = $counterValues[4]
        $memory_commited = $counterValues[7]
        $memory_commit_limit = $counterValues[8]

    
        Write-Host "Forever Performance Monitor 3                                                                        " -ForegroundColor Yellow
        Write-Host $currentTime -ForegroundColor Green -NoNewline
        Write-Host "                " -NoNewline
        Write-Host ('{0,4:n0}:' -f (Convert-Timestamp -timestamp $timestamp -Days)) -ForegroundColor DarkCyan -NoNewline
        Write-Host ('{0,3:n0}:' -f (Convert-Timestamp -timestamp $timestamp -Hours)) -ForegroundColor DarkCyan -NoNewline
        Write-Host ('{0,3:n0}:' -f (Convert-Timestamp -timestamp $timestamp -Minutes)) -ForegroundColor DarkCyan -NoNewline
        Write-Host ('{0,3:n0}' -f (Convert-Timestamp -timestamp $timestamp -Seconds)) -ForegroundColor DarkCyan -NoNewline
        Write-Host ('                                                ')
        

        Write-Host "CPU      Usage   : " -ForegroundColor DarkYellow -NoNewline
        # Write-Host ('{0,15:n3}  %                                                                  ' -f $cpu_usage)
        Format-PercentageColor -Percentage $cpu_usage -NoNewline
        Write-Host ('    ') -NoNewline
        Write-Host ('[User]') -ForegroundColor Black -BackgroundColor DarkGray -NoNewline
        Format-PercentageColorSplit7NoNewline -Percentage $cpu_user_usage
        Write-Host ('    ') -NoNewline
        Write-Host ('[Privileged]') -ForegroundColor Black -BackgroundColor DarkGray -NoNewline
        Format-PercentageColorSplit7NoNewline -Percentage $cpu_privileged_usage
        Write-Host ('    ') -NoNewline
        Write-Host ('[Driver]') -ForegroundColor Black -BackgroundColor DarkGray -NoNewline
        Format-PercentageColorSplit7NoNewline -Percentage $cpu_dpc_usage
        Write-Host (' ')
        # Write-Host ('                                                                  ')
    
        Write-Host "Physical Memory  : " -ForegroundColor DarkYellow -NoNewline
        # Write-Host ('{0,15:n3}  % ' -f $memory_usage_percentage) -NoNewline
        Format-PercentageColor -Percentage $memory_usage_percentage -NoNewline
        Write-Host '  ' -NoNewline
        Write-Host ('{0,21:n} B ' -f $memory_used) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($memory_used)) -NoNewline
        Write-Host '/' -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($memory_total))

        Write-Host "Total    Commited: " -ForegroundColor DarkYellow -NoNewline
        # Write-Host ('{0,15:n3}  % ' -f $memory_committed_percentage) -NoNewline
        Format-PercentageColor -Percentage $memory_committed_percentage -NoNewline
        # Write-Host (Format-BytesToString($($process_working_set))) -NoNewline
        Write-Host '  ' -NoNewline
        Write-Host ('{0,21:n} B ' -f $memory_commited) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($($memory_commited))) -NoNewline
        Write-Host '/' -ForegroundColor DarkGray -NoNewline
        # Write-Host ('{0,21:n} B ' -f $memory_commit_limit) -ForegroundColor DarkGray
        Write-Host (Format-BytesToString($($memory_commit_limit))) 

        $disk_read_sum += $($disk_read)
    
        Write-Host "Disk     Read    : " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($($disk_read))) -NoNewline
        Write-Host ('{0,21:n}  B ' -f $($disk_read)) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($disk_read_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total                ' -ForegroundColor DarkCyan
        
        $disk_write_sum += $($disk_write)
        
        Write-Host "Disk     Write   : " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($($disk_write))) -NoNewline
        Write-Host ('{0,21:n}  B ' -f $($disk_write)) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($disk_write_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total                ' -ForegroundColor DarkCyan
    
        # 统计每个网卡的 自己加 （总长度 - 其他计数器） / 2
        $network_index_length = ($counterValues.Length - 13) / 2
        
        $network_received_index = 13
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
        
        Write-Host "Network  Received: " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($network_received_value)) -NoNewline
        Write-Host ('{0,21:n}  B ' -f $network_received_value) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($network_received_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total                ' -ForegroundColor DarkCyan
    
        Write-Host "Network  Sent    : " -ForegroundColor DarkYellow -NoNewline
        Write-Host (Format-BytesToString($network_sent_value)) -NoNewline
        Write-Host ('{0,21:n}  B ' -f $network_sent_value) -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($network_sent_sum)) -ForegroundColor DarkCyan -NoNewline
        Write-Host 'Total                ' -ForegroundColor DarkCyan


        $Script:hyperV_memory_allocating = $False
        $hyperV_memory_avail = $counterValues[9] * 1048576
        $hyperV_memory_total = $counterValues[10] * 1048576
        if ($Script:hyperV_memory_total_old -ne $hyperV_memory_total) {
            $Script:hyperV_memory_total_old = $hyperV_memory_total
            $Script:hyperV_memory_allocating = $True
        }
        $hyperV_memory_usage = $hyperV_memory_total - $hyperV_memory_avail
        $hyperV_memory_usage_percentage = $hyperV_memory_usage / $hyperV_memory_total * 100

        Write-Host "Hyper-V  Memory  : " -ForegroundColor DarkYellow -NoNewline
        Format-PercentageColor -Percentage $hyperV_memory_usage_percentage -NoNewline
        # Write-Host ('{0,15:n3}  % ' -f $hyperV_memory_usage_percentage) -NoNewline
        if ($Script:hyperV_memory_allocating -eq $True) {
            Write-Host '       [ALLOCATING]       ' -ForegroundColor Green -NoNewline
        }
        else {
            Write-Host '                          ' -NoNewline
        }

        Write-Host (Format-BytesToString($hyperV_memory_usage)) -NoNewline
        Write-Host '/' -ForegroundColor DarkGray -NoNewline
        Write-Host (Format-BytesToString($hyperV_memory_total))
        
        $timestamp += 1
        
        if ([System.Console]::KeyAvailable) {
            if ([System.Console]::ReadKey($true).Key -eq 'q') {
                break
            }
            if ([System.Console]::ReadKey($true).Key -eq 'c') {
                [System.Console]::SetCursorPosition(0, $cursor_start_height)
                for ($i = 0; $i -lt 7; $i++) {
                    Write-Host (" " * ($max_length - 1))
                }
                [System.Console]::SetCursorPosition(0, $max_height - 11)
            }
        }
        
    }
}
