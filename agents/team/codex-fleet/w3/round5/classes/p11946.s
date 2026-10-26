# n=5 model=out iset=I1 prefix14_class=11946
cmp P2, P0
mov S2, P2
cmovle S2, P0
cmovle P0, P2
cmp P1, P3
mov S1, P1
cmovl P1, P3
cmovle P3, S1
cmp S2, P1
cmovg S1, S2
cmovge S2, P1
cmovg P1, S1
cmp P3, P0
mov S0, P3
