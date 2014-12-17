
DIRS = $(wildcard ??_*)

# 
TARGET ?= CI20

OPT= TARGET=$(TARGET)
#

all:
	set -e ; for d in $(DIRS); do make -C $$d $(OPT); done

clean:
	set -e ; for d in $(DIRS); do make -C $$d $(OPT) clean; done

