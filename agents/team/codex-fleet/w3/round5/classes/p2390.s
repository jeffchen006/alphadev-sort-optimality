# n=5 model=out iset=I1 prefix14_class=2390
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
cmovg P0, S0
mov S2, P2
mov S1, P0
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
cmp S1, S2
cmovl P0, S2
cmovle S2, S1
cmp P3, P1
cmovle P0, P3
