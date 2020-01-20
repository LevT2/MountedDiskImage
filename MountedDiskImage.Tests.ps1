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
     
      
    process { try { [MountedDiskImage]::new($Path) } catch { $Error[0].Exception.Message } }
}

Describe "Test MountedDiskImage Class loading" {
    BeforeAll {
        $Path = "M:\VM\Hyper-V\Virtual Hard Disks\gen1.vhdx"
    }

    AfterAll {
        Remove-Variable -Name Path
    }

    It "class has been loaded and works" {
        $MountedDiskImage = $Path | Use-MountedDiskImage 
        $MountedDiskImage.Path | Should -Be $Path
    }
}

Describe "Test MountedDiskImage Class side effects" {
    BeforeAll {
        $Path = "M:\VM\Hyper-V\Virtual Hard Disks\gen1.vhdx"
        $MountedDiskImage = $Path | Use-MountedDiskImage 
    }

    AfterAll {
        Remove-Variable -Name Path -ea SilentlyContinue
    }

    # у меня тест не проходит, потому что буква не назначена
    It "drive letter is assigned" {
        $MountedDiskImage.DriveLetter | Should Match '[B-Z]'
    }

    It 'works with multiple images' {

    }
}

Describe "Test MountedDiskImage Class working with arrays" {
    BeforeAll {
        $Path = @("M:\VM\Hyper-V\Virtual Hard Disks\gen1.vhdx", 'G:\synoboot.vhd')
        $MountedDiskImage = $Path | Use-MountedDiskImage 
    }

    AfterAll {
        Remove-Variable -Name Path -ea SilentlyContinue
    }

    # у меня тест не проходит, потому что буква не назначена
    It "drive letter is assigned" {
        $MountedDiskImage.DriveLetter | Should Match '[B-Z]'
    }

    It 'works with multiple images' {

    }
}