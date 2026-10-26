# n=5 model=out iset=I1 prefix14_class=4682
mov S0, P3
cmp P0, P3
cmovle P3, P0
cmovge S0, P0
cmp P2, P1
mov S2, P2
cmovge P2, P1
cmovl S2, P1
cmovg P1, S2
cmp S2, S0
cmovge S2, S0
cmovl P1, S0
cmp P2, P3
cmovge P0, P2
