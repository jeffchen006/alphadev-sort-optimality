# n=5 model=out iset=I1 prefix14_class=356
cmp P0, P2
cmovle S0, P2
cmovge S0, P0
cmovg P0, P2
mov S1, P0
mov S2, P1
cmp P1, P3
cmovg P1, P3
cmovg P3, S2
cmp P1, P0
cmovl P0, P1
cmovle P1, S1
mov S2, S0
cmp P3, S0
