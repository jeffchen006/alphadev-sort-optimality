# n=5 model=out iset=I1 prefix14_class=11962
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovge S0, P1
cmp P2, P0
cmovle P1, P2
mov S2, S0
cmovle P2, P0
cmovl P0, P1
mov S1, P3
cmp S0, P2
cmovle S0, P2
cmovg S2, P2
cmovl P2, S2
