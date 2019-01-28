APPLICATION="react-sample"

ifeq ($(CIRCLE_BRANCH), master)
	DEPLOY_ENV=stable
else
	DEPLOY_ENV=unstable
endif

STACK_NAME="$(DEPLOY_ENV)-$(APPLICATION)-s3-host"
BUCKET_NAME="$(STACK_NAME)-bucket"
CDN_STACK_NAME="$(DEPLOY_ENV)-$(APPLICATION)-cdn"
TARGET_DOMAIN_NAME="$(APPLICATION_NAME)-$(DEPLOY_ENV).$(APPLICATION_DOMAIN_NAME)"

host:
	echo "Deploying $(STACK_NAME) to $(DEPLOY_ENV)"
	@aws cloudformation deploy \
	--stack-name "$(STACK_NAME)" \
	--capabilities CAPABILITY_NAMED_IAM \
	--template-file cloudformation/00-s3-host.yml \
	--parameter-overrides \
	Environment=$(DEPLOY_ENV) \
	Application="$(APPLICATION)" \
	BucketName="$(BUCKET_NAME)" \
	--no-fail-on-empty-changeset

deploy-app:
	echo "Deploying the application to S3 bucket $(BUCKET_NAME)"
	ls -la
	@aws s3 sync build/ s3://$(BUCKET_NAME)

cdn:
	echo "Deploying CDN on $(DEPLOY_ENV)"
	@aws cloudformation deploy \
	--stack-name "$(CDN_STACK_NAME)" \
	--capabilities CAPABILITY_NAMED_IAM \
	--template-file cloudformation/10-cloudfront.yml \
	--parameter-overrides \
	Environment="$(DEPLOY_ENV)" \
	BucketName="$(BUCKET_NAME)" \
	TargetDomainName="$(TARGET_DOMAIN_NAME)" \
	SSLCertARN="$(CLOUDFRONT_SSL_CERT_ARN)" \
	--no-fail-on-empty-changeset

cdn-local:
	echo "Deploying CDN on $(DEPLOY_ENV)"
	@aws cloudformation deploy \
	--stack-name "local-$(CDN_STACK_NAME)" \
	--capabilities CAPABILITY_NAMED_IAM \
	--template-file cloudformation/10-cloudfront.yml \
	--parameter-overrides \
	Environment="$(DEPLOY_ENV)" \
	BucketName="$(BUCKET_NAME)" \
	TargetDomainName="$(TARGET_DOMAIN_NAME)" \
	SSLCertARN="$(CLOUDFRONT_SSL_CERT_ARN)" \
	--no-fail-on-empty-changeset
