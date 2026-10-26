# n=5 model=out iset=I1 prefix14_class=5624
cmp P2, P1
mov S2, P2
cmovg S2, P1
cmovl P2, P1
cmp P0, P3
mov S0, P0
cmovl P0, P3
cmovle P3, S0
mov S0, S2
cmp S2, P3
cmovge S2, P3
cmovge P3, S0
cmp P2, P0
cmovge P1, P2
