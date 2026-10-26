# n=5 model=out iset=I1 prefix14_class=3636
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovle P1, S1
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovle P0, S1
mov S0, P1
cmp P2, P1
cmovl S0, P2
cmovge P1, P2
cmp P3, P0
mov S2, P3
