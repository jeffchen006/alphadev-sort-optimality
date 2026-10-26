# n=5 model=out iset=I1 prefix14_class=5656
cmp P0, P3
mov S2, P3
cmovl P3, P0
cmovle P0, S2
cmp P1, P2
mov S2, P1
cmovle P1, P2
mov S1, P3
cmovge S2, P2
cmp S2, S1
cmovle S1, S2
cmovle S2, P3
cmp P1, P0
cmovle S0, P1
