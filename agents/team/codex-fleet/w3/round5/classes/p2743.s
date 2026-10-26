# n=5 model=out iset=I1 prefix14_class=2743
mov S1, P0
mov S0, P1
cmp P0, P2
cmovge S1, P2
cmovg P2, P0
cmp P3, P1
cmovl P1, P3
cmovl P3, S0
cmp P3, P2
mov S0, P1
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
mov P3, P2
