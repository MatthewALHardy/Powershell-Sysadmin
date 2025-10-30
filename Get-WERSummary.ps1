$werFiles = Get-ChildItem -Path 'C:\ProgramData\Microsoft\Windows\WER\ReportArchive','C:\Users\*\AppData\Local\Microsoft\Windows\WER' -Filter *.wer -Recurse -ErrorAction SilentlyContinue

$epoch = [datetime]::Parse("1601-01-01T00:00:00Z")

$results = foreach ($file in $werFiles) {
    $data = @{}
    foreach ($line in Get-Content $file.FullName) {
        if ($line -match '^(.*?)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            $data[$key] = $value
        }
    }
    $seconds = $data['EventTime'] / 10000000
    $convertedDate = $epoch.AddSeconds($seconds)

    [PSCustomObject]@{
        WERFilePath      = $file.FullName
        WERFileTimestamp = (Get-Item $file.FullName).CreationTime
        EventTime  = $convertedDate 
        'Application Name'    = $data['AppName']
        'Application Path'    = $data['AppPath']
        'Original Filename'    = $data['OriginalFilename']
        EventType = $data['EventType']
        ReportType    = $data['FriendlyEventName']
    }
}

# Output Results
$results
