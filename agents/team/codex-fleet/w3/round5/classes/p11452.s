# n=5 model=out iset=I1 prefix14_class=11452
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovle P3, P2
cmp P0, P1
mov S0, S2
cmovg P2, P1
cmovg P1, P0
cmovg P0, P2
cmp P0, S0
cmovle S0, P0
cmovge S2, P0
cmp P1, P3
cmovg S1, P3
