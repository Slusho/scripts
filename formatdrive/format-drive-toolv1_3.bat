@echo off
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Unrestricted','-File %~dpn0.ps1' -Verb RunAs"
pause