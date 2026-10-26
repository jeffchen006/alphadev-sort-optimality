# n=5 model=out iset=I1 prefix14_class=9599
cmp P2, P0
cmovle S1, P2
cmovg S1, P0
cmovg P0, P2
mov S0, P3
cmp P1, P3
mov S2, P0
cmovg P3, P1
cmovg P1, S0
cmp P0, P3
cmovge P0, P3
cmovl S2, P3
cmp P1, S1
cmovge S2, P1
