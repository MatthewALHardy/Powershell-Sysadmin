#List all Teams Chat IDs for the logged in user
param (
    [Parameter(Mandatory=$false)]
    [switch]$ShowDetails,
    
    [Parameter(Mandatory=$false)]
    [string]$FilterByTopic
)

# Connect to Microsoft Graph
Import-Module Microsoft.Graph.Teams

# Note: Ensure you have the necessary permissions and are authenticated to access Teams data
# Required scopes: Chat.Read
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Green
Connect-MgGraph -Scopes "Chat.Read"

try {
    Write-Host "Retrieving chats for the logged-in user..." -ForegroundColor Green
    
    # Get all chats for the current user
    $allChats = Get-MgChat -All -ErrorAction Stop
    
    # Apply topic filter if specified
    if ($FilterByTopic) {
        $allChats = $allChats | Where-Object { $_.Topic -like "*$FilterByTopic*" }
    }
    
    if ($ShowDetails) {
        # Show detailed information
        $allChats | Select-Object @{
            Name = "ChatId"
            Expression = { $_.Id }
        }, @{
            Name = "Topic/Title"
            Expression = { if ($_.Topic) { $_.Topic } else { "No Title" } }
        }, @{
            Name = "ChatType"
            Expression = { $_.ChatType }
        }, @{
            Name = "CreatedDateTime"
            Expression = { [datetime]$_.CreatedDateTime }
        }, @{
            Name = "LastUpdated"
            Expression = { [datetime]$_.LastUpdatedDateTime }
        } | Format-Table -AutoSize -Wrap
    } else {
        # Show basic list
        Write-Host "`nFound $($allChats.Count) chats:" -ForegroundColor Yellow
        $allChats | Select-Object @{
            Name = "ChatId"
            Expression = { $_.Id }
        }, @{
            Name = "Title"
            Expression = { if ($_.Topic) { $_.Topic } else { "Direct Chat" } }
        }, @{
            Name = "Type"
            Expression = { $_.ChatType }
        } | Format-Table -AutoSize
    }
    
    # Output summary
    Write-Host "`nSummary:" -ForegroundColor Cyan
    Write-Host "Total Chats Found: $($allChats.Count)" -ForegroundColor White
    
    # Group by chat type
    $chatTypes = $allChats | Group-Object ChatType
    foreach ($type in $chatTypes) {
        Write-Host "$($type.Name): $($type.Count)" -ForegroundColor White
    }
    
} catch {
    Write-Error "Failed to retrieve chats: $($_.Exception.Message)"
    Write-Host "Make sure you have the necessary permissions to read chats." -ForegroundColor Red
} finally {
    # Disconnect from Microsoft Graph
    Write-Host "`nDisconnecting from Microsoft Graph..." -ForegroundColor Green
    Disconnect-MgGraph
}

# Usage Examples:
<#
# Basic usage - list all chat IDs
.\Get-TeamsChatList.ps1

# Show detailed information
.\Get-TeamsChatList.ps1 -ShowDetails

# Filter by topic/title
.\Get-TeamsChatList.ps1 -FilterByTopic "Project Alpha"

# Detailed view with filter
.\Get-TeamsChatList.ps1 -ShowDetails -FilterByTopic "meeting"
#>