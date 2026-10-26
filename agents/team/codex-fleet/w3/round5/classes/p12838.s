# n=5 model=out iset=I1 prefix14_class=12838
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovg P1, S2
mov S1, P3
cmp P0, P3
cmovl S1, P0
cmovg P3, P0
cmp P1, S1
mov S0, S1
cmovle S1, P1
cmovle P1, S0
mov S1, P2
mov S0, P1
