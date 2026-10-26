# n=5 model=out iset=I1 prefix14_class=14162
cmp P0, P3
cmovle S0, P3
mov S2, P1
cmovle P3, P0
cmovl P0, S0
mov S1, P0
cmp P2, S2
cmovg P1, P2
cmovg P2, S2
cmp P0, P1
cmovge P0, P1
cmovg P1, S1
cmp P3, P2
mov S1, P3
