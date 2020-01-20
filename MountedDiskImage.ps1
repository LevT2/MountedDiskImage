# Сценарий, должен запускаться с повышенными правами пользователя 
#Requires -RunAsAdministrator 

# Указывает минимальную версию PowerShell, требуемую сценарию. 
#Requires -Version 5.1 

class MountedDiskImage { 
    # Файл образа диска 
    [Parameter(Mandatory)] 
    [ValidateNotNullOrEmpty()] 
    [Alias("FullName")] 
    [IO.FileInfo] 
    $Path 

    [Parameter(Mandatory)] 
    [ValidateNotNullOrEmpty()] 
    [Microsoft.Management.Infrastructure.CimInstance] 
    $Image 

    [Parameter(Mandatory)] 
    [ValidateNotNullOrEmpty()] 
    [char] 
    $DriveLetter 

    MountedDiskImage($Path) { 
        $this.Path = $Path 
        $this.Image = $this.GetImage() 

        if (-not ($this.Image.Attached)) { 
            $this.Mount() 
        } 

        $this.GetDriveLetter() 
    } 

    hidden [Microsoft.Management.Infrastructure.CimInstance] GetImage() { 
        return Get-DiskImage -ImagePath $this.Path 
    } 

    hidden [void] GetDriveLetter() { 
        switch ($this.Image.StorageType) { 
            1 { $this.GetDriveLetterISO() } 
            2 { $this.GetDriveLetterVHD() } 
            3 { $this.GetDriveLetterVHD() } 
            Default { throw "Неизвестный тип хранения образа диска" } 
        } 
    } 

    hidden [void] Mount() { 
        $this.Image = Mount-DiskImage -ImagePath $this.Path 
    } 

    hidden [void] GetDriveLetterISO() { 
        $this.DriveLetter = ($this.Image | Get-Volume).DriveLetter 
    } 

    hidden [void] GetDriveLetterVHD() { 
        $this.DriveLetter = ( 
            $this.Image | Get-Disk | Get-Partition | Get-Volume 
        ).DriveLetter 
    } 
} 
 

