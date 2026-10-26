# n=5 model=out iset=I1 prefix14_class=7835
cmp P3, P1
cmovl S2, P3
cmovge S2, P1
cmovg P1, P3
cmp P0, P2
cmovl S1, P0
cmovge S1, P2
mov S0, S2
cmovge P2, P0
cmp S1, S0
cmovl S0, S1
cmovg S2, S1
cmp P2, P1
cmovle P0, P1
