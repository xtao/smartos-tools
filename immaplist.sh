#!/usr/bin/env bash

# image machine map list

for image in `imgadm -p list`
do
    attributes=( ${image//:/ } )
    if [[ ${attributes[1]} == "smartos" ]] ; then
        image_uuid=${attributes[0]}
        ## `vmadm lookup image_uuid` doesn't work
        i=0
        machine_uuids=()
        for uuid in `vmadm lookup type=OS`
        do
            u=$(vmadm get ${uuid} | json image_uuid)
            if [[ "${u}" == "${image_uuid}" ]] ; then
                machine_uuids[$i]=$uuid
                ((i++))
            fi
        done
        echo $image_uuid "smartos" ${#machine_uuids[*]}
        for uuid in "${machine_uuids[@]}"
        do
            echo "\t"$uuid
        done
    fi
    if [[ ${attributes[1]} == "linux" ]] ; then
        image_uuid=${attributes[0]}
        machines=$(vmadm lookup disks.0.image_uuid=${image_uuid})
        if [[ -n "${machines}" ]] ; then
            machine_uuids=( ${machines// /} )
            echo $image_uuid ${#machine_uuids[*]}
            for uuid in "${machine_uuids[@]}"
            do
                echo "\t"$uuid
            done
        else
            echo $image_uuid
        fi
    fi
done
