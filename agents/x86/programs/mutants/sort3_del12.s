# n=3 R=7 iset=I1 source=AlphaDev sort_functions_test.cc Sort3AlphaDev (converted by agents/x86/src/extract_alphadev.py)
# L=17 ; S map: S0=eax S1=ecx S2=edx S3=r8d
mov S0, P1
mov S1, P2
cmp S1, S0
mov S2, S0
cmovl S2, S1
mov S3, P0
cmovg S0, S1
cmp S0, S3
mov S1, S3
cmovl S1, S0
cmovle S0, S3
mov P2, S0
cmovle S3, S2
mov P0, S3
cmovg S1, S2
mov P1, S1
