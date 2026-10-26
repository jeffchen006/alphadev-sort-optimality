# n=5 model=out iset=I1 prefix14_class=5801
cmp P3, P2
mov S2, P2
cmovg P2, P3
cmovl S2, P3
cmp P1, P0
cmovg P3, P1
mov S0, S2
cmovg P1, P0
cmovg P0, P3
cmp P1, S0
cmovle S2, P1
cmovge S0, P1
cmp P0, P2
cmovle S2, P2
