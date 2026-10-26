# n=5 model=out iset=I1 prefix14_class=1132
mov S2, P1
cmp P2, P1
cmovle P1, P2
mov S1, P0
cmovge S2, P2
cmp P3, S1
cmovg S1, P3
cmovg P3, P0
mov S0, S1
cmp S2, S1
cmovg S1, S2
cmovl S0, S2
mov S1, P3
cmp P1, P3
