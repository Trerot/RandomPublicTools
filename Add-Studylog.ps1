# should log my pomodoros to tell me what days i have studied, what i have studied.

# to start with i have 3 categories

# japanese, music theory, general knowledge, Programming.

# just to remember, i did japanese for 1hour 15 mins.
# in the end i want some cool charts with stuff. 


function Add-StudyLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("Japanese", "Dev")]
        $subject,
        [Parameter(Mandatory)]
        [ValidateSet("WaniKani", "Powershell","CSharp","MaruMori","reading")]
        $subsubject,
        $hour = 0,
        $minute = 0
    )
    
    begin {
        # check if logfile exists.
        $logpath = "$env:OneDrive\StudyLog\StudyLog.json"
        if (!(Test-Path $logpath)) {
            #testing the folder
            if (!(Test-Path $env:OneDrive\StudyLog)) {
                New-Item -ItemType Directory $env:OneDrive\StudyLog
            }
            # creating the file
            New-Item -ItemType File $logpath
        }
    }
    
    process {
        # should just append json stuff i guess
        $Object = [PSCustomObject]@{
            Subject    = $subject
            SubSubject = $subsubject
            Date       = Get-Date
            TimeSpent  = New-TimeSpan -Hours $hour -Minutes $minute
        }
        # write it to file
        $json = Get-Content -Path $logpath | ConvertFrom-Json
        $json += $Object
        set-Content -Path $logpath -Value ($json | ConvertTo-Json)
    }
    
    end {
        $json = $null
        $Object = $null
    }
}