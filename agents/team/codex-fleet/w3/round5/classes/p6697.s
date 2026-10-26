# n=5 model=out iset=I1 prefix14_class=6697
mov S1, P1
mov S2, P3
cmp P2, P3
cmovl P3, P2
cmovle P2, S2
cmp P0, S1
cmovl S1, P0
cmovge P1, P0
mov S0, P1
cmp P2, S0
cmovle S0, P2
cmovge P1, P2
cmp S1, P3
cmovle P2, S1
