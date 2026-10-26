# n=5 model=out iset=I1 prefix14_class=12644
mov S2, P0
cmp P2, S2
mov S1, P3
cmovge P0, P2
cmovle S2, P2
cmp P1, P3
cmovl P3, P1
cmovl P1, S1
cmp S2, P3
cmovle S0, P3
cmovl P3, S2
cmovle S2, S0
cmp P1, P0
cmovl S0, P1
