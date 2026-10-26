# n=5 model=out iset=I1 prefix14_class=12920
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovge P2, P1
mov S0, P0
cmp P3, P0
cmovg S0, P3
cmovle P0, P3
cmp P0, S1
cmovg P1, S1
cmovge S1, P0
mov S2, P2
cmovg P0, P1
cmp S0, S2
