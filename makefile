OBJDIR = build/
SRCDIR = src/

$(shell mkdir -p $(OBJDIR))

demone : $(OBJDIR)demone.o $(OBJDIR)libmylib.so 
	gcc -o demone $(OBJDIR)demone.o -lmylib -ldl -B $(OBJDIR) -Wl,-rpath,"\$$ORIGIN/$(OBJDIR)"

$(OBJDIR)mylib.o : $(SRCDIR)mylib.c $(SRCDIR)mylib.h
	gcc -o $(OBJDIR)mylib.o -c $(SRCDIR)mylib.c

$(OBJDIR)libmylib.so : $(OBJDIR)mylib.o
	gcc -shared -o $(OBJDIR)libmylib.so $(OBJDIR)mylib.o

$(OBJDIR)demone.o : $(SRCDIR)demone.c
	gcc -o $(OBJDIR)demone.o -c $(SRCDIR)demone.c

clean :
	-rm -rf $(OBJDIR) demone


