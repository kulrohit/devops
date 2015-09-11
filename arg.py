#!/usr/bin/python

import sys

print 'Number of Arguments:',len(sys.argv) , 'arguments.'
if len(sys.argv) < 3:
	print "ERROR:less arguments"
	sys.exit()
else:
	print 'argument list:', str(sys.argv)
        print 'please advise what should I do with this arguments ?'
