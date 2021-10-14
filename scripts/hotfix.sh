
#!/bin/bash

while getopts t:c: opt; do
  case $opt in
    t) tag=$OPTARG ;;
    c) commit=$OPTARG ;;
    *)
      echo 'Error in command line parsing' >&2
      exit 1
  esac
done

shift "$(( OPTIND - 1 ))"

# Set and check tag to use as base for cherry pick
if [ -z "$tag" ]
  then
    read -p "Tag to use as the base for the hotfix: " LATEST_TAG;
  else
    LATEST_TAG="$env";
fi

# Set and check the commit to cherry pick for deployment
if [ -z "$commit" ]
  then
    read -p "Commit to cherry pick: " COMMIT;
  else
    COMMIT="$commit";
fi
if [[ $(git branch --contains $COMMIT) ]]
  then
    BRANCH=$(git branch --contains $COMMIT | sed 's/\* //g');
    echo "Commit found in $BRANCH";
    continue;
  else
    echo "ERROR: cannot find commit to cherry-pick. Try running `git pull \&\& git pull --tags` before running the hotfix script. Exiting deployment of hotfix.\n"
    exit;
  fi;


# Checkout the tagged version to add the commit
git pull;
git pull --tags;
echo "Checkout tag: ${LATEST_TAG}";
git checkout -b hotfix ${LATEST_TAG};
git branch --set-upstream-to=origin/hotfix hotfix

# Cherry pick commit for deployment
git cherry-pick $COMMIT;
git push origin hotfix;

# Clean up release branches
git checkout main;
git branch -D hotfix;
