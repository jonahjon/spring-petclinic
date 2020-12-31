export ACCOUNT_ID=164382793440

# clonse repo with petclinic 
# git clone https://github.com/spring-projects/spring-petclinic.git


aws configure add-model --service-model file://flux-2017-07-25.normal.json --service-name flux

aws flux help

export AWS_DEFAULT_REGION=us-west-2

aws cloudformation create-stack --stack-name AWSFluxRole \
    --template-url https://aws-flux-role-644128927965-us-east-1.s3.amazonaws.com/aws_flux_role_beta.yml \
    --parameters ParameterKey=capabilities,ParameterValue=CAPABILITY_NAMED_IAM

aws flux --endpoint-url https://1ylqtfn3q5.execute-api.us-west-2.amazonaws.com/privatebeta list-environments

cd pring-petclinic/

./mvnw package

java -jar target/*.jar

sudo yum update -y

sudo update-alternatives --config python

sudo yum remove -y java-1.7.0-openjdk && sudo yum install -y java-1.8.0-openjdk-devel

git clone --recurse-submodules https://github.com/aws-samples/cdk-microservices-labs.git
