# n=5 model=out iset=I1 prefix14_class=3489
mov S1, P2
cmp P3, P1
mov S2, P1
cmovl S2, P3
cmovle P3, P1
cmp P2, P0
cmovle P2, P0
cmovg S1, P0
mov S0, S1
cmp S2, S1
cmovg S0, S2
cmovge S2, S1
mov S1, P3
cmp P3, P2
