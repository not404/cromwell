#
# $Id: Makefile,v 1.2 2002/09/19 07:13:37 warmcat Exp $
#
# Shamelessly lifted and hacked from the
# free bios project.
#
# $Log: Makefile,v $
# Revision 1.2  2002/09/19 07:13:37  warmcat
#
# Lots of video init added, now getting sysnc to encoder, but no output
# Franz's cleanups to his Fri13th code merged
# Crash on BootCpuCache(true) fixed
# Added code to detect tray state on DVD
#
#
# 2002-09-14 andy@warmcat.com  changed to -Wall and -Werror, superclean
# 2002-09-11 andy@warmcat.com  branched for cromwell, removed all the linux boot stuff
#
# Revision 1.4  2002/08/19 13:53:33  meriac
# the need of nasm during linking removed
#
# Revision 1.2  2002/08/15 20:01:38  mist
# kernel and initrd needn't be patched into image.bin manually any more,
# due to Milosch
#
#

### compilers and options
CC	= gcc
CFLAGS	= -g -O2 -Wall -Werror
LD	= ld
LDFLAGS	= -s -S -T ldscript.ld
OBJCOPY	= objcopy

### objects
OBJECTS	= BootStartup.o BootResetAction.o filtror.o BootPerformPicChallengeResponseAction.o vsprintf.o \
BootPciPeripheralInitialization.o BootPerformXCodeActions.o BootVgaInitialization.o BootIde.o \
BootHddKey.o rc4.o sha1.o BootVideoHelpers.o

# target:
all	: image.bin

clean	:
	rm -rf *.o *~ core *.core ${OBJECTS} image.elf image.bin

image.elf : ${OBJECTS}
	${LD} -o $@ ${OBJECTS} ${RESOURCES} ${LDFLAGS}




### rules:
%.o	: %.c boot.h consts.h
	${CC} ${CFLAGS} -o $@ -c $<

%.o	: %.S consts.h
	${CC} -DASSEMBLER ${CFLAGS} -o $@ -c $<

%.bin : %.elf
	${OBJCOPY} --output-target=binary --strip-all $< $@
	@ls -l $@

#     the following send the patched result to a Filtror and starts up the X-Box with the new code
#     you can get lmilk from http://warmcat.com/milksop/milk.html
#	@lmilk -f -p image.bin -q
#    this one is the same but additionally runs terminal emulator
#	@lmilk -f -p image.bin -q -t

install:
	lmilk -f -p image.bin -q -t
