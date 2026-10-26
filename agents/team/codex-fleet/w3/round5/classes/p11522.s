# n=5 model=out iset=I1 prefix14_class=11522
mov S0, P0
cmp P3, P0
mov S2, P2
cmovge S0, P3
cmovle P0, P3
cmp P1, S2
cmovle P2, P1
cmovl P1, S2
mov P3, S0
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmovle P2, S2
mov S1, P0
