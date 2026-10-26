# n=5 model=out iset=I1 prefix14_class=2684
mov S0, P0
mov S2, P3
cmp S2, P1
cmovge S2, P1
cmovg P1, P3
cmp S0, P2
cmovge S0, P2
cmovle P0, P2
cmp P1, P0
cmovl P2, P1
cmovge P2, P0
cmovl P1, P0
cmp S0, S2
cmovg P0, P2
