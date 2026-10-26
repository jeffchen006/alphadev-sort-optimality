# n=5 model=out iset=I1 prefix14_class=8254
cmp P2, P0
mov S2, P2
cmovle P2, P0
cmovg S2, P0
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
mov P0, P2
cmovge P1, S1
cmp P1, S2
mov S0, S2
cmovl S0, P1
cmovg S2, P1
cmp P3, P2
