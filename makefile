# makeFile

PREPROCESSOR = /D"WIN32" /D"_CONSOLE" /D"_WINDLL" /D"_UNICODE" /D"UNICODE"
INCLUDES  = "c:\Python27\include"
LIBPATHS  = "c:\Python27\libs"
BOOSTINC  = "d:\boost_1_60_0"
BOOSTLIB  = "d:\boost_1_60_0\stage\lib"
CCDEBUG   = /nologo /D"DEBUG"  $(PREPROCESSOR)
CCRELEASE = /nologo /D"NDEBUG" $(PREPROCESSOR)

!IFDEF debug  
CC = $(CCDEBUG)  
OUTDIR = .\bin
OBJDIR = .\obj
!ELSE
CC = $(CCRELEASE)  
OUTDIR = .\bin
OBJDIR = .\obj
!ENDIF  

all: $(OUTDIR) $(OBJDIR) \
	$(OUTDIR)\spammodule.pyd \
	$(OUTDIR)\client.pyd \
	$(OUTDIR)\helloboost.pyd
  
$(OUTDIR): ; @mkdir $(OUTDIR)
$(OBJDIR): ; @mkdir $(OBJDIR)

# compile
$(OBJDIR)\spammodule.obj: .\spammodule\spammodule.c
	@echo compile ...
    @cl /c $(CC) /I$(INCLUDES) /Fo"$(OBJDIR)\\" /Fd"$(OBJDIR)\\" \
		".\spammodule\spammodule.c"
	@echo compile completed

$(OBJDIR)\client.obj: .\client\client.c
	@echo compile ...
    @cl /c $(CC) /I$(INCLUDES) /Fo"$(OBJDIR)\\" /Fd"$(OBJDIR)\\" \
		".\client\client.c"
	@echo compile completed

$(OBJDIR)\helloboost.obj: .\helloboost\helloboost.cpp
	@echo compile ...
    @cl /c $(CC) /EHsc /MD /I$(INCLUDES) /I$(BOOSTINC) /Fo"$(OBJDIR)\\" /Fd"$(OBJDIR)\\" \
		".\helloboost\helloboost.cpp"
	@echo compile completed

# link
$(OUTDIR)\spammodule.pyd: $(OBJDIR)\spammodule.obj
	@echo link ...
	@link /NOLOGO /MACHINE:x86 /INCREMENTAL:NO /SUBSYSTEM:CONSOLE /DLL \
		/LIBPATH:$(LIBPATHS) /OUT:$(OUTDIR)\spammodule.pyd \
		"kernel32.lib" \
		"$(OBJDIR)\spammodule.obj"
	@echo link completed

$(OUTDIR)\client.pyd: $(OBJDIR)\client.obj
	@echo link ...
	@link /NOLOGO /MACHINE:x86 /INCREMENTAL:NO /SUBSYSTEM:CONSOLE /DLL \
		/LIBPATH:$(LIBPATHS) /OUT:$(OUTDIR)\client.pyd \
		"kernel32.lib" \
		"$(OBJDIR)\client.obj"
	@echo link completed

$(OUTDIR)\helloboost.pyd: $(OBJDIR)\helloboost.obj
	@echo link ...
	@link /NOLOGO /MACHINE:x86 /INCREMENTAL:NO /SUBSYSTEM:WINDOWS /DLL \
		/LIBPATH:$(LIBPATHS) /LIBPATH:$(BOOSTLIB) /OUT:$(OUTDIR)\helloboost.pyd \
		"kernel32.lib" \
		"$(OBJDIR)\helloboost.obj"
	@echo link completed

.PHONY: clean cleanobj cleanlib
clean: cleanobj cleanlib
	@echo project has clean
cleanobj:
	@del $(OBJDIR)\*.obj > nul 2>&1
cleanlib:
	@del $(OUTDIR)\*.lib > nul 2>&1
	@del $(OUTDIR)\*.exp > nul 2>&1
	@del $(OUTDIR)\*.pyd > nul 2>&1
