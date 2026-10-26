# n=5 model=out iset=I1 prefix14_class=9305
cmp P1, P0
mov S2, P1
cmovg P1, P0
cmovg P0, S2
cmp P2, P3
cmovge S0, P2
cmovle S0, P3
cmovle P3, P2
mov S1, P3
cmp P1, P3
cmovg P3, P1
cmovge P1, S1
cmp P0, S0
cmovl S2, S0
