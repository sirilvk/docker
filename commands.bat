# to build the docker
docker build -t lnx .

# to run the docker ...
docker run -d -p 2222:22 lnx
