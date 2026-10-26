# n=5 model=out iset=I1 prefix14_class=1426
mov S0, P1
mov S2, P3
cmp S0, P0
cmovge S0, P0
cmovg P0, P1
cmp P2, S2
cmovge P3, P2
cmovge P2, S2
cmp P3, P0
mov P1, P3
cmovle P1, P0
cmovl P0, P3
cmovge P3, P0
cmp P2, S0
