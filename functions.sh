#!/usr/bin/env bash

trx() {
  echo "$(date +%Y%m%d%H%M%S) $(echo -n $(sha256sum /opt/qemu_kvm_cgi/log/transaction_chain.txt || cut -d' ' -f1)) $(echo -n $sessionTicket)" >> /opt/qemu_kvm_cgi/log/transactions_chain.txt
}

yellRetry() {
  # curl your alerting system here || logme
}

pullSession() {
  export sessionTicket="$(/usr/local/sbin/pop_new_session)"
  export func="$(echo $sessionTicket | base64 -d | cut -d' ' -f3)"
}

exportSession() {
  export machineSession="$( echo $($func) ) | head -n1 | grep started | cut -d' ' -f2)"
}

storeSession() {
  echo -n "$sessionTicket $machineSession" |  redis-cli -set -x $sessionTicket
}  

cloneUbuStable() {
  virt-clone --original ubuntu20 --auto-clone --name $sessionTicket | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}

cloneDebStable() {
  virt-clone --original deb10 --auto-clone --name $sessionTicket | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}

cloneFreeBSDStable() {
  virt-clone --original freebsd12 --auto-clone --name $sessionTicket | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}

cloneSuseStable() {
  virt-clone --original leap15 --auto-clone --name $sessionTicket | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry 
}

cloneKaliRolling() {
  virt-clone --original kalirollng --auto-clone --name $sessionTicket | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}

destroySession() {
  virsh destroy $sessionRef || yellRetry
  rm -rf /mnt/kvm/"$sessionTicket".qcow2
}

retryFail() {
  sleep 1 && makeSession || yellRetry
}

logme() {
  logger "$(date +%Y%m%d%H%M%S) bad exit code for $sessionTicket $machineSession ERROR $?"
}

makeSession() {
  pullSession || logme
  exportSession || retryFail
  storeSession || logme
  echo $machineSession
}
