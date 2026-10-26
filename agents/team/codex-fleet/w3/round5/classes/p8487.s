# n=5 model=out iset=I1 prefix14_class=8487
cmp P3, P0
cmovg S1, P0
cmovle S1, P3
cmovle P3, P0
mov S0, P3
cmp P2, P1
cmovle P0, P2
cmovl P2, P1
cmovle P1, P0
cmp S0, P2
cmovge S0, P2
cmovle P3, P2
cmp P1, S1
mov P3, P1
