# n=5 model=out iset=I1 prefix14_class=1312
mov S1, P0
cmp P3, S1
cmovl S1, P3
cmovle P3, P0
mov S0, P2
cmp S0, P1
cmovge S0, P1
cmovg P1, P2
mov P2, P3
cmp P1, P3
cmovge P3, P1
cmovge P1, P2
cmovle P2, P1
mov P3, S1
