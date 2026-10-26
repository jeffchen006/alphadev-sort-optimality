# n=5 model=out iset=I1 prefix14_class=1755
cmp P3, P1
cmovge S0, P1
cmovge P1, P3
cmovge P3, S0
cmp P0, P2
cmovl S0, P2
cmovle P2, P0
mov S2, P3
cmovl P0, S0
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovle S1, P0
cmp S2, P2
