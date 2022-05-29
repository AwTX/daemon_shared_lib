OBJDIR = build/
SRCDIR = src/

$(shell mkdir -p $(OBJDIR))

demone_x : $(OBJDIR)demone_x.o $(OBJDIR)libmylib.so 
	gcc -o demone_x $(OBJDIR)demone_x.o -lmylib -ldl -lrt lpthread -B $(OBJDIR) -Wl,-rpath,"\$$ORIGIN/$(OBJDIR)"

demone_y : $(OBJDIR)demone_y.o $(OBJDIR)libmylib.so 
	gcc -o demone_y $(OBJDIR)demone_y.o -lmylib -ldl -lrt lpthread -B $(OBJDIR) -Wl,-rpath,"\$$ORIGIN/$(OBJDIR)"

$(OBJDIR)mylib.o : $(SRCDIR)mylib.c $(SRCDIR)mylib.h
	gcc -o $(OBJDIR)mylib.o -c $(SRCDIR)mylib.c

$(OBJDIR)libmylib.so : $(OBJDIR)mylib.o
	gcc -shared -o $(OBJDIR)libmylib.so $(OBJDIR)mylib.o -fPIC

$(OBJDIR)demone_x.o : $(SRCDIR)demone_x.c
	gcc -o $(OBJDIR)demone_x.o -c $(SRCDIR)demone_x.c

$(OBJDIR)demone_y.o : $(SRCDIR)demone_y.c
	gcc -o $(OBJDIR)demone_y.o -c $(SRCDIR)demone_y.c

clean :
	-rm -rf $(OBJDIR) demone_x demone_y


