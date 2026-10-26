# n=5 model=out iset=I1 prefix14_class=10873
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovl P2, S2
mov S1, P3
cmp P1, P3
cmovg P3, P1
mov S0, P2
cmovle S1, P1
cmp P3, P2
cmovle P2, P3
cmovge S0, P3
cmp P0, S1
cmovle P3, S1
