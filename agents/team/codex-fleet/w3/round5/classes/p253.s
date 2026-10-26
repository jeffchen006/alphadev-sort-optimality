# n=5 model=out iset=I1 prefix14_class=253
cmp P1, P3
cmovg S0, P3
cmovge P3, P1
cmovg P1, S0
cmovle S0, P1
mov S1, P0
cmp P2, S1
cmovge S1, P2
cmovle P0, P2
cmp P0, P1
cmovl P1, P0
mov P1, S1
cmovle P0, S0
cmp S1, P3
