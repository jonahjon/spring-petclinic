cdk deploy "*"

export ACCOUNT_ID=164382793440

aws configure add-model --service-model file://flux-2017-07-25.normal.json --service-name flux

aws flux help

export AWS_DEFAULT_REGION=us-east-1

export FLUX_ENDPOINT=https://1ylqtfn3q5.execute-api.us-east-1.amazonaws.com/privatebeta

export VPC_1=vpc-012d4280805bcd2b3

export VPC_2=vpc-0c32515ef9e72d244

#Create Role
aws cloudformation create-stack --stack-name AWSFluxRole \
    --template-url https://aws-flux-role-644128927965-us-east-1.s3.amazonaws.com/aws_flux_role_beta.yml \
    --parameters ParameterKey=capabilities,ParameterValue=CAPABILITY_NAMED_IAM

# Test Role
aws flux --endpoint-url $FLUX_ENDPOINT --region us-east-1 list-environments

# Create Environment
aws flux --endpoint-url $FLUX_ENDPOINT \
    create-environment \
    --name flux-workshop \
    --description flux-workshop-desciption \
    --network-fabric-type TRANSIT_GATEWAY

export FLUXID=$(aws flux --endpoint-url $FLUX_ENDPOINT list-environments | jq -r '.EnvironmentList[0].EnvironmentId')

# Associate if using multi account
# aws flux --endpoint-url $FLUX_ENDPOINT \
#     create-account-association \
#     --environment-id $FLUXID \
#     --account-id $OTHER_ACCOUNT_ID

#create-services
aws flux --endpoint-url $FLUX_ENDPOINT \
    create-service \
    --name pet-clinic \
    --description pet-clinic-monolith \
    --vpc-id $VPC_1

aws flux --endpoint-url $FLUX_ENDPOINT \
    create-service \
    --name visits \
    --description visits-service \
    --vpc-id $VPC_2

export MONOLITH_SERVICE=$(aws flux --endpoint-url $FLUX_ENDPOINT list-services | jq -r '.ServiceList[1].ServiceId')
export VISITS_SERVICE=$(aws flux --endpoint-url $FLUX_ENDPOINT list-services | jq -r '.ServiceList[0].ServiceId')

#associate services
aws flux --endpoint-url $FLUX_ENDPOINT \
    create-service-association \
    --environment-id $FLUXID \
    --service-id $MONOLITH_SERVICE

aws flux --endpoint-url $FLUX_ENDPOINT \
    create-service-association \
    --environment-id $FLUXID \
    --service-id $VISITS_SERVICE

aws flux --endpoint-url $FLUX_ENDPOINT list-service-associations --environment-id $FLUXID

#Create application

aws flux --endpoint-url $FLUX_ENDPOINT \
    create-application \
    --environment-id $FLUXID \
    --application-name pet-clinic \
    --vpc-id $VPC_1

export APPLICATION_ID=$(aws flux --endpoint-url $FLUX_ENDPOINT list-applications --environment-id $FLUXID | jq -r '.ApplicationList[0].ApplicationId')
# Create Default Route

aws flux --endpoint-url $FLUX_ENDPOINT \
    create-route \
    --application-id $APPLICATION_ID \
    --route-type DEFAULT \
    --destination-uri http://ecs-m-EcsLb-1FYGDCKBNE008-2000751510.us-east-1.elb.amazonaws.com

aws flux --endpoint-url $FLUX_ENDPOINT \
    create-route \
    --application-id $APPLICATION_ID \
    --route-type URI_PATH \
    --destination-uri http://visit-FluxE-WV4H9GSW3A9O-481458264.us-east-1.elb.amazonaws.com \
    --source-path /api/visit