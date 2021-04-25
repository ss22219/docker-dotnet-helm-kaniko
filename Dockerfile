FROM mcr.microsoft.com/dotnet/sdk:5.0

ARG KUBECTL_VERSION=1.21.0
ARG HELM_VERSION=3.5.4
ARG POWERSHELL_VERSION=7.1.3

# Install kubectl, aws-iam-authenticator, helm
RUN curl -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    curl -o /usr/local/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    curl -o helm.tar.gz https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
    tar -xvf helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64 && \
    rm helm.tar.gz

# Install Powershell Core
ARG POWERSHELL_DOWNLOAD_URL=https://github.com/PowerShell/PowerShell/releases/download/v$POWERSHELL_VERSION/powershell-$POWERSHELL_VERSION-linux-x64.tar.gz
RUN set -ex \
    && curl -SL $POWERSHELL_DOWNLOAD_URL --output powershell.tar.gz \
    && mkdir -p /opt/microsoft/powershell/$POWERSHELL_VERSION \
    && tar zxf powershell.tar.gz -C /opt/microsoft/powershell/$POWERSHELL_VERSION \
    && rm powershell.tar.gz \
    && ln -s /opt/microsoft/powershell/$POWERSHELL_VERSION/pwsh /usr/bin/pwsh

 # Install kaniko   
COPY --from=gcr.io/kaniko-project/executor:v1.5.2 /kaniko /kaniko
ENV PATH $PATH:/kaniko

ENTRYPOINT ["/bin/cat"]
