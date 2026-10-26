# n=5 model=out iset=I1 prefix14_class=412
mov S1, P0
cmp P3, P0
mov S0, P1
cmovle P0, P3
cmovg S1, P3
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
cmp P0, S0
cmovle S2, P0
cmovg S2, S0
cmovl P0, S0
cmp S1, P2
cmovg S2, P2
