
#!/bin/bash

while getopts e:c: opt; do
  case $opt in
    e) env=$OPTARG ;;
    c) commit=$OPTARG ;;
    *)
      echo 'Error in command line parsing' >&2
      exit 1
  esac
done

shift "$(( OPTIND - 1 ))"

# Set and check clutch env
if [ -z "$env" ]
  then
    read -p "Clutch Environment to deploy the hotfix (stage, prod): " CLUTCH_ENV;
  else
    CLUTCH_ENV="$env";
fi

if [[ "${CLUTCH_ENV}" == 'stage' || "${CLUTCH_ENV}" == 'prod' ]]
  then
    continue
  else
    echo "ERROR: $CLUTCH_ENV must be equal to \"stage\" or \"prod\".\nExiting deployment of hotfix.\n"
    exit
  fi;

# Set and check branch/commit to cherry pick for deployment
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
    echo "$BRANCH""Exiting Deployment of hotfix.\n"
    exit;
  fi;

# Checkout the tagged version to add the commit
git pull;
git pull --tags;
TAG_VERSION=$(git tag -l "${CLUTCH_ENV}*" --sort=-v:refname |head -n 1);
echo "Checkout tag: ${TAG_VERSION}";
git checkout -b ${CLUTCH_ENV} ${TAG_VERSION};

# Cherry pick commit for deployment
git cherry-pick $COMMIT;
git push origin ${CLUTCH_ENV};

# Clean up release branches
git checkout main;
git branch -D ${CLUTCH_ENV};
