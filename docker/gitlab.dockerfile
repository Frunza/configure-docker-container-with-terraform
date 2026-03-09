FROM hashicorp/terraform:1.5.0

COPY ./terraform/aws /app
COPY ./scripts/gitlabRun.sh /app
WORKDIR /app

CMD ["sh"]
