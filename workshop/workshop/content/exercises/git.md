**Persona: Developers**

The inital version of our project is now ready to be pushed to a repository of a version control system like GIT to make it available to other team members.

```terminal:execute
command: |
  git init
  git branch -M main
  git remote add origin $GIT_URL
  git add .
  git commit -m "Initial commit"
  git push -u origin main
clear: true
```