# n=5 model=out iset=I1 prefix14_class=6023
mov S2, P3
cmp P2, P3
cmovl P3, P2
cmovle P2, S2
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovle P1, S0
mov S2, P2
cmp S2, P1
cmovge S2, P1
cmovg P1, P2
cmp P3, P0
cmovge S1, P0
