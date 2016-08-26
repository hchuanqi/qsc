#!/bin/bash
# install.sh
# install script

## set install configurations
## by [install.cfg]
source install.cfg

function usage() {
    echo -e "qsc/install.sh: install qsc scripts collection..."
    echo -e "--"
    echo -e "usage: \tinstall.sh [-i|-u|-h]"
    echo -e "--"
    echo -e "\t-i\tinstall"
    echo -e "\t-u\tuninstall"
    echo -e "\t-h\thelp"
    echo -e "--"
    echo -e "\tset install configurations in **install.cfg** ..."
    echo -e "--"
    return 0
}

function do_install() {
    echo "installing ..."

## init the LOG
    mkdir_p $INST_LOG
    : > $INST_LOG
    install_dir_x   bin
    install_dir_x   sbin
    install_dir     etc
}

function do_uninstall() {
    echo "uninstalling ..."
    [[ -f $UNINST_LIST ]] && {
        uninstall_list $UNINST_LIST
        return 0
    }

    [[ -z $UNINST_LIST ]] && {
        uninstall_by_src
        return 0
    }

    return 0
}

function do_help() {
    usage
    return 0
}

function trial() {
    echo "hello~"
    echo $INST_CMD
}

## file_list <dir>
## list the regular file of of <dir>
function file_list() {
    [[ -z $1 ]] && return 1
    find $1 -type f \( -not -name ".*" \)
    return 0
}

## dest_name <src_file>
## destination name of <src_file> to be installed
function dest_name() {
    [[ -z $1 ]] && return 1
    echo "${INST_PREFIX}/${1}"
    return 0
}

## dest_name_x <src_file>
## destination name of <src_file> to be installed with **EXEC_PREFIX**
function dest_name_x() {
    [[ -z $1 ]] && return 1
    SRC_DIR=$(dirname $1)
    SRC_NAME=$(basename $1)
    echo "${INST_PREFIX}/${SRC_DIR}/${EXEC_PREFIX}${SRC_NAME}"
    return 0
}

## mkdir_p <file_with_path>
## make parent dir of <file_with_path> if not existing
function mkdir_p() {
    [[ -z $1 ]] && return 1
    DIR_P=$(dirname $1)
    [[ -d $DIR_P ]] || {
        mkdir -p $DIR_P
        echo "mkdir -p $DIR_P"
    }
    return 0
}

## install_file <src> <dest>
## install <src> to <dest>
## <src> is file name with path relative to this install script
function install_file() {
    [[ -z $2 ]] && return 1
    mkdir_p $2
    ( cp -ip $1 $2 ) && {
        echo "cp -ip $1 $2"
        echo $2 >>$INST_LOG
    }
    return 0
}

function uninstall_file() {
    [[ -z $1 ]] && return 1
    [[ -f $1 ]] && {
        rm $1
        echo "rm $1"
    }
}

function install_dir() {
    [[ -z $1 ]] && return 1
    FILE_LIST=$(file_list $1)
    for SRC in $FILE_LIST; do
        DEST=$(dest_name $SRC)
        install_file "$SRC" "$DEST"
    done

    return 0
}

function install_dir_x() {
    [[ -z $1 ]] && return 1
    FILE_LIST=$(file_list $1)
    for SRC in $FILE_LIST; do
        DEST=$(dest_name_x $SRC)
        install_file "$SRC" "$DEST"
        chmod 755 "$DEST"
    done

    return 0
}

function uninstall_dir() {
    [[ -z $1 ]] && return 1
    FILE_LIST=$(file_list $1)
    for SRC in $FILE_LIST; do
        DEST=$(dest_name $SRC)
        uninstall_file "$DEST"
    done

    return 0
}

function uninstall_dir_x() {
    [[ -z $1 ]] && return 1
    FILE_LIST=$(file_list $1)
    for SRC in $FILE_LIST; do
        DEST=$(dest_name_x $SRC)
        uninstall_file "$DEST"
    done

    return 0
}

function uninstall_by_src() {
    uninstall_dir_x bin
    uninstall_dir_x sbin
    uninstall_dir etc
    return 0
}

## uninstall_list <installed_list>
## uninstall files listed in <installed_list>
function uninstall_list() {
    [[ -n $1 ]] || [[ -f $1 ]] || return 1
    FILE_LIST=$(<$1)
    for SRC in $FILE_LIST; do
        uninstall_file $SRC
    done

    return 0
}


## get options
getopts ":iuh" INST_OPT
case $INST_OPT in
    i) INST_CMD=do_install ;;
    u) INST_CMD=do_uninstall ;;
    *) INST_CMD=do_help ;;
esac
## default action
[[ -z $INST_CMD ]] && INST_CMD=do_help
## non-proper configuration
[[ -z $INST_PREFIX ]] && INST_CMD=do_help


## do the job
$INST_CMD
