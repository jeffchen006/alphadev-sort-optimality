# n=5 model=out iset=I1 prefix14_class=9972
mov S0, P1
cmp P1, P0
cmovg S0, P0
cmovg P0, P1
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovge P3, S1
cmp P0, P3
cmovg S1, P0
cmovg P0, P3
cmovg P3, S1
cmp P2, S0
cmovl S2, P2
