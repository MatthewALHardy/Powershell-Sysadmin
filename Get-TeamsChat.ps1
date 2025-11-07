#Output the contents of a Specific Teams Chat between two timestamps
param (
    [Parameter(Mandatory=$true)]
    [string]$ChatId,

    [Parameter(Mandatory=$true)]
    [datetime]$StartTime,

    [Parameter(Mandatory=$true)]
    [datetime]$EndTime
)

# Install-Module -Name Microsoft.Graph -Force -AllowClobber -ErrorAction SilentlyContinue
# Connect to Microsoft Graph
Import-Module Microsoft.Graph.Teams

# Note: Ensure you have the necessary permissions and are authenticated to access Teams data
# Required scopes: Chat.Read, Chat.ReadWrite
Connect-MgGraph -Scopes "Chat.Read", "Chat.ReadWrite"

# Fetch chat messages for the specified ChatId
try {
    #TODO: look at filetering at API level to reduce data transfer
    $allMessages = Get-MgChatMessage -ChatId $ChatId -All -ErrorAction Stop
    
    # Filter messages based on the provided time range
    $filteredMessages = $allMessages | Where-Object {

        ([datetime]$_.CreatedDateTime -ge $StartTime) -and ([datetime]$_.CreatedDateTime -le $EndTime)
    }
    
    # Output the filtered messages with proper formatting
    $filteredMessages | Select-Object @{
        Name = "CreatedDateTime"
        Expression = { [datetime]$_.CreatedDateTime }
    }, @{
        Name = "From"
        Expression = { $_.From.User.DisplayName }
    }, @{
        Name = "Body"
        Expression = { $_.Body.Content }
    } | Sort-Object CreatedDateTime | Format-Table -AutoSize
    
} catch {
    Write-Error "Failed to retrieve chat messages: $($_.Exception.Message)"
    Write-Host "Make sure you have the correct ChatId and necessary permissions."
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph

