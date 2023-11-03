#!/bin/bash
output_dir="$1"

output_file_name="env-config.js"

if [ -z  "${output_dir}" ]; then
  output_dir="./public"
fi

if [ -f "${output_dir}/${output_file_name}" ]; then
  rm -f "${output_dir}/${output_file_name}"
fi

echo "window.env = {" >> "${output_dir}/${output_file_name}"

while read -r line || [[ -n "$line" ]];
do
  if printf '%s\n' "$line" | grep -q -e '='; then
    varname=$(printf '%s\n' "$line" | sed -e 's/=.*//')
    varvalue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
  fi
  value=$(printf '%s\n' "${!varname}")
  [[ -z $value ]] && value=${varvalue}
  echo "  $varname: \"$value\"," >> "${output_dir}/${output_file_name}"
done < .env

echo "}" >> "${output_dir}/${output_file_name}"