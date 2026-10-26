# n=5 model=out iset=I1 prefix14_class=2540
cmp P3, P0
mov S2, P0
cmovle P0, P3
cmovle P3, S2
cmp P2, P1
cmovle S0, P2
cmovl P2, P1
cmovle P1, S0
mov S2, P3
cmp P3, P2
cmovl P3, P2
mov P3, P0
cmovge S2, P2
cmp P0, P1
