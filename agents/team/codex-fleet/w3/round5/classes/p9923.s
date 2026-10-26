# n=5 model=out iset=I1 prefix14_class=9923
mov S2, P1
mov S0, P0
cmp P2, S2
cmovg S2, P2
cmovg P2, P1
cmp S0, P3
cmovl S0, P3
cmovle P3, P0
cmp S0, S2
cmovge P1, S2
mov S1, P3
cmovge S2, S0
cmovge S0, P1
cmp P3, P2
