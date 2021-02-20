#!/usr/bin/env bash

trx() {
  echo "$(date +%Y%m%d%H%M%S) $(echo -n $(sha256sum /opt/qemu_kvm_cgi/log/transaction_chain.txt || cut -d' ' -f1)) $(echo -n $sessionTicket)" >> /opt/qemu_kvm_cgi/log/transactions_chain.txt
}

yellRetry() {
  # curl your alerting system here
}

pullSession() {
  export sessionTicket="$(/usr/local/sbin/pop_new_session)"
  export func="$(echo $sessionTicket | base64 -d | cut -d' ' -f3)"
}

exportSession() {
  export machineSession="$( echo $($func) ) | head -n1 | grep started | cut -d' ' -f2)"
}
  
cloneUbuStable() {
  virt-clone --original ubuntu20 --auto-clone | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}

cloneDebStable() {
  virt-clone --original deb10 --auto-clone | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}

cloneFreeBSDStable() {
  virt-clone --original freebsd12 --auto-clone | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}

cloneSuseStable() {
  virt-clone --original leap15 --auto-clone | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry 
}

cloneKaliRolling() {
  virt-clonen --original kalirollng --auto-clone | grep successfully | cut -d' ' -f2 | xargs virsh start || yellRetry
}
