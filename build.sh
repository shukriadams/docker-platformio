set -e

DOCKERPUSH=0
while [ -n "$1" ]; do 
    case "$1" in
    --dockerpush) 
        DOCKERPUSH=1 ;; 
    esac 
    shift
done

docker build -t shukriadams/platformio .
echo "container built"

# query pio in container to ensure it works and returns expected version
LOOKUP=$(docker run shukriadams/platformio:latest bash -c "pio --version") 
if [ "$LOOKUP" != "PlatformIO Core, version 5.1.1" ] ; then
    echo "ERROR : container returned unexpected string ${LOOKUP}"
    exit 1
else
    echo "container smoketest passed"
fi

if [ $DOCKERPUSH -eq 1 ]; then
    echo "starting docker push"
    TAG=$(git describe --tags --abbrev=0) 
    echo "Tag ${TAG} detected"

    docker tag shukriadams/platformio:latest shukriadams/platformio:"${TAG}"
    docker login -u $DOCKER_USER -p $DOCKER_PASS 
    docker push shukriadams/platformio:$TAG
fi

echo "build complete"