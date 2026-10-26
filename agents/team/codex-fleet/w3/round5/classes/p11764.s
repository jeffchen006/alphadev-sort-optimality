# n=5 model=out iset=I1 prefix14_class=11764
mov S2, P3
cmp S2, P0
cmovg S2, P0
cmovg P0, P3
cmp P2, P1
mov S1, P0
cmovl S0, P2
cmovle P2, P1
cmovl P1, S0
cmp P2, S1
cmovge S1, P2
cmovge P2, P0
cmp S2, P1
mov S1, S2
