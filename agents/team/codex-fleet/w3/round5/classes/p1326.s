# n=5 model=out iset=I1 prefix14_class=1326
cmp P1, P2
cmovge S0, P1
cmovl S0, P2
cmovl P2, P1
mov S2, P0
cmovle P1, S0
cmp P0, P3
cmovg P0, P3
cmovg P3, S2
cmp P3, S0
cmovle S0, P3
cmovge P1, P3
cmp P0, P2
mov P1, P2
