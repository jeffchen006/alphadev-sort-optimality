# n=5 model=out iset=I1 prefix14_class=12242
mov S2, P1
mov S0, P0
cmp P0, P2
cmovge S0, P2
cmovle P0, P2
cmp P3, P1
cmovge S2, P3
cmovle P1, P3
cmp P1, S0
cmovle S1, P1
cmovl P1, S0
cmovle S0, S1
cmp S2, P0
cmovle P3, S2
