# n=5 model=out iset=I1 prefix14_class=11160
cmp P2, P3
mov S2, P1
cmovle S1, P2
cmovle P2, P3
cmovl P3, S1
cmp S2, P0
cmovg S2, P0
cmovg P0, P1
cmovl P1, P0
cmp P0, P2
cmovge P1, P2
cmovl P0, P2
cmp S2, P3
cmovle S0, S2
