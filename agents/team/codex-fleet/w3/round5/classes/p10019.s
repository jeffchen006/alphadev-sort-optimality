# n=5 model=out iset=I1 prefix14_class=10019
mov S1, P0
cmp P2, P3
mov S2, P3
cmovl S2, P2
cmovle P2, P3
cmp P0, P1
cmovle S1, P1
mov S0, P2
cmovge P0, P1
cmp S0, S1
cmovl S0, S1
cmovl S1, P2
cmp S2, P0
cmovl P3, P0
