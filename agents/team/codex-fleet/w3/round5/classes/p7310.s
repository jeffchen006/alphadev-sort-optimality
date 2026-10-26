# n=5 model=out iset=I1 prefix14_class=7310
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovle P0, S2
cmp P3, P2
cmovge S0, P2
cmovl S0, P3
cmovle P3, P2
mov S1, P1
cmp P1, S0
cmovge P1, S0
mov P1, P3
cmovg S0, S1
cmp P0, P3
