# n=5 model=out iset=I1 prefix14_class=8950
cmp P1, P2
cmovge S1, P1
cmovle S1, P2
cmovg P1, P2
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
cmp P3, S1
cmovge P2, P3
cmovge P3, S1
cmovl P2, S1
cmp P1, P0
mov S1, P1
