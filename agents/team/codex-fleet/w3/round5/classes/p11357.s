# n=5 model=out iset=I1 prefix14_class=11357
cmp P0, P1
cmovge S1, P1
mov S0, P2
cmovge P1, P0
cmovg P0, S1
cmp P3, P2
cmovl P2, P3
mov S2, P0
cmovg S0, P3
cmp S0, P1
cmovle S1, S0
cmovle S0, P1
cmovle P1, S1
cmp P2, S2
