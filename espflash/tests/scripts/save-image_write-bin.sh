#!/usr/bin/env bash
app="espflash/tests/data/$1"

# if $1 is esp32c2, create an variable that contains `-x 26mhz`
if [[ $1 == "esp32c2" ]]; then
    freq="-x 26mhz"
fi

result=$(espflash save-image --merge --chip $1 $freq $app app.bin 2>&1)
echo "$result"
if [[ ! $result =~ "Image successfully saved!" ]]; then
    exit 1
fi
echo "Writing binary"
result=$(timeout 25 espflash write-bin --monitor 0x0 app.bin --non-interactive 2>&1)
echo "$result"
if [[ ! $result =~ "Binary successfully written to flash!" ]]; then
    exit 1
fi

if ! echo "$result" | grep -q "Hello world!"; then
    exit 1
fi