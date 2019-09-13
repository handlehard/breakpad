#!/bin/bash

if [ $# -ne 1 ]; then
	echo $#
	echo cp prj_libs to \<PRJ_DIR/libs\>
	echo cp dump files to \<PRJ_DIR/dmp\>
	echo Usage: $0 \<PRJ_DIR\>
	echo check the stack in \<PRJ_DIR/stack\>
	exit 1
fi

BREAK_PAD_DIR=`dirname $0`
PRJ_DIR=$1

DUMP_SYMS=$BREAK_PAD_DIR/dump_syms
MINIDUMP_STACKWALK=$BREAK_PAD_DIR/minidump_stackwalk

PRJ_LIBS_DIR=$PRJ_DIR/libs
SYM_DIR=$PRJ_DIR/symbols
STACK_DIR=$PRJ_DIR/stack
DUMP_DIR=$PRJ_DIR/dmp

prj_libs=(`ls $PRJ_LIBS_DIR`)

mkdir -p $SYM_DIR

for value in ${prj_libs[*]}
do

	$DUMP_SYMS $PRJ_LIBS_DIR/$value > $SYM_DIR/$value.sym

	HASH=`head -n1 $SYM_DIR/$value.sym | cut -d' ' -f4`
	# head -n1 $SYM_DIR/$value.sym | cut -d' ' -f5
	mkdir -p $SYM_DIR/$value/$HASH
	mv $SYM_DIR/$value.sym $SYM_DIR/$value/$HASH/

done

dmps=(`ls $DUMP_DIR`)

mkdir -p $STACK_DIR

for value in ${dmps[*]}
do

	$MINIDUMP_STACKWALK $DUMP_DIR/$value ./$SYM_DIR > $STACK_DIR/$value.txt

done
