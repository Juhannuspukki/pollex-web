#!/bin/dash -e

STAGE=$1
if [ -z "$STAGE" ]; then
  STAGE=dev
fi

hugo --theme=hugo-nel-theme
cd public
aws s3 sync --delete . s3://neuroeventlabs.com/${STAGE}/

for INDEX in $(find * -name index.html); do
  if [ "${INDEX}" = "index.html" ]; then continue; fi
  NEW_INDEX=$(dirname "${INDEX}")
  aws s3 mv "s3://neuroeventlabs.com/${STAGE}/${INDEX}" "s3://neuroeventlabs.com/${STAGE}/${NEW_INDEX}"
done

case "$STAGE" in
  "dev") aws cloudfront create-invalidation --distribution-id E1BGBPLIALP0R5 --paths '/*'
  ;;
  "www") aws cloudfront create-invalidation --distribution-id E2AUAKAPDCJ120 --paths '/*'
  ;;
esac
