# n=5 model=out iset=I1 prefix14_class=5026
mov S1, P1
cmp P2, S1
cmovle S1, P2
cmovg P1, P2
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
mov P2, P1
cmovl P0, S0
cmp S1, P3
cmovge S0, P3
cmovg P3, S1
cmovg S1, S0
cmp P0, P2
