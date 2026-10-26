# n=5 model=out iset=I1 prefix14_class=4295
mov S0, P1
cmp S0, P0
cmovle S0, P0
cmovge P1, P0
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
cmovg S1, P3
mov S2, S1
cmp S2, P1
cmovle S2, P1
cmovl P1, S1
cmp S0, P2
cmovle P3, P2
