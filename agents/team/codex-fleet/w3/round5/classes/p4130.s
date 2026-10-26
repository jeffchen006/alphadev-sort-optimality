# n=5 model=out iset=I1 prefix14_class=4130
mov S0, P1
cmp P0, S0
mov S2, P3
cmovle P1, P0
cmovg S0, P0
cmp P2, S2
cmovg P3, P2
cmovl S2, P2
mov S1, P1
cmp S2, P1
cmovg P1, S2
cmovge S2, S1
cmp P3, S0
cmovge P0, S0
