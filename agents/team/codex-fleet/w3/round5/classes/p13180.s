# n=5 model=out iset=I1 prefix14_class=13180
cmp P2, P0
cmovle S2, P2
cmovle P2, P0
cmovle P0, S2
cmp P1, P3
mov S1, P3
cmovge P3, P1
mov S0, P0
cmovle S1, P1
cmp S1, S0
cmovg S0, S1
cmovl P0, S1
cmp P3, P2
cmovle P0, P2
