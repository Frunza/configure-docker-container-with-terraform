FROM hashicorp/terraform:1.5.0

ADD ./terraform/aws /app
ADD ./scripts/gitlabRun.sh /app
WORKDIR /app

CMD ["sh"]
