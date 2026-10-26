# n=5 model=out iset=I1 prefix14_class=7672
mov S0, P2
cmp S0, P3
cmovg S0, P3
cmovle P2, P3
cmp P0, P1
cmovge P3, P1
cmovg P1, P0
mov S2, P1
cmovg P0, P3
cmp S0, P0
cmovl S1, P0
cmovge S1, S0
cmovle P0, S0
cmp S2, P2
