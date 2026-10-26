# n=5 model=out iset=I1 prefix14_class=1878
mov S1, P0
cmp P2, P0
cmovle P0, P2
cmovle P2, S1
mov S2, P1
cmp P3, S2
mov S0, P2
cmovle S2, P3
cmovg P1, P3
cmp P1, P2
cmovle P2, P1
cmovl P1, S0
cmp P0, S2
cmovge S0, P2
