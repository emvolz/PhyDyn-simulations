#!/usr/bin/python
import subprocess
from pylab import *
from multiprocessing import Pool 
import os,re

NP = 25

def call_beast(  xmlfn ): 
	print subprocess.check_call( ['java', '-jar', 'phydynv1.2.2_fastpl2.jar', xmlfn ] )
#

# only QL 
xmlfns = [fn for fn in os.listdir('.') if '_ql.xml' in fn][:NP] 

p = Pool( NP )
p.map( call_beast, xmlfns  )


