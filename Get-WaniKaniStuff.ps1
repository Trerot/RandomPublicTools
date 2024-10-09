# i want to know how many reviews i have done on a given day.
# how many apprentice i have gotten, how many apprentice i have gotten rid of.

# gettinng the token.
function Get-WaniKaniStuff {
    [CmdletBinding()]
    param (
        $DateTime
    )
    
    begin {
        $credfile = "$env:USERPROFILE\creds\wanikani.xml"
        if (!(Test-Path $credfile)) {
            # cred file doesnt exisist.
            $token = read-host -Prompt 'type/paste in token' -AsSecureString
            $token | Export-Clixml $credfile -Force
        }
        $token = Import-Clixml $credfile
        $date = (Get-Date).ToString("yyyy-MM-dd")
        if ($datetime) { $date = $DateTime.ToString("yyyy-MM-dd") }
        $reviewStats = "https://api.wanikani.com/v2/review_statistics?updated_after=" + $date + "T00:00:00.000000Z" 

        $headers = @{
            "Wanikani-Revision" = 20170710
            "Authorization"     = "Bearer $($token | ConvertFrom-SecureString -AsPlainText)"
        }
        
    }
    
    process {
        # here goes the reviews done today.
        $stuff = Invoke-RestMethod -Headers $headers -uri $reviewStats
        $FailedMeaning = $stuff.data.where({ $_.data.meaning_current_streak -eq 1 })
        $FailedReading = $stuff.data.where({ $_.data.reading_current_streak -eq 1 })
        $ReviewsDoneToday = $stuff.total_count
        $meaningCorrectPercentage = [int32](100 / $ReviewsDoneToday * ($ReviewsDoneToday - $FailedMeaning.count))
        $readingCorrectPercentage = [int32](100 / $ReviewsDoneToday * ($ReviewsDoneToday - $FailedReading.count))

        $ReviewsDone = [PSCustomObject]@{
            FailedMeaning            = $FailedMeaning.count 
            FailedReading            = $FailedReading.count
            ReviewsDoneToday         = $ReviewsDoneToday
            meaningCorrectPercentage = $meaningCorrectPercentage 
            readingCorrectPercentage = $readingCorrectPercentage 
        }
        # Here goes the amount of each category of things. 
        $data = New-Object -TypeName System.Collections.ArrayList
        $nextURL = 'https://api.wanikani.com/v2/assignments/'
        # it has pages, so need a loop of somekind. while works.
        while ($nextURL -ne $null) {
            $Assignments = Invoke-RestMethod -Headers $headers -uri $nextURL
            $data.Add($Assignments)
            $nextURL = $Assignments.pages.next_url
        }
        # i only realy need the srs_stage numbers. 
        $srsGroup = $data.data.data.srs_stage | Group-Object
        $StatusObject = [PSCustomObject]@{
            Unstarted   = 0
            Apprentice  = 0
            Guru        = 0
            Master      = 0
            Enlightened = 0
            Burned      = 0
        }

        foreach ($Group in $srsGroup) {
    
            switch ($group.name) {
                0 { $statusobject.Unstarted += $group.count }
                { 1..4 -contains $_ } { $statusobject.Apprentice += $group.count }
                { 5..6 -contains $_ } { $statusobject.guru += $group.count }
                7 { $statusobject.master += $group.count }
                8 { $statusobject.enlightened += $group.count }
                9 { $statusobject.burned += $group.count }
                Default {}
            }
        }
        $object = [PSCustomObject]@{
            Reviews = $ReviewsDone
            Status  = $StatusObject
        }
    }
    
    end {
        # done processing! now i have two objects
        $object     
    }
}
