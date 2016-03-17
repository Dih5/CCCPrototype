CC = gcc
FLAGS = -g -c
LDFLAGS = -lm


CUDACC= nvcc
CUDAFLAGS= -G -g
CUDALDFLAGS = -lm -link

SOURCEDIR = src
CUDADIR = src
TESTDIR= test
DOXYFILE = doc.doxyfile

BUILDDIR = build
DOCDIR = doc

EXECUTABLE = add
CPUEXECUTABLE = addCPU
TESTEXECUTABLE = addTests

SOURCES = $(wildcard $(SOURCEDIR)/*.c)
OBJECTS = $(patsubst $(SOURCEDIR)/%.c,$(BUILDDIR)/%.o,$(SOURCES))
CPUOBJECTS = $(patsubst $(SOURCEDIR)/%.c,$(BUILDDIR)/cpu/%.o,$(SOURCES))
CUDASOURCES = $(wildcard $(CUDADIR)/*.cu)
CUDAOBJECTS = $(patsubst $(CUDADIR)/%.cu,$(BUILDDIR)/%.o,$(CUDASOURCES))
TESTSOURCES = $(wildcard $(TESTDIR)/*.c)
TESTOBJECTS = $(patsubst $(TESTDIR)/%.c,$(BUILDDIR)/%.o,$(TESTSOURCES))
OBJECTSFORTESTS = $(filter-out $(BUILDDIR)/main.o,$(OBJECTS))


all: dir $(BUILDDIR)/$(EXECUTABLE) $(BUILDDIR)/$(TESTEXECUTABLE)

cpu: dircpu $(BUILDDIR)/$(CPUEXECUTABLE)

dir:
	mkdir -p $(BUILDDIR)
	
dircpu:
	mkdir -p $(BUILDDIR)/cpu
	
doc:
	doxygen $(DOXYFILE)

$(BUILDDIR)/$(EXECUTABLE): $(OBJECTS) $(CUDAOBJECTS)
	$(CUDACC) $(CUDALDFLAGS) -o $@ $^
	
$(BUILDDIR)/$(CPUEXECUTABLE): $(CPUOBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^
	
$(BUILDDIR)/$(TESTEXECUTABLE): $(OBJECTSFORTESTS) $(CUDAOBJECTS) $(TESTOBJECTS)
	$(CUDACC) $(CUDALDFLAGS) -o $@ $^

$(OBJECTS): $(BUILDDIR)/%.o : $(SOURCEDIR)/%.c
	$(CC) $(FLAGS) $< -o $@
	
$(CPUOBJECTS): $(BUILDDIR)/cpu/%.o : $(SOURCEDIR)/%.c
	$(CC) -DONLY_CPU $(FLAGS) $< -o $@
	
$(CUDAOBJECTS): $(BUILDDIR)/%.o : $(CUDADIR)/%.cu
	$(CUDACC) $(CUDAFLAGS) -c -o $@ $<
	
$(TESTOBJECTS): $(BUILDDIR)/%.o : $(TESTDIR)/%.c
	$(CC) $(FLAGS) $< -o $@
	

clean:
	rm -f $(BUILDDIR)/*o $(BUILDDIR)/$(EXECUTABLE) $(BUILDDIR)/$(TESTEXECUTABLE)
	rm -rf $(DOCDIR)
	
.PHONY: clean all cpu dir dircpu doc