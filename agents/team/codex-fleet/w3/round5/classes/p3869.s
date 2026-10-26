# n=5 model=out iset=I1 prefix14_class=3869
cmp P2, P3
cmovle S0, P2
cmovg S0, P3
cmovge P3, P2
mov S2, S0
mov P2, P1
cmp P1, P0
cmovle P2, P0
cmovl P0, P1
cmp S2, P0
cmovle S0, P0
cmovl P0, S2
cmp P2, P3
cmovle S1, P3
