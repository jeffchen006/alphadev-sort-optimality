# n=5 model=out iset=I1 prefix14_class=4512
cmp P1, P3
cmovg S0, P1
mov S1, P2
cmovle S0, P3
cmovg P1, P3
cmp P2, P0
cmovle S1, P0
cmovg P2, P0
cmovg P0, S1
cmp S1, S0
cmovge P0, S0
cmovg S0, S1
cmp P2, P1
cmovle S1, P2
