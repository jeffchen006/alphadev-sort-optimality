# n=5 model=out iset=I1 prefix14_class=11156
cmp P2, P1
cmovle S1, P2
mov S0, P0
cmovle P2, P1
cmovl P1, S1
cmp P0, P3
cmovge P0, P3
cmovg P3, S0
cmovle S0, P3
cmp P3, P2
cmovge S0, P2
cmovl P3, P2
cmp P1, P0
mov P3, P0
