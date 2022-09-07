## Script to mount the volume to Windows.
## In Subsonic, set the FOLDER to '\\butlersa.file.core.windows.net\music'
## The Subsonic Service needs to run as the .\ubuntu user for mapped network drives to work

$connectTestResult = Test-NetConnection -ComputerName butlersa.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"butlersa.file.core.windows.net`" /user:`"localhost\butlersa`" /pass:`"ZBqqVpmQ2Wz7Lupa4ic0C2VdRNxCyJUzfA3MsPsW8T1WayIX2WBMO/ft0A0PoLQMsXMKdmoNZp1D+LrW+IToXw==`""
    # Mount the drive
    New-PSDrive -Name M -PSProvider FileSystem -Root "\\butlersa.file.core.windows.net\music" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}