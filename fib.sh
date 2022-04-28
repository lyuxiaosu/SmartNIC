#!/bin/bash
function usage {
        echo "$0 [fib num] [duration(s) concurrent]"
        exit 1
}

if [ $# != 3 ] ; then
        usage
        exit 1;
fi

fib_num=$1
duration=$2
concurrent=$3

#server_log="fib_"$fib_num".log"
log="fib_"$fib_num".txt"
key_path="/users/xiaosuGW"
server_path="/users/xiaosuGW/sledge-serverless-framework/runtime/tests"
chmod 400 $key_path/id_rsa

ssh -o stricthostkeychecking=no -i $key_path/id_rsa xiaosuGW@10.10.1.1 "$server_path/start.sh >/dev/null 2>&1 &"

hey -c $concurrent -z $duration\s -disable-keepalive -m GET -d $fib_num "http://10.10.1.1:10000" > $log 2>&1 &
pid1=$!
wait -f $pid1

printf "[OK]\n"

ssh -o stricthostkeychecking=no -i $key_path/id_rsa xiaosuGW@10.10.1.1 "$server_path/kill_sledge.sh"

