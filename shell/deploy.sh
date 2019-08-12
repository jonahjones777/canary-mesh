#! /bin/bash

export $(xargs <.env)
export $(xargs <tf.env)

cd terraform/mesh-app/files/codebuild_files/

# Use jinja to substitue in the terraform created values into our config files
j2 appspec.yml.j2 > appspec.yml --undefined
j2 task_def.json.j2 > task_def.json --undefined

# move config files to s3
aws s3 cp task_def.json s3://$artifact_bucket_name/task_def.json
aws s3 cp appspec.yml s3://$artifact_bucket_name/appspec.yml

rm -rf appspec.yml
rm -rf task_def.json