# n=5 model=out iset=I1 prefix14_class=6422
cmp P0, P1
mov S1, P0
cmovge P0, P1
cmovge P1, S1
mov S0, P2
cmp P3, P2
cmovle P2, P3
cmovg S0, P3
mov S1, S0
cmp P1, S1
cmovl S1, P1
cmovge S0, P1
cmp P2, P0
cmovg S2, P0
