# n=5 model=out iset=I1 prefix14_class=11930
mov S0, P1
cmp P1, P2
cmovg S0, P2
cmovge P2, P1
cmp P0, P3
cmovle P1, P0
cmovl P0, P3
cmovle P3, P1
cmp P2, P0
cmovle S2, P0
cmovge S2, P2
cmovg P2, P0
cmp S0, P3
cmovle P1, S0
