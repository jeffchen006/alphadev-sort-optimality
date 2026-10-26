# n=5 model=out iset=I1 prefix14_class=1638
cmp P1, P0
cmovge S0, P1
mov S1, P2
cmovge P1, P0
cmovle S0, P0
cmp P3, S1
mov S2, P1
cmovge P2, P3
cmovl S1, P3
cmp P1, S1
cmovle P1, S1
cmovge S2, S1
cmp S0, P2
mov S1, P1
