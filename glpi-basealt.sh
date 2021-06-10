#!/bin/bash -e

help()
{
    echo "Usage: $0 {saratov,obninsk,moscow} {testnotebook,worknotebook,workPC,testPC} {serial}"
    exit $?
}

test "$#" -ge 3 || help 1

city="$1"
device="$2"
serial="$3"

apt-get update
apt-get install hw-probe fusioninventory-agent -y
fusioninventory-agent --tasks=Inventory --server="https://glpi.ipa.basealt.ru/plugins/fusioninventory/t=$city,$device,$serial"

dmimsg="bios-vendor
  bios-version
  bios-release-date
  system-manufacturer
  system-product-name
  system-version
  system-serial-number
  system-uuid
  system-family
  baseboard-manufacturer
  baseboard-product-name
  baseboard-version
  baseboard-serial-number
  baseboard-asset-tag
  chassis-manufacturer
  chassis-type
  chassis-version
  chassis-serial-number
  chassis-asset-tag
  processor-family
  processor-manufacturer
  processor-version
  processor-frequency"

echo serial: $serial
for i in $dmimsg; do
    echo -n "$i: "
    dmidecode -s $i | head -n1
done

