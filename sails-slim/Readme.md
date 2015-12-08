
bash> docker build -t my/sails-slim .

bash> docker run -it --name demo -p 8080:1337 --rm my/sails-slim /bin/bash

container# sails new demo

container# sails generate api user

containerr# sails lift
