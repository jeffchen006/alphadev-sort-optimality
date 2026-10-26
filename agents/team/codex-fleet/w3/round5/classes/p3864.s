# n=5 model=out iset=I1 prefix14_class=3864
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovle S0, P3
mov S1, P1
cmp P1, P2
cmovle P1, P2
mov S2, S0
cmovl P2, S1
cmp S0, P2
cmovle S2, P2
cmovle P2, S0
cmovle S0, S2
mov P2, P0
