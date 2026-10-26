# n=5 model=out iset=I1 prefix14_class=5610
mov S0, P0
cmp P0, P1
cmovge S0, P1
cmovl P0, P1
cmp P2, P3
cmovle S2, P2
mov S1, S0
cmovle P2, P3
cmovle P3, S2
cmp S1, P3
cmovg S1, P3
cmovge P3, S0
cmp P0, P2
cmovle S0, P0
