# n=5 model=out iset=I1 prefix14_class=12405
mov S1, P3
cmp P1, P3
cmovge S1, P1
mov S2, P0
cmovl P3, P1
cmp P2, S2
cmovl P0, P2
cmovg S2, P2
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovle P3, S0
cmp S2, S1
cmovge P1, S2
