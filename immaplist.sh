#!/usr/bin/env bash

# image machine map list

for image in `imgadm -p list`
do
    attributes=( ${image//:/ } )
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
