# n=5 model=out iset=I1 prefix14_class=12213
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovle P0, S1
mov S2, P2
cmp P3, P2
cmovl S2, P3
cmovle P3, P2
cmp S2, P0
cmovle S0, S2
cmovge S0, P0
cmovg P0, S2
cmp P1, P3
mov S0, P1
