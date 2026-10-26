# n=5 model=out iset=I1 prefix14_class=8385
cmp P3, P2
cmovle S2, P3
mov S0, P1
cmovle P3, P2
cmovle P2, S2
cmp S0, P0
cmovg S0, P0
mov S1, P3
cmovge P0, P1
cmp P3, P0
cmovle P3, P0
cmovl P0, S1
cmp S0, P2
cmovle S2, S0
