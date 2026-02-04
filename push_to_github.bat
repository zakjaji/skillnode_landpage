@echo off
echo ===================================
echo Git Push Script for SkillNode
echo ===================================
echo.

echo [1/4] Checking git status...
git status

echo.
echo [2/4] Adding all changes...
git add .

echo.
echo [3/4] Committing changes...
git commit -m "feat: Implement toast notification system for Supabase error handling"

echo.
echo [4/4] Pushing to GitHub...
git push origin main

echo.
echo ===================================
echo Done!
echo ===================================
pause
