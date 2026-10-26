# n=5 model=out iset=I1 prefix14_class=5443
mov S0, P0
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovge S2, P1
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
cmp P3, S2
mov S1, S2
cmovle S2, P3
cmovg S1, P3
cmp S0, P2
cmovle P3, S0
