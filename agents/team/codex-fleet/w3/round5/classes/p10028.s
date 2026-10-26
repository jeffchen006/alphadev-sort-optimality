# n=5 model=out iset=I1 prefix14_class=10028
mov S0, P3
cmp P3, P1
cmovg P3, P1
cmovle S0, P1
mov S2, P2
cmp S2, P0
cmovge P2, P0
cmovge P0, S2
cmovge S2, P2
cmp P0, S0
cmovle P1, P0
cmovl P0, S0
cmovl S0, P1
cmp P3, S2
