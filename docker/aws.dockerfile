FROM hashicorp/terraform:1.5.0

ADD ./terraform/aws /app
ADD ./scripts/awsRun.sh /app
WORKDIR /app

CMD ["sh"]
