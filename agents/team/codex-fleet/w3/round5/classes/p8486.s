# n=5 model=out iset=I1 prefix14_class=8486
cmp P3, P0
cmovle S1, P3
cmovg S1, P0
cmovle P3, P0
cmp P2, P1
cmovle P0, P2
cmovl P2, P1
cmovle P1, P0
mov S0, P3
cmp S0, P2
cmovle P3, P2
cmovge S0, P2
mov P3, S1
cmp S1, P1
