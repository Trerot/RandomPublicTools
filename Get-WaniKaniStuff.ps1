# i want to know how many reviews i have done on a given day.
# how many apprentice i have gotten, how many apprentice i have gotten rid of.

# gettinng the token.
$credfile = "$env:USERPROFILE\creds\wanikani.xml"

if (!(Test-Path $credfile)) {
    # cred file doesnt exisist.
    $token = read-host -Prompt 'type/paste in token' -AsSecureString
    $token | Export-Clixml $credfile -Force
}
$token = Import-Clixml $credfile
$today = get-date -format "yyyy-MM-dd" 
$reviewStats = "https://api.wanikani.com/v2/review_statistics?updated_after=" + $today + "T00:00:00.000000Z2 00:00:00" 

get-date -hour 0 
$headers = @{
    "Wanikani-Revision" = 20170710
    "Authorization"     = "Bearer $($token | ConvertFrom-SecureString -AsPlainText)"
}

$stuff = Invoke-RestMethod -Headers $headers -uri $reviewStats

$FailedMeaning = $stuff.data.where({ $_.data.meaning_current_streak -eq 1 })
$FailedReading = $stuff.data.where({ $_.data.reading_current_streak -eq 1 })
$ReviewsDoneToday = $stuff.total_count

$meaningCorrectPercentage = [int32](100 / $ReviewsDoneToday * ($ReviewsDoneToday - $FailedMeaning.count))
$readingCorrectPercentage = [int32](100 / $ReviewsDoneToday * ($ReviewsDoneToday - $FailedReading.count))

Write-output "Today you have done $ReviewsDoneToday reviews"
Write-Output "reading correct percentage $readingCorrectPercentage%"
Write-Output "meaning correct percentage $meaningCorrectPercentage%"