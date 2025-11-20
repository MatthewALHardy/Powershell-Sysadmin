
Connect-MgGraph -Scopes "Device.Read.All"

$devices = Get-MgDevice -All | Where-Object { $_.OperatingSystem -eq "Windows" }

$results = foreach ($device in $devices) {
    $osVersion = $device.OperatingSystemVersion
    $build = [int]($osVersion -Split "\.")[2]

    # Determine OS Category
    if ($build -ge 22000) {
        $osTag = "Windows 11"
    }
    elseif ($build -eq 20348) {
        $osTag = "Windows Server 2022"
    }
    elseif ($build -eq 17763) {
        $osTag = "Windows Server 2019"
    }
    elseif ($build -eq 14393) {
        $osTag = "Windows Server 2016"
    }
    elseif ($build -ge 10240 -and $build -le 19045) {
        $osTag = "Windows 10"
    }
    else {
        $osTag = "Unknown Windows Version"
    }

    [PSCustomObject]@{
        DeviceName   = $device.DisplayName
        OSVersion    = $osVersion
        OSCategory   = $osTag
        DeviceId     = $device.Id
    }
}

$results 