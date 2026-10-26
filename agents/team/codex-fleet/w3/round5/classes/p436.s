# n=5 model=out iset=I1 prefix14_class=436
mov S2, P3
mov S1, P1
cmp P1, P0
cmovl S1, P0
cmovle P0, P1
cmp P3, P2
cmovg S2, P2
cmovge P2, P3
mov S0, S2
cmp P0, S2
cmovle S0, P0
cmovle P0, S2
cmp P2, S1
mov S0, P2
