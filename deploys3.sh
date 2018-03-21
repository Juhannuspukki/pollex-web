#!/bin/sh -xe

hugo --theme=pollex
cd public
aws s3 sync --delete . s3://pollex.club
aws s3 cp . s3://pollex.club --recursive