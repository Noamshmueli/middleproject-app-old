FROM alpine:3.9
RUN apk update
RUN apk add python3
RUN apk add py-pip
RUN apk add --upgrade py-pip
RUN pip3 install Click==7.0 Flask==1.0.2 itsdangerous==1.1.0 Jinja2==2.10 MarkupSafe==1.1.1 Werkzeug==0.14.1
ADD app.py /
CMD [ "python3", "./app.py" ]
