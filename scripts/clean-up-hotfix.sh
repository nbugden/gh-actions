# Clean up release branches
git checkout main;
git branch -D hotfix;
git push --delete origin hotfix;