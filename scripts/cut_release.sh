while getopts e:c: opt; do
  case $opt in
    e) env=$OPTARG ;;
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

# Checkout the tagged version to add the commit
if [[ "${CLUTCH_ENV}" = "stage" ]]
then
  TAG_ENV=test
else
  TAG_ENV=stage
fi;
git pull;
TAG_VERSION=$(git tag -l "${TAG_ENV}*" --sort=-v:refname |head -n 1);
echo "Checkout tag: ${TAG_VERSION}";
git checkout -b ${CLUTCH_ENV} tags/${TAG_VERSION};
git push origin ${CLUTCH_ENV};
git checkout main;
git branch -D ${CLUTCH_ENV};
