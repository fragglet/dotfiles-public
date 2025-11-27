@echo off
if not exist nwt.cfg copy y:\nwt.cfg y:\genmidi.op2 . >nul
realnwt %1 %2 %3 %4 %5 %6 %7 %8 %9
