FROM python:alpine3.18 as base

WORKDIR /app

# install dependencies
COPY requirements.txt /app
RUN pip install -r requirements.txt

FROM python:alpine3.18 as release

COPY --from=base /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/

WORKDIR /app

# copy project
COPY . /app

# container port
EXPOSE 8000

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN addgroup --system todogroup \
  && adduser --system --ingroup todogroup todouser \
  && chown -R todouser:todogroup /app

USER todouser

