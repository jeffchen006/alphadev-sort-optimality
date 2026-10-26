# n=5 model=out iset=I1 prefix14_class=2128
mov S0, P3
cmp P1, P3
cmovge S0, P1
mov S2, P0
cmovle P3, P1
cmp S2, P2
cmovge S2, P2
cmovge P2, P0
cmovl P0, P2
cmp P0, S0
cmovle P0, S0
cmovg P2, S0
mov S0, P3
cmp S0, S2
