# n=5 model=out iset=I1 prefix14_class=2228
cmp P0, P3
mov S0, P3
cmovg P3, P0
cmovg P0, S0
mov S2, P1
cmp P2, P1
cmovge P1, P2
mov S1, P1
cmovge P2, S2
cmp S1, P3
cmovle P1, P3
cmovl P3, S1
mov P1, P0
cmp P2, P1
