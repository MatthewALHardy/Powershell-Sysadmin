function ConvertTo-IISLogObject {

    Process {
        if (!($_ -like "#*")) {
            $item = $_ -split " "
            $properties = @{
            'date' = $item[0]
            'time' = $item[1]
            'sIP' =  $item[2]
            'csMethod' = $item[3]
            'csUriStem' = $item[4]
            'csUriQuery' = $item[5]
            'sPort' = $item[6]
            'csUserName' = $item[7]
            'cIP' = $item[8]
            'csUserAgent' = $item[9]
            'csReferer' = $item[10]
            'scStatus' = $item[11]
            'scSubStatus' = $item[12]
            'scWin32Status' = $item[13]
            'timeTaken' = $item[41]
            }
        New-Object -TypeName PSObject -Property $properties
        }
    }
}