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
LOCAL_ALIAS="local-blue"

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

host-local:
	echo "Deploying the $(LOCAL_ALIAS)-$(APPLICATION) from a local machine"
	echo "Make sure you have aws cli configured :P"
	@aws cloudformation deploy \
	--stack-name "$(LOCAL_ALIAS)-$(APPLICATION)-s3-host" \
	--capabilities CAPABILITY_NAMED_IAM \
	--template-file cloudformation/00-s3-host.yml \
	--parameter-overrides \
	Environment="$(LOCAL_ALIAS)" \
	Application="$(APPLICATION)" \
	BucketName="$(LOCAL_ALIAS)-$(APPLICATION)-bucket" \
	--no-fail-on-empty-changeset

build-local:
	npm run build

deploy-app:
	echo "Deploying the application to S3 bucket $(BUCKET_NAME)"
	@aws s3 sync build/ s3://$(BUCKET_NAME)

deploy-app-local:
	echo "Deploying the application to S3 bucket $(LOCAL_ALIAS)-$(APPLICATION)-bucket"
	echo "Make sure you have aws cli configured :P"
	ls -la
	@aws s3 sync build/ s3://$(LOCAL_ALIAS)-$(APPLICATION)-bucket

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
	HostedZoneId="$(HOSTED_ZONE_ID)" \
	--no-fail-on-empty-changeset

cdn-local:
	echo "Deploying CDN from local machine"
	echo "Make sure you have aws cli configured :P"
	@aws cloudformation deploy \
	--stack-name "$(LOCAL_ALIAS)-$(APPLICATION)-cdn" \
	--capabilities CAPABILITY_NAMED_IAM \
	--template-file cloudformation/10-cloudfront.yml \
	--parameter-overrides \
	Environment="$(LOCAL_ALIAS)" \
	BucketName="$(LOCAL_ALIAS)-$(APPLICATION)-bucket" \
	TargetDomainName="react-sample-$(LOCAL_ALIAS).appmod.aws.crlabs.cloud" \
	SSLCertARN="$(CLOUDFRONT_SSL_CERT_ARN)" \
	HostedZoneId='$(HOSTED_ZONE_ID)' \
	--no-fail-on-empty-changeset

local:
	make host-local
	make build-local
	make deploy-app-local
	make cdn-local