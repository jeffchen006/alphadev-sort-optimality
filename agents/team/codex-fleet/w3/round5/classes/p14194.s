# n=5 model=out iset=I1 prefix14_class=14194
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovl P0, S1
mov S0, P3
cmp P2, P3
cmovg S0, P2
cmovge P2, P3
mov S2, S0
cmp S2, P0
cmovle S2, P0
cmovl P0, S0
cmp P2, P1
cmovg S0, P2
