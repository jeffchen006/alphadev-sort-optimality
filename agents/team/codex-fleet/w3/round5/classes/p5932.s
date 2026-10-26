# n=5 model=out iset=I1 prefix14_class=5932
mov S0, P2
mov S2, P0
cmp P0, P1
cmovl P0, P1
cmovge S2, P1
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
cmovg P2, P3
cmp P3, P0
cmovg P3, P0
cmovl P2, P0
cmp S2, S0
cmovle P1, S0
