# n=5 model=out iset=I1 prefix14_class=3878
mov S1, P0
mov S0, P2
cmp P0, P1
cmovge P0, P1
cmovg P1, S1
cmp S0, P3
mov S2, P0
cmovle S0, P3
cmovle P3, P2
cmp S2, P3
cmovle S2, P3
cmovl P3, P0
cmp P1, S0
cmovge P3, P1
