# n=5 model=out iset=I1 prefix14_class=4417
mov S1, P2
mov S2, P1
cmp P2, P0
cmovg S1, P0
cmovl P2, P0
cmp S2, P3
cmovge S2, P3
cmovg P3, P1
mov P1, S1
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
cmovle P2, S0
cmp P1, S2
