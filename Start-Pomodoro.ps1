# im missing something to break it on button press, and to log my session to a logfile of somesort.
# pause button. 
# i havent looked at this https://gist.github.com/artkpv/60f1813d27d27f17431e154b9da63c59 but first hit on pomo timer powershett
# this might be cool https://www.youtube.com/watch?v=I2lr7dakOLc havent looked at it yet. something powershell productitiy bliss pomodoro

# I want an overtime function. once i surpass 25 minutes, or whatever i sett my timer at, 
# it should do the warning sound, and continue timing the pomodoro. 
# that way i can logg those few or many minutes of overtim.
# then press the 'start your pause' button


function Start-Pomo {
    [CmdletBinding()]
    param (
        [int]$minutes = 25,
        $subject = 'japanese',
        $subsubject = 'wanikani'
    )
    
    begin {
        $seconds = $minutes * 60
    }
    
    process {
        #starting a timer
        $processTimer = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            while ($processTimer.Elapsed.minutes -lt $minutes) {
                $percentComplete = (100 / $seconds * $processTimer.Elapsed.TotalSeconds)
                Write-Progress  -SecondsRemaining ($seconds - $processTimer.Elapsed.TotalSeconds) -Activity "$($minutes-[int32]$processTimer.Elapsed.TotalMinutes) minutes left" -PercentComplete (100 / $seconds * $processTimer.Elapsed.TotalSeconds)
                start-sleep -Seconds 1
            }
        }
        finally {
            $processTimer.Stop()
            write-host "this is the end"
            $totalMinutesRound = [math]::round($($processTimer.Elapsed.TotalMinutes))
            Write-host "You did $totalminutesround minutes and $($processTimer.Elapsed.Seconds) seconds"
            add-StudyLog -subject $subject -subsubject $subsubject -minute $totalMinutesRound
            Write-Host "pomodoro logged."
        }


    }

}