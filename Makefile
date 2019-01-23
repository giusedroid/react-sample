APPLICATION="react-sample"

ifeq ($(CIRCLE_BRANCH), master)
	DEPLOY_ENV=unstable # TODO: change it to stable
else
	DEPLOY_ENV=unstable
endif

STACK_NAME=$(DEPLOY_ENV)-$(APPLICATION)-s3-host
BUCKET_NAME=$(STACK_NAME)-bucket

host:
	echo "Deploying S3 Host to $(DEPLOY_ENV)"
	@aws cloudformation deploy \
	--stack-name $(STACK_NAME) \
	--capabilities CAPABILITY_NAMED_IAM \
	--template-file cloudformation/00-s3-host.yml \
	--parameter-overrides \
	Environment=$(DEPLOY_ENV) \
	Application=$(APPLICATION) \
	BucketName=$(BUCKET_NAME) \
	--no-fail-on-empty-changeset
	aws cloudformation describe-stacks \
	--stack-name $(STACK_NAME) \
	--query 'Stacks[0]' > /tmp/host.stack

deploy-app:
	echo "Deploying the application to S3 bucket $(BUCKET_NAME)"
	@aws s3 sync build/ s3://$(BUCKET_NAME)
	
