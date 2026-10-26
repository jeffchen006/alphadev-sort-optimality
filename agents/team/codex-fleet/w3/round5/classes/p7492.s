# n=5 model=out iset=I1 prefix14_class=7492
cmp P3, P0
mov S1, P3
mov S2, P1
cmovg P3, P0
cmovl S1, P0
mov S0, P3
cmp P1, P2
cmovle P1, P2
cmovg S2, P2
cmp S2, P3
cmovle P3, S2
cmovge S0, S2
cmp S1, P1
cmovle P2, P1
