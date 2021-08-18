#!/bin/bash

echo "wait db server"
dockerize -wait tcp://db:3306 -timeout 20s

# migrate + create super user
python manage.py migrate
python manage.py createsuperuser --noinput

# create table
python manage.py make_discussion_board

echo "run django server"
python manage.py runserver 0.0.0.0:8000