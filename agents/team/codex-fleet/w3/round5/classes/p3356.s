# n=5 model=out iset=I1 prefix14_class=3356
mov S0, P3
mov S1, P0
cmp P1, S0
cmovg P3, P1
cmovle S0, P1
mov P1, S0
cmp P2, P0
cmovle S1, P2
cmovge P0, P2
cmp P1, S1
cmovge S0, S1
cmovg S1, P1
cmp P3, P0
cmovle S0, P0
