# n=5 model=out iset=I1 prefix14_class=1207
mov S0, P1
cmp P1, P2
cmovle P1, P2
cmovle P2, S0
cmp P0, P3
mov S2, P0
cmovl S2, P3
cmovge P0, P3
mov S0, P1
cmp P1, S2
cmovge P1, S2
cmovg S2, S0
cmp P2, P0
mov S1, P1
