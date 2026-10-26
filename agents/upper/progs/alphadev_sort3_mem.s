# n=3 iset=I1 model=mem source=AlphaDev Sort3AlphaDev (sort_functions_test.cc), L=17
mov S0, M1
mov S1, M2
cmp S1, S0
mov S2, S0
cmovl S2, S1
mov S3, M0
cmovg S0, S1
cmp S0, S3
mov S1, S3
cmovl S1, S0
cmovle S0, S3
mov M2, S0
cmp S2, S1
cmovle S3, S2
mov M0, S3
cmovg S1, S2
mov M1, S1
