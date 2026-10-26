# n=5 model=out iset=I1 prefix14_class=3225
cmp P3, P2
mov S0, P1
cmovl S1, P3
cmovge S1, P2
cmovge P2, P3
cmp P0, P1
cmovle P1, P0
cmovg S0, P0
mov P3, P1
cmp S1, P1
cmovg P3, S1
cmovg S1, P1
cmp S0, P2
cmovle P0, P2
