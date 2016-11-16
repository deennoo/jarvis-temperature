#!/bin/bash

temperature() {
    # $1: Pièce à Relevé Temp

local url="$relev_Tem_url" 

    local -r order="$(jv_sanitize "$1")"
echo "$1 est de "

    while read device; do
        local sdevice="$(jv_sanitize "$device" ".*")"

	if [[ "$order" =~ .*$sdevice.* ]]; then
            local address="$(echo $Temp_piece | jq -r ".devices[] | select(.name==\"$device\") | .address")"
echo "$(curl -s "http://JB:Positif13@78.206.93.225:8080/json.htm?type=devices&rid=$address" | jq -r '.result[0].Data' | sed "s/C/degrÃ©s/g" | sed "s/%/% d humiditÃ©/g")"

       return $?
        fi

    done <<< "$(echo $Temp_piece | jq -r '.devices[].name')"
    jv_error "ERREUR: Pas de Temperature demande dans $1"
    return 1
}

