
git submodule update --init --recursive

sudo yum update -y

sudo update-alternatives --config python

sudo yum remove -y java-1.7.0-openjdk && sudo yum install -y java-1.8.0-openjdk-devel

git submodule update --init --recursive

cd work/build && ./mvnw package

cd ../..

python3 -m venv .env

source .env/bin/activate

pip install -r requirements.txt

cdk synth

cdk bootstrap

cdk deploy
