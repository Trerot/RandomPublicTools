function Get-DailyStats {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        $date = get-date -hour 4 -Minute 0
        $logpath = "$env:OneDrive\StudyLog\StudyLog.json"
        $Timespent = 0
        $YesterDay = "$env:OneDrive\StudyLog\waniStatsyesterday.json"
    }
    
    process {
        $log = Get-Content $logpath | ConvertFrom-Json
        $dailyStuff= Get-WaniKaniStuff -date $date
        
        $log.where({ $_.date -gt (get-date -hour 4 -Minute 0 ) -and $_.subject -eq "japanese" }).timespent.totalminutes.foreach({
                $Timespent += $_
            })


        Write-host "-- Daily Stats --"
        Write-Host "Timespent: $timespent minutes"
        write-host "-- Wanikani Reviews --"
        $dailyStuff.reviews
        Write-Host "-- todays rank --"
        $dailyStuff.status
        Write-Host "-- todays diff string --"
        $dailyStuff[-1]
        }
    
    end {
        
    }
}


