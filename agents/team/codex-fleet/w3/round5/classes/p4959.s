# n=5 model=out iset=I1 prefix14_class=4959
cmp P3, P2
cmovg S0, P3
cmovle S0, P2
mov S2, P1
cmovg P3, P2
cmp S2, P0
cmovl P1, P0
cmovle P0, S2
mov S1, P1
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
cmovg P3, S2
cmp S1, S0
