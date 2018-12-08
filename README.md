Run Vim script as AWS Lambda application
---

### Requirements

* AWS account with roles(S3 PutObject,Lambda CreateFunction, Lambda UpdateFunction, Lambda Invoke)
* AWS S3 Bucket
* AWS IAM Role for Lambda with Cloud Watch
* Amazon Linux 2 or RHEL like Linux


### Environmental Values to be set

* `BUCKET` - AWS S3 Bucket name to put an artifact file(its name is vim.zip).
* `FILE_NAME` - AWS S3 Key for the archive file.
* `FUNCTION` - A name of Lambda function.
* `ROLE_ARN` - An arn of the Role of Lambda.

### Tasks

* `dep` - installs ncurses-devel/git/Development Tools
* `git-get` - get vim sources
* `vim` - builds vim/ collects libraries/ copy boostrap
* `build` - create archive file
* `prepare` - uploads archive file to S3
* `create` - creates AWS Lambda function
* `deploy` - updates AWS Lambda function
