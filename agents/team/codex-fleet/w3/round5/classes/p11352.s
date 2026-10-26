# n=5 model=out iset=I1 prefix14_class=11352
mov S0, P1
cmp P0, P1
cmovg P1, P0
cmovge P0, S0
mov S2, P3
cmp P2, S2
cmovl P3, P2
cmovge S2, P2
cmp P1, S2
cmovle S0, P1
cmovle P1, S2
cmovl S2, S0
cmp P3, P0
cmovle P2, P0
