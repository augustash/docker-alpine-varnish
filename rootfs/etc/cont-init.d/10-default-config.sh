#!/usr/bin/with-contenv bash

# if a Secret isn't mounted via volume, generate a default
if [[ -f "$VARNISH_SECRET_FILE" ]]; then
    echo "============> Using existing secret file"
else
    export VARNISH_SECRET=$(pwgen -s 128 1)
    echo "============> Generating Varnish secret: ${VARNISH_SECRET}"
    echo "${VARNISH_SECRET}" > "${VARNISH_SECRET_FILE}"
fi

# if a VCL isn't mounted via volume, use the default
if [[ -f "${VARNISH_VCL_CONF}" ]]; then
    echo "============> Using existing VCL file"
else
    echo "============> Generating default VCL"
    /usr/local/bin/confd -onetime -backend env &>/dev/null
fi
