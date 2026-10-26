# n=5 model=out iset=I1 prefix14_class=3092
cmp P2, P3
cmovge S1, P2
cmovle S1, P3
cmovg P2, P3
mov S2, P0
cmp P1, P0
cmovl P0, P1
cmovl P1, S2
mov P3, P0
cmp P0, P2
cmovle P0, P2
cmovg P3, P2
cmp S1, P1
cmovg S0, S1
