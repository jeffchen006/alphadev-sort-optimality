# n=5 model=out iset=I1 prefix14_class=8894
cmp P1, P0
mov S1, P1
mov S0, P2
cmovle S1, P0
cmovge P1, P0
cmp P3, S0
cmovle S0, P3
cmovl P3, P2
cmp S1, P3
cmovle P2, S1
cmovl S1, P3
cmovle P3, P2
mov S2, S0
mov S1, P3
