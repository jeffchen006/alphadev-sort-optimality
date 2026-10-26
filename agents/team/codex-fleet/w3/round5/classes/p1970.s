# n=5 model=out iset=I1 prefix14_class=1970
cmp P2, P1
cmovl S0, P2
mov S2, P0
cmovge S0, P1
cmovl P2, P1
cmp P3, S2
cmovle P0, P3
cmovge S2, P3
mov P3, P2
cmp P2, S2
cmovle P3, S2
cmovle S2, P2
cmp P0, S0
cmovle S1, P0
