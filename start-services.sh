#!/bin/bash
echo "Starting development services..."
sudo service postgresql start
sudo service mysql start
sudo service redis-server start
sudo systemctl start mongod
echo "All services started!"
