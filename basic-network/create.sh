#!/bin/bash
set -ev

echo "Creating Channel"
peer channel create -o orderer.PO.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx

setGlobals () {
	PEER=$1
	if [ $PEER -eq 1 ];then
		export CORE_PEER_ADDRESS=supplier1.retailer-org.PO.com:7051

        elif [ $PEER -eq 2 ];then
                export CORE_PEER_ADDRESS=supplier2.retailer-org.PO.com:7051

        elif [ $PEER -eq 3 ];then
                export CORE_PEER_ADDRESS=supplier3.retailer-org.PO.com:7051
        fi
}


joinChannel () {

            for peer in 1 2 3; do
                joinChannelWithRetry $peer
                echo "===================== supplier${peer}.retailer-org${org} joined channel '$CHANNEL_NAME' ===================== "
                sleep 5
                echo
            done
}

joinChannelWithRetry () {
        PEER=$1
        setGlobals $PEER

        set -x
        peer channel join -b mychannel.block  >&log.txt
        res=$?
        set +x
        cat log.txt
        if [ $res -ne 0 -a $COUNTER -lt $MAX_RETRY ]; then
                COUNTER=` expr $COUNTER + 1`
                echo "supplier${PEER}.retailer-org${ORG} failed to join the channel, Retry after $DELAY seconds"
                sleep 5
                joinChannelWithRetry $PEER
        else
                COUNTER=1
        fi
}

echo "joining peers on channel"
joinChannel


