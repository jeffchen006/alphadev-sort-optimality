# n=5 model=out iset=I1 prefix14_class=829
cmp P2, P3
mov S2, P2
cmovg P2, P3
cmovle S2, P3
mov P3, P0
cmp P1, P0
mov S0, S2
cmovg P3, P1
cmovle P0, P1
cmp P3, S2
cmovl S2, P3
cmovge S0, P3
mov P1, S2
mov S0, P0
