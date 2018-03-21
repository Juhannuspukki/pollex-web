#!/bin/sh -xe

STAGE=$1

hugo --theme=pollex
cd public
aws s3 sync --delete . s3://pollex.club
for INDEX in $(find * -name index.html); do
  [ "$INDEX" == "index.html" ] && continue
  NEW_INDEX=$(dirname $INDEX)
  aws s3 mv s3://pollex.club/${STAGE}/$INDEX s3://pollex.club/${STAGE}/${NEW_INDEX}
done