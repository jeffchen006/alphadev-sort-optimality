# n=5 model=out iset=I1 prefix14_class=13501
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
mov S2, P2
cmovl P1, S0
cmp P3, P2
cmovge P2, P3
mov S1, P0
cmovle S2, P3
cmovg P3, S2
cmp P1, S2
cmovle S2, P1
cmovl P1, P3
cmp P2, P0
