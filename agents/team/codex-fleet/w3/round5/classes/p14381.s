# n=5 model=out iset=I1 prefix14_class=14381
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovle P2, S0
cmovg S0, P2
mov S2, P0
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
cmp S0, P1
cmovle S0, P1
cmovl P1, P2
cmovle P2, S0
