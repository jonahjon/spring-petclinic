export AWS_DEFAULT_REGION=us-east-1
export ACCOUNT_ID=164382793440

# clonse repo with petclinic 
# git clone https://github.com/spring-projects/spring-petclinic.git


aws configure add-model --service-model file://flux-2017-07-25.normal.json --service-name flux

aws flux help

aws cloudformation create-stack --stack-name AWSFluxRole \
    --template-url https://aws-flux-role-644128927965-us-east-1.s3.amazonaws.com/aws_flux_role_beta.yml
    --parameters ParameterKey=capabilities,ParameterValue=CAPABILITY_NAMED_IAM

aws flux --endpoint-url https://1ylqtfn3q5.execute-api.us-west-2.amazonaws.com/privatebeta list-environments

cd pring-petclinic/

./mvnw package

java -jar target/*.jar