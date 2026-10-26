# n=5 model=out iset=I1 prefix14_class=11594
cmp P2, P3
cmovle S0, P2
cmovg S0, P3
cmovl P2, P3
cmp P1, P0
cmovge P3, P1
cmovg P1, P0
cmovle P3, P0
mov P0, P2
cmp S0, P1
cmovle S1, P1
cmovl P1, S0
cmovle S0, S1
mov S2, S0
