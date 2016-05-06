#!/bin/bash
################################################################################
#                      Copyright (C) OpenText Corporation
#
# Script Name:  [nsust.sh]
# Date Created: [03/05/2016]
# Date Updated: []
# Version:      1.00
# Platform:     Linux
#
# Log Name/Location:
#     $OT_DIR/archive/ECSC/ftplogs/[PLACEHOLDER].log
#
# Purpose: [PLACEHOLDER]
#
# Usage: [Script to create PT or PV tables]
#
# Options:
#     -h           Help (display usage)
#     -s           supplier_code
#     -v           van_id
#     -t           tgo_id
#     -n           company_name
#     -e           file_type
#     -w           file_type
#     -x           to create pv tables
#     -y           to create pt tables
#
################################################################################

################################################################################
#                                  Functions                                   #
################################################################################

function menu () {
        while getopts ":s:,:v:,:t:,:n:,:e,:w,:h,:x,:y" opt; do
                case $opt in
                        s)
                                supplier_code="$OPTARG"

                        ;;
                        v)
                                van_id="$OPTARG"

                        ;;
                        t)
                                tgo_id="$OPTARG"

                        ;;
                        n)
                                company_name="$OPTARG"
                        ;;
                        e)
                                file_type=E
                        ;;
                        w)
                                file_type=P
                        ;;
                        x)
                                pv=1
                        ;;
                        y)
                                pt=1
                        ;;
                        h)
                                usage
                                exit
                        ;;
                        \?)
                                usage
                                echo "Invalid option: -$OPTARG" >&2
                                exit $E_PARAMS
                        ;;
                esac
        done
}

function init () {
         pt=0
         pv=0
         E_PARAMS=101
}
function clean () {
        rm ${supplier_code}_PV.exp ${supplier_code}_PT.exp
}

function error () {
    if [ "$pv" -eq "0" ] && [ "$pt" -eq "0" ]
    then
        echo "Error: You have to use at least one of those flags -x , -y "
        usage
        exit 1
    fi
}

function usage () {
        usage="$(basename "$0") [-h] -- program to make tables pv or pt,
        where:
                -h show this help text
                -s supplier_code
                -v van_id
                -t tgo_id
                -n company_name
                -e file_type
                -w file_type
                -x to create pv tables
                -y to create pt tables"
                echo "$usage"
}

function TP_create () {
	  sed "s/SSSS/$supplier_code/g;s/PPPPPPPP/$company_name/g;s/EEEEEEEEEEEEEE/$van_id/g" NMCJP_BR_TPSkeleton_PP.exp > NMCJP_BR_${supplier_code}_PP.exp
		copy NMCJP_BR_${supplier_code}_PP.exp
}
function Touch () {
        touch ${supplier_code}_PV.exp ${supplier_code}_PT.exp
}
function PV_create () {
    if [ "$pv" -eq "1" ]
    then
      sed "s/\[SSSS\]/$supplier_code/g;s/\[TTTTTTTT\]/$tgo_id/g;s/\[EEEEEEEE\]/$van_id/g;s/\[FFFFFFFF\]/$file_type/g;s/\[ZZZZZZ\]/CATSMBGXS/g" ntables.exp > ${supplier_code}_PV.exp
    fi
}

function PT_create () {
    if [ "$pt" -eq "1" ]
    then
        sed "s/\[SSSS\]/$supplier_code/g;s/\[TTTTTTTT\]/$tgo_id/g;s/\[EEEEEEEE\]/$van_id/g;s/\[FFFFFFFF\]/$file_type/g;s/\[ZZZZZZ\]/CATSM3GXS/g" ntables.exp > ${supplier_code}_PT.exp
    fi
}

function supplier_tables_create () {
        cat ${supplier_code}_PV.exp ${supplier_code}_PT.exp > ${supplier_code}.exp
}

function supplier_tables_create () {
        cat ${supplier_code}_PV.exp ${supplier_code}_PT.exp > ${supplier_code}.exp
		copy ${supplier_code}.exp
}

function copy () {
    cp -v -i $1 $OT_DIR
}

function SC_TGcheck1 () {
      _original_path="$PWD"
	cd $OT_DIR
	prompt=$(echo $(whoami)[$(pwd)])
	echo -e "\n## Preprod before load ##\n\nNMCJP_BR_${supplier_code}_PP.exp:\n$prompt\nSC_TGcheck NMCJP_BR_${supplier_code}_PP.exp"
	echo "$(SC_TGcheck $OT_DIR/NMCJP_BR_${supplier_code}_PP.exp)" | GREP_COLOR='01;30;42' grep -E -C 10 --color="always" "Total.*|Good.* | head
	-n14"
	echo -e "\n-------------------------------------------------------\n"
	echo -e "$supplier_code.exp:\n$prompt\nSC_TGcheck $supplier_code.exp"
	echo "$(SC_TGcheck $OT_DIR/$supplier_code.exp)" | GREP_COLOR='01;30;42' grep -E -C 10 --color="always" "Total.*|Good.* | head -n14"
	echo -e "\n## Evidence end.\n"
      cd "$_original_path"
}

################################################################################
#                                Main Procedure                                #
################################################################################

init
menu "$@"
error
TP_create
PV_create
PT_create
supplier_tables_create
SC_TGcheck1
clean
