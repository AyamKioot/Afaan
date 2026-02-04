@echo off

powershell -command "Add-Type @'
using System;
using System.Runtime.InteropServices;
public class W {
    [DllImport(\"user32.dll\")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport(\"user32.dll\")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
'@; [W]::ShowWindow([W]::GetForegroundWindow(),6)"
