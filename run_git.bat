@echo off
echo Running git status... > git_log.txt
git status >> git_log.txt 2>&1
echo. >> git_log.txt
echo Running git add... >> git_log.txt
git add . >> git_log.txt 2>&1
echo. >> git_log.txt
echo Running git commit... >> git_log.txt
git commit -m "Handle duplicate form submission error" >> git_log.txt 2>&1
echo. >> git_log.txt
echo Running git push... >> git_log.txt
git push >> git_log.txt 2>&1
type git_log.txt
