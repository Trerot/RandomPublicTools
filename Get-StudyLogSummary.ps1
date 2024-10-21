# i want it to sum up the studies done for the current week, and the previous. sorted by subject and subsubject.
# missing for current day. 
function Get-StudyLogSummary {
    [CmdletBinding()]
    param (
        [switch]$weekly,
        [switch]$7days
    )
    
    begin {
        $today = get-date
        $Last7Days = $today.AddDays(-7)
        $StartOfWeek = $today.AddDays( - ($today.DayOfWeek - [System.DayOfWeek]::Monday) )
        $startofLastWeek = $StartOfWeek.AddDays(-7)
        $endofLastweek = $StartOfWeek.AddDays(-1)


        $logpath = "$env:OneDrive\StudyLog\StudyLog.json"
        $log = Get-Content $logpath | ConvertFrom-Json
    }
    process {
        # split on category.. should probably have a file per category so save the wheres.
        $grouped = $log | Group-Object "Subject"

        foreach ($group in $grouped) {
            # now i do stuff per group, so i guess i dont need to do more stuff.
            # last seven days.
            #adding all the studies.
            $totalhours = 0
            $totalhoursThisWeek = 0
            $totalhoursLastWeek = 0
            $group.group.foreach({
                    if ($_.date -lt $endofLastweek -and $_.date -gt $startofLastWeek) {
                        # hours last week
                        $totalhoursLastWeek += $_.TimeSpent.totalhours
                    }
                    if ($_.date -gt $StartOfWeek) {
                        # hours this week 
                        $totalhoursThisWeek += $_.TimeSpent.totalhours
                    }

                    $totalhours += $_.TimeSpent.totalhours
                })
                '---------------'
            $group.name
            "worked on the subject $($group.name) $totalhours hours"
             "this week $totalhoursthisweek hours"
            "last week $totalhourslastweek hours"
        }

        # here it should get the wani kani stats. 
        $date = $today
        if($weekly){$date = $StartOfWeek}
        if($7days){$date = $Last7Days}
        "---- Wani Kani Stats ----"
       Get-WaniKaniStuff -date $date

    }
    

}