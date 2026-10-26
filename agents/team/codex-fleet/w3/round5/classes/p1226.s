# n=5 model=out iset=I1 prefix14_class=1226
mov S1, P0
cmp P0, P3
cmovle P0, P3
cmovle P3, S1
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
cmovl S2, P2
cmp P0, S2
mov S0, P0
cmovg P0, S2
cmovg S2, S0
cmp P1, P3
cmovge S0, P1
