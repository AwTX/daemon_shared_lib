OBJDIR = build
SRCDIR = src


all: demone_x demone_y $(OBJDIR)/libmylib.so

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(OBJDIR)
	gcc -fPIC -c $< -o $@

%: $(OBJDIR)/%.o
	gcc -fPIC -o $@ $< -ldl -lrt -lpthread -B $(OBJDIR) -Wl,-rpath,"\$$ORIGIN/$(OBJDIR)"

$(OBJDIR)/lib%.so: $(OBJDIR)/%.o
	gcc -fPIC -shared -o $@ $< -lrt

clean:
	-rm -rf $(OBJDIR) demone_x demone_y

.PHONY: clean all
