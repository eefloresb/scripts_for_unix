#!/bin/bash
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# Author: Edwin Enrique Flores Bautista
# Email: eflores@canvia.com

# Procedimiento manual que permite realizar un update a nivel del archivo de configuración

RUTA="/etc/td-agent-bit/override_time.lua:/etc/td-agent-bit/parsers.conf:/etc/td-agent-bit/td-agent-bit.conf"
file1='function append_tag(tag, timestamp, record)
    new_record = record
    new_record["log_time"] = os.date("%Y-%m-%d %H:%M:%S")
    response = new_record["response"]
    if response ~= nil then
        if response["data"] ~= nil then
            for key,value in pairs(response["data"]) do
                if string.find(key, "%.") then
                    new_key_response = string.gsub(key, "%.", "_")
                    response["data"][new_key_response] = value
                    response["data"][key] = nil
                end
                if type(value)=="table" and next(value) == nil then
                    response["data"][key] = nil
                end
                if (key == "RESULT" or key == "vbvResult") and type(value)=="table" then
                    new_key_response = key .. "_json"
                    response["data"][new_key_response] = value
                    response["data"][key] = nil
                end
            end
        end
    end

    request = new_record["request"]
    if request ~= nil then
        if request["data"] ~= nil then
            for key,value in pairs(request["data"]) do
                if string.find(key, "%.") then
                    new_key_request = string.gsub(key, "%.", "_")
                    request["data"][new_key_request] = value
                    request["data"][key] = nil
                end
            end
        end
    end
    return 1, timestamp, new_record
end'

file2='[PARSER]
    Name logutil-ecore-parser
    Format regex
    Regex ^(?<datetime>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\d{3} (?<level>(INFO|DEBUG|ERROR){1})  \[(?<component>.*)\] (\((?<action_details>.*)\)) (?<action>(TASK|APP){1}) (?<message>.*)$
    Decode_Field json message

[PARSER]
    Name niubizlogger-apps-parser
    Format regex
    Regex ^(?<datetime>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}),\d{3} (?<level>(INFO|DEBUG|ERROR){1})  \[(?<component>.*)\] (\((?<actiondetails>.*)\)) (?<message>.*)$
    Decode_Field json message'

file3='[SERVICE]
    flush        5
    daemon       Off
    log_level    debug
    parsers_file parsers.conf
    plugins_file plugins.conf
    http_server  Off
    http_listen  0.0.0.0
    http_port    2020
    storage.metrics on

[INPUT]
    name  tail
    path  /opt/wildfly/standalone/log/application.log
    multiline  On
    parser_firstline  logutil-ecore-parser
    skip_empty_lines On
    buffer_chunk_size 400K
    buffer_max_size 75MB
    tag ecore.trace

[INPUT]
    name  tail
    path  /opt/wildfly/standalone/log/applicationapps.log
    multiline  On
    parser_firstline  niubizlogger-apps-parser
    skip_empty_lines On
    buffer_chunk_size 400K
    buffer_max_size 75MB
    tag apps.trace

[FILTER]
    name lua
    match *
    script override_time.lua
    call append_tag

[FILTER]
    name record_modifier
    match *
    record hostname ${HOSTNAME}
    #remove_key message

[FILTER]
    name aws
    match *
    imds_version v1
    az true
    ec2_instance_id true
    ec2_instance_type true
    private_ip true
    ami_id true
    account_id true
    hostname true
    vpc_id true

[OUTPUT]
    name  stdout
    match *

[OUTPUT]
    name kinesis_firehose
    match *
    region us-east-1
    delivery_stream kdf-s3-log-centralizado
    sts_endpoint https://sts.us-east-1.amazonaws.com

[OUTPUT]
    name kinesis_firehose
    match ecore.trace
    region us-east-1
    delivery_stream kdf-os-log-centralizado
    sts_endpoint https://sts.us-east-1.amazonaws.com

[OUTPUT]
    name kinesis_firehose
    match apps.trace
    region us-east-1
    delivery_stream kdf-os-log-centralizado-ec2-apps
    sts_endpoint https://sts.us-east-1.amazonaws.com'

BODY=("$file1" "$file2" "$file3")
declare -i sum=0
__xRUTA()
{
IFS=":"
for j in $RUTA; do
  RUTA=$j
  if [[ -f $RUTA ]]; then 
    cd ${RUTA%/*}
    cp ${RUTA} ${RUTA}_BKP
    if [[ $sum == "1" ]]; then
      echo ${BODY[$sum]} >> ${RUTA}
    else
      echo ${BODY[$sum]} > ${RUTA}
    fi
  fi
  sum=$sum+1
done
}

__service(){
  if service td-agent-bit start; then
    echo "Execute td-agent-bit started" 
  else
    service td-agent-bit stop
    service td-agent-bit start 
  fi
}

__execute(){  
sudo /opt/wildfly/bin/jboss-cli.sh -c <<EOF
/subsystem=logging/periodic-size-rotating-file-handler=FILE-APPS-LOG:add(suffix='.yyyy-MM-dd', rotate-size=78M, rotate-on-boot=true, max-backup-index=10, file={relative-to="jboss.server.log.dir", path="applicationapps.log"}, named-formatter=PATTERN)
/subsystem=logging/logger= com.quiputech.niubiz.utils.NiubizLogger:add(level=INFO,use-parent-handlers=false,handlers=[FILE-APPS-LOG])
EOF
}


_main(){
__xRUTA 
__service
__execute
}

_main
