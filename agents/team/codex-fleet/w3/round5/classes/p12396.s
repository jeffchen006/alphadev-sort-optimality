# n=5 model=out iset=I1 prefix14_class=12396
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovge S2, P2
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovl S0, P1
cmp P3, S0
cmovle P1, S0
cmovle S0, P3
cmovle P3, P1
mov P2, S2
cmp P0, P2
