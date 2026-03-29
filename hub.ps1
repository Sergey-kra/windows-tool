Write-Host "=== Master SysAdmin Hub (OSINT & Automation Edition) ===" -ForegroundColor Cyan
Write-Host "Единая точка входа для развертывания и настройки Windows"
Write-Host ""

Write-Host "ДОСТУПНЫЕ ИНСТРУМЕНТЫ:" -ForegroundColor Yellow
Write-Host "[1] WinUtil (Chris Titus Tech) — Графический комбайн"
Write-Host "[2] Scoop — Установка изолированного пакетного менеджера"
Write-Host "[3] Chocolatey — Установка корпоративного пакетного менеджера"
Write-Host "[4] Активатор MAS — Лицензирование Windows и Office"
Write-Host "[5] Мой личный набор — Тихая установка (Chrome, Wireshark, v2ray и др.)"
Write-Host "[6] Харденинг реестра — Применить настройки безопасности"
Write-Host "[0] Выход"
Write-Host ""

$choice = Read-Host "Введи номер нужного инструмента"

switch ($choice) {
    '1' {
        Write-Host "`n-> Запуск WinUtil..." -ForegroundColor Green
        irm "https://christitus.com/win" | iex
    }
    '2' {
        Write-Host "`n-> Установка Scoop..." -ForegroundColor Green
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        Write-Host "Scoop установлен! Попробуй команду: scoop install git" -ForegroundColor Cyan
    }
    '3' {
        Write-Host "`n-> Установка Chocolatey..." -ForegroundColor Green
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Write-Host "Chocolatey установлен! Попробуй команду: choco install notepadplusplus" -ForegroundColor Cyan
    }
    '4' {
        Write-Host "`n-> Запуск MAS..." -ForegroundColor Green
        irm "https://get.activated.win" | iex
    }
    '5' {
        Write-Host "`n-> Развертывание личного набора программ..." -ForegroundColor Green
        $apps = @(
            "Google.Chrome",
            "Mozilla.Firefox",
            "Telegram.TelegramDesktop",
            "7zip.7zip",
            "WiresharkFoundation.Wireshark",
            "PuTTY.PuTTY",
            "WinSCP.WinSCP",
            "Python.Python.3.12",
            "Microsoft.VisualStudioCode",
            "KeePassXCTeam.KeePassXC",
            "IDRIX.VeraCrypt",
            "BleachBit.BleachBit",
            "voidtools.Everything"
        )
        
        foreach ($app in $apps) {
            Write-Host "Ставлю $app..." -ForegroundColor Cyan
            winget install --id $app --silent --accept-package-agreements --accept-source-agreements
        }
        
        Write-Host "Скачиваю v2rayN в C:\Tools..." -ForegroundColor Cyan
        if (!(Test-Path "C:\Tools\v2rayN")) { New-Item -ItemType Directory -Force -Path "C:\Tools\v2rayN" | Out-Null }
        Invoke-WebRequest -Uri "https://github.com/2dust/v2rayN/releases/latest/download/v2rayN-Core.zip" -OutFile "C:\Tools\v2rayN\v2rayN-Core.zip"
        Write-Host "Установка личного набора завершена!" -ForegroundColor Green
    }
    '6' {
        Write-Host "`n-> Применение харденинга (OpSec)..." -ForegroundColor Green
        Set-MpPreference -PUAProtection Enabled -ErrorAction SilentlyContinue
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
        $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
        Set-ItemProperty -Path $RegPath -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "Безопасность настроена!" -ForegroundColor Green
    }
    '0' {
        Write-Host "Выход..." -ForegroundColor Yellow
        exit
    }
    Default {
        Write-Host "Неверный выбор." -ForegroundColor Red
    }
}

Write-Host "`nОперация завершена." -ForegroundColor Green
