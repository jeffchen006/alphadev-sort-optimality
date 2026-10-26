# n=5 model=out iset=I1 prefix14_class=7124
mov S1, P1
mov S0, P3
cmp P0, S0
cmovle P3, P0
cmovl P0, S0
cmp S1, P2
cmovge S1, P2
cmovle P1, P2
mov P2, S1
cmp P3, S1
cmovle S1, P3
cmovge P2, P3
cmp P0, P1
cmovg S0, P0
