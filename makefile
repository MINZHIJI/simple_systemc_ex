# compiler
CXX = clang++

# SYSTEMC path (check system environment SYSTEMC_HOME is available)
SYSTEMC_HOME ?= /path/to/systemc

# compiler flags
NOWARN = 
# NOWARN = -Wunused-but-set-variable
# NOWARN = -Wall
CXXFLAGS = -I$(SYSTEMC_HOME)/include -Iinc -g -std=c++17 $(NOWARN) -g
LDFLAGS = -L$(SYSTEMC_HOME)/lib -lsystemc
WAVEFORM_FOLDER = output
WAVEFORM_CONFIG ?= wave_config/tmp.sav
DOC_FOLDER = output/docs
# target object file
TARGET = bin/main

# source code
SRCS = $(wildcard src/*.cpp)

# object directory
OBJDIR = obj
# binary directory
BINDIR = bin

# object files
OBJS = $(patsubst src/%.cpp, $(OBJDIR)/%.o, $(SRCS))

# compile and link
$(TARGET): $(OBJS) $(BINDIR)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

# compile
$(OBJDIR)/%.o: src/%.cpp | $(OBJDIR)
	$(CXX) -c $< -o $@ $(CXXFLAGS)

# create object directory
$(OBJDIR):
	mkdir -p $(OBJDIR)

$(BINDIR):
	mkdir -p $(BINDIR)

$(WAVEFORM_FOLDER):
	mkdir -p $(WAVEFORM_FOLDER)

# clean
clean:
	rm -f $(OBJDIR)/*.o $(TARGET) $(WAVEFORM_FOLDER)/*.vcd
	rm -f dev_environment.tar.gz
	rm -rf $(DOC_FOLDER)
run: $(TARGET) $(WAVEFORM_FOLDER)
	$(TARGET)

debug: $(TARGET) $(WAVEFORM_FOLDER)
	lldb $(TARGET)

waveform:
	gtkwave $(WAVEFORM_FOLDER)/waveform.vcd $(WAVEFORM_CONFIG)

tar_env:
	tar -czvf dev_environment.tar.gz bin inc obj output src util wave_config makefile

doc:
	doxygen docs/Doxyfile.in 