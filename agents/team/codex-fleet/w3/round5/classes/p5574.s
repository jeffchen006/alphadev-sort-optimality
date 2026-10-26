# n=5 model=out iset=I1 prefix14_class=5574
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovg P0, S1
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
cmovle P2, S0
mov S2, P3
mov S0, P2
cmp P0, P2
cmovge P2, P0
cmovle S0, P0
cmp P3, P1
