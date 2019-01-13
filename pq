#!/bin/bash
set -euo pipefail

file=${1:?must provide input tsv}

finish() {
  rm -f "$file".tmp.tsv
}

trap finish EXIT

cat "$file" |
  grep -v '^#DEBUG' |
  sed -e 's/\t\([0-9]*\)-\([0-9]*\)-\([0-9]*\) \([0-9]*\):\([0-9]*\)\t/\t\1\t\2\t\3\t\4\t\5\t/' \
    -e 's/station\tvalid/station\tyear\tmonth\tday\thour\tminute/' > "$file".tmp.tsv

extra_flags="--exclude 27"

if [ "${INCLUDE_RAW_METAR:-0}" == "1" ]; then
  extra_flags=""
fi
csv2parquet "$file".tmp.tsv \
  --output "${file%%.tsv}.parquet" \
  --row-group-size 200000 \
  $extra_flags \
  --codec zstd \
  --type year=int16 month=int8 day=int8 hour=int8 minute=int8 lon=float64 lat=float64 tmpf=float32? dwpf=float32? relh=float32? drct=float32? sknt=float32? p01i=float32? alti=float32? mslp=float32? vsby=float32? gust=float32? skyl1=float32? skyl2=float32? skyl3=float32? skyl4=float32? 

