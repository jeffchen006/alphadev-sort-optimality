# n=5 model=out iset=I1 prefix14_class=8026
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovg S1, P1
mov S2, P0
cmovg P1, P2
cmp S2, P3
cmovge S2, P3
cmovle P0, P3
cmp S2, P2
cmovl P2, S2
cmovle S2, P1
cmp S1, P0
cmovg S0, S1
