SHELL = cmd.exe

#
# ZDS II Make File - Hexload project, Debug configuration
#
# Generated by: ZDS II - eZ80Acclaim! 5.3.5 (Build 23020901)
#   IDE component: d:5.3.0:23020901
#   Install Path: C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\
#

RM = del

# ZDS base directory
ZDSDIR = C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5
ZDSDIR_ESCSPACE = C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5

# ZDS bin directory
BIN = $(ZDSDIR)\bin

# ZDS include base directory
INCLUDE = C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include
INCLUDE_ESCSPACE = C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include

# ZTP base directory
ZTPDIR = C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\ZTP2.5.1
ZTPDIR_ESCSPACE = C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\ZTP2.5.1

# project directory
PRJDIR = C:\source\agon-hexload\src
PRJDIR_ESCSPACE = C:\source\agon-hexload\src

# intermediate files directory
WORKDIR = C:\source\agon-hexload\src\Debug
WORKDIR_ESCSPACE = C:\source\agon-hexload\src\Debug

# output files directory
OUTDIR = C:\source\agon-hexload\src\Debug\
OUTDIR_ESCSPACE = C:\source\agon-hexload\src\Debug\

# tools
CC = @"$(BIN)\eZ80cc"
AS = @"$(BIN)\eZ80asm"
LD = @"$(BIN)\eZ80link"
AR = @"$(BIN)\eZ80lib"
WEBTOC = @"$(BIN)\mkwebpage"

CFLAGS =  \
-define:_DEBUG -define:_EZ80F92 -define:_EZ80ACCLAIM! -genprintf  \
-keepasm -keeplst -NOlist -NOlistinc -NOmodsect -optsize -promote  \
-NOreduceopt  \
-stdinc:"\"..;C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include\std;C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include\zilog\""  \
-usrinc:"\"..;\"" -NOmultithread -NOpadbranch -debug -cpu:eZ80F92  \
-asmsw:"   \
	-define:_EZ80ACCLAIM!=1  \
	-include:\"..;C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include\std;C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include\zilog\"  \
	-list -NOlistmac -pagelen:0 -pagewidth:80 -quiet -sdiopt -warn  \
	-debug -NOigcase -cpu:eZ80F92"

ASFLAGS =  \
-define:_EZ80ACCLAIM!=1  \
-include:"\"..;C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include\std;C:\ZiLOG\ZDSII_eZ80Acclaim!_5.3.5\include\zilog\""  \
-list -NOlistmac -name -pagelen:0 -pagewidth:80 -quiet -sdiopt  \
-warn -debug -NOigcase -cpu:eZ80F92

LDFLAGS = @..\Hexload.linkcmd
build: Hexload relist

buildall: clean Hexload relist

relink: deltarget Hexload

deltarget: 
	@if exist "$(WORKDIR)\hexload.lod"  \
            $(RM) "$(WORKDIR)\hexload.lod"
	@if exist "$(WORKDIR)\hexload.hex"  \
            $(RM) "$(WORKDIR)\hexload.hex"
	@if exist "$(WORKDIR)\hexload.map"  \
            $(RM) "$(WORKDIR)\hexload.map"

clean: 
	@if exist "$(WORKDIR)\hexload.lod"  \
            $(RM) "$(WORKDIR)\hexload.lod"
	@if exist "$(WORKDIR)\hexload.hex"  \
            $(RM) "$(WORKDIR)\hexload.hex"
	@if exist "$(WORKDIR)\hexload.map"  \
            $(RM) "$(WORKDIR)\hexload.map"
	@if exist "$(WORKDIR)\init.obj"  \
            $(RM) "$(WORKDIR)\init.obj"
	@if exist "$(WORKDIR)\init.lis"  \
            $(RM) "$(WORKDIR)\init.lis"
	@if exist "$(WORKDIR)\init.lst"  \
            $(RM) "$(WORKDIR)\init.lst"
	@if exist "$(WORKDIR)\main.obj"  \
            $(RM) "$(WORKDIR)\main.obj"
	@if exist "$(WORKDIR)\main.lis"  \
            $(RM) "$(WORKDIR)\main.lis"
	@if exist "$(WORKDIR)\main.lst"  \
            $(RM) "$(WORKDIR)\main.lst"
	@if exist "$(WORKDIR)\main.src"  \
            $(RM) "$(WORKDIR)\main.src"
	@if exist "$(WORKDIR)\mos-interface.obj"  \
            $(RM) "$(WORKDIR)\mos-interface.obj"
	@if exist "$(WORKDIR)\mos-interface.lis"  \
            $(RM) "$(WORKDIR)\mos-interface.lis"
	@if exist "$(WORKDIR)\mos-interface.lst"  \
            $(RM) "$(WORKDIR)\mos-interface.lst"
	@if exist "$(WORKDIR)\hxload.obj"  \
            $(RM) "$(WORKDIR)\hxload.obj"
	@if exist "$(WORKDIR)\hxload.lis"  \
            $(RM) "$(WORKDIR)\hxload.lis"
	@if exist "$(WORKDIR)\hxload.lst"  \
            $(RM) "$(WORKDIR)\hxload.lst"
	@if exist "$(WORKDIR)\vdp.obj"  \
            $(RM) "$(WORKDIR)\vdp.obj"
	@if exist "$(WORKDIR)\vdp.lis"  \
            $(RM) "$(WORKDIR)\vdp.lis"
	@if exist "$(WORKDIR)\vdp.lst"  \
            $(RM) "$(WORKDIR)\vdp.lst"
	@if exist "$(WORKDIR)\vdp.src"  \
            $(RM) "$(WORKDIR)\vdp.src"
	@if exist "$(WORKDIR)\serial.obj"  \
            $(RM) "$(WORKDIR)\serial.obj"
	@if exist "$(WORKDIR)\serial.lis"  \
            $(RM) "$(WORKDIR)\serial.lis"
	@if exist "$(WORKDIR)\serial.lst"  \
            $(RM) "$(WORKDIR)\serial.lst"

relist: 
	$(AS) $(ASFLAGS) -relist:"C:\source\agon-hexload\src\Debug\hexload.map" \
            C:\source\agon-hexload\src\init.asm
	$(AS) $(ASFLAGS) -relist:"C:\source\agon-hexload\src\Debug\hexload.map" \
            C:\source\agon-hexload\src\Debug\main.src
	$(AS) $(ASFLAGS) -relist:"C:\source\agon-hexload\src\Debug\hexload.map" \
            C:\source\agon-hexload\src\mos-interface.asm
	$(AS) $(ASFLAGS) -relist:"C:\source\agon-hexload\src\Debug\hexload.map" \
            C:\source\agon-hexload\src\hxload.asm
	$(AS) $(ASFLAGS) -relist:"C:\source\agon-hexload\src\Debug\hexload.map" \
            C:\source\agon-hexload\src\Debug\vdp.src
	$(AS) $(ASFLAGS) -relist:"C:\source\agon-hexload\src\Debug\hexload.map" \
            C:\source\agon-hexload\src\serial.asm

# pre-4.11.0 compatibility
rebuildall: buildall 

LIBS = 

OBJS =  \
            $(WORKDIR_ESCSPACE)\init.obj  \
            $(WORKDIR_ESCSPACE)\main.obj  \
            $(WORKDIR_ESCSPACE)\mos-interface.obj  \
            $(WORKDIR_ESCSPACE)\hxload.obj  \
            $(WORKDIR_ESCSPACE)\vdp.obj  \
            $(WORKDIR_ESCSPACE)\serial.obj

Hexload: $(OBJS)
	 $(LD) $(LDFLAGS)

$(WORKDIR_ESCSPACE)\init.obj :  \
            $(PRJDIR_ESCSPACE)\init.asm
	 $(AS) $(ASFLAGS) "$(PRJDIR)\init.asm"

$(WORKDIR_ESCSPACE)\main.obj :  \
            $(PRJDIR_ESCSPACE)\main.c  \
            $(INCLUDE_ESCSPACE)\std\CTYPE.H  \
            $(INCLUDE_ESCSPACE)\std\Format.h  \
            $(INCLUDE_ESCSPACE)\std\Stdarg.h  \
            $(INCLUDE_ESCSPACE)\std\Stdio.h  \
            $(INCLUDE_ESCSPACE)\std\Stdlib.h  \
            $(INCLUDE_ESCSPACE)\std\String.h  \
            $(INCLUDE_ESCSPACE)\zilog\defines.h  \
            $(PRJDIR_ESCSPACE)\mos-interface.h  \
            $(PRJDIR_ESCSPACE)\stdint.h  \
            $(PRJDIR_ESCSPACE)\uart.h  \
            $(PRJDIR_ESCSPACE)\vdp.h
	 $(CC) $(CFLAGS) "$(PRJDIR)\main.c"

$(WORKDIR_ESCSPACE)\mos-interface.obj :  \
            $(PRJDIR_ESCSPACE)\mos-interface.asm  \
            $(PRJDIR_ESCSPACE)\mos_api.inc
	 $(AS) $(ASFLAGS) "$(PRJDIR)\mos-interface.asm"

$(WORKDIR_ESCSPACE)\hxload.obj :  \
            $(PRJDIR_ESCSPACE)\hxload.asm  \
            $(PRJDIR_ESCSPACE)\mos_api.inc
	 $(AS) $(ASFLAGS) "$(PRJDIR)\hxload.asm"

$(WORKDIR_ESCSPACE)\vdp.obj :  \
            $(PRJDIR_ESCSPACE)\vdp.c  \
            $(INCLUDE_ESCSPACE)\zilog\defines.h  \
            $(PRJDIR_ESCSPACE)\mos-interface.h  \
            $(PRJDIR_ESCSPACE)\stdint.h  \
            $(PRJDIR_ESCSPACE)\vdp.h
	 $(CC) $(CFLAGS) "$(PRJDIR)\vdp.c"

$(WORKDIR_ESCSPACE)\serial.obj :  \
            $(PRJDIR_ESCSPACE)\serial.asm
	 $(AS) $(ASFLAGS) "$(PRJDIR)\serial.asm"

