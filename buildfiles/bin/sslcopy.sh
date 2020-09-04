#!/bin/bash

cp -f ca/* /opt/ca/

service nginx restart
