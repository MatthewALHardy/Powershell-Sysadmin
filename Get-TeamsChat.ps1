#Output the contents of a Specific Teams Chat between two timestamps
param (
    [Parameter(Mandatory=$true)]
    [string]$ChatId,

    [Parameter(Mandatory=$true)]
    [datetime]$StartTime,

    [Parameter(Mandatory=$true)]
    [datetime]$EndTime
)
# Connect to Microsoft Teams

Import-Module MicrosoftTeams
# Note: Ensure you have the necessary permissions and are authenticated to access Teams data
$teamsSession = Connect-MicrosoftTeams
# Fetch chat messages for the specified ChatId
$allMessages = Get-TeamChatMessage -ChatId $ChatId -ErrorAction Stop
# Filter messages based on the provided time range
$filteredMessages = $allMessages | Where-Object {
    ($_.CreatedDateTime -ge $StartTime) -and ($_.CreatedDateTime -le $EndTime)
}
# Output the filtered messages
$filteredMessages | Select-Object CreatedDateTime, From, Body
# Disconnect from Microsoft Teams
Disconnect-MicrosoftTeams -Confirm:$false

