# Pull a base ubuntu image
FROM ubuntu


# Add local code
WORKDIR /ansible
COPY . .

# All apt update and apt installs in one command
RUN apt update && apt install -y \
    curl \
    netcat \
    vim \
    git \
    openssh-server 
# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az extension add --name front-door
# Install helm and kubectl
RUN curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
# Install Python 3.7
# Install Python 3.7
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN  apt install -y python3.7
RUN apt-get install -y python3-pip
# Install Azure Ansible
RUN python3 -m pip install "ansible[azure]" packaging msrest msrestazure
#Run all installs from requirements.txt
RUN python3.7 -m pip install -r requirements.txt
