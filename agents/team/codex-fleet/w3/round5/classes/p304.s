# n=5 model=out iset=I1 prefix14_class=304
cmp P1, P3
mov S0, P0
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp P2, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, P0
mov P2, P0
cmovl P0, P1
cmovle P1, P2
cmp S0, P3
mov P0, P3
