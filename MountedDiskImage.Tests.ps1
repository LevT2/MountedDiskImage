$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Function Use-MountedDiskImage {
   param ( 
   # Файл образа диска 
   [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)] 
   [ValidateNotNullOrEmpty()] 
   [ValidateScript( { Test-Path -Path $PSItem -PathType Leaf })] 
   [Alias("FullName")] 
   [IO.FileInfo] 
   $Path
   )
  
   process { [MountedDiskImage]::new($Path) }
}




Describe "Testing MountedDiskImage Class loading" {
    BeforeAll {
        $Path = "M:\VM\Hyper-V\Virtual Hard Disks\gen1.vhdx"
    }

    AfterAll {
        Remove-Variable -Name Path
    }

    It "class been loaded and works" {
        $MountedDiskImage = Use-MountedDiskImage -Path $Path 
        $MountedDiskImage.Path | Should -Be $Path
    }
}

Describe "Testing MountedDiskImage Class side effects" {
    BeforeAll {
        $Path = "M:\VM\Hyper-V\Virtual Hard Disks\gen1.vhdx"
        $MountedDiskImage = Use-MountedDiskImage -Path $Path 
    }

    AfterAll {
        Remove-Variable -Name Path -ea SilentlyContinue
    }

    # у меня тест не проходит, потому что буква не назначена
    It "drive letter is assigned" {
        $MountedDiskImage.DriveLetter | Should Match '[B-Z]'
    }
}