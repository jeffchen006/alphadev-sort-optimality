# n=5 model=out iset=I1 prefix14_class=5613
cmp P0, P1
cmovle S0, P0
cmovl P0, P1
cmovg S0, P1
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovle P3, S2
mov S1, S0
cmp S0, P3
cmovge S1, P3
mov S1, P2
cmovge P3, S0
cmp P2, P0
