# n=5 model=out iset=I1 prefix14_class=4083
mov S2, P2
mov S0, P0
cmp P2, P3
cmovle P2, P3
cmovl P3, S2
cmp P1, S0
cmovge S0, P1
cmovg P1, P0
cmp P1, P3
cmovle S1, P1
cmovg S1, P3
mov S1, S0
cmovle P1, P3
cmp S0, P2
