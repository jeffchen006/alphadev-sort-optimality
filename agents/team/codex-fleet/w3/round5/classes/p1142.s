# n=5 model=out iset=I1 prefix14_class=1142
cmp P0, P2
cmovle S0, P0
mov S1, P3
cmovl P0, P2
cmovle P2, S0
cmp P1, S1
cmovg P3, P1
cmovge P1, S1
cmp P3, P0
cmovle S1, P0
cmovl P0, P3
cmovge S1, P3
mov P3, P1
cmp P2, P3
